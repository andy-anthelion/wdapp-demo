import 'dart:async';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart' as RD;

import '../repos/app_repo.dart';
import '../repos/auth_repo.dart';
import '../repos/contact_repo.dart';
import '../repos/location_repo.dart';
import '../repos/unread_repo.dart';

import '../models/events/events.dart';
import '../models/contact/contact.dart';
import '../models/contact/contact_details.dart';
import '../widgets/contact_card.dart';

class ContactListModel {

  static const Contact NONE = Contact(id:"");

  List<ContactDetails>? _contacts; 
  Contact? _self;
  final AppRepo _appRepo;
  final AuthRepo _authRepo;
  final ContactRepo _contactRepo;
  final LocationRepo _locationRepo;
  final UnreadRepo _unreadRepo;
  late final StreamController<List<ContactDetails>?> _scContactListModel;
  late final StreamGroup<Event> _sgContactListModel;

  ContactListModel({
    required AppRepo appRepo,
    required AuthRepo authRepo,
    required ContactRepo contactRepo,
    required LocationRepo locationRepo,
    required UnreadRepo unreadRepo,
  }): 
    _appRepo = appRepo,
    _authRepo = authRepo,
    _contactRepo = contactRepo,
    _locationRepo = locationRepo,
    _unreadRepo = unreadRepo
  {
    _scContactListModel = StreamController<List<ContactDetails>?>.broadcast(
      onListen: () => _scContactListModel.sink.add(_contacts),
    );

    _sgContactListModel = StreamGroup<Event>();
    _sgContactListModel.stream.listen(_handleEvents);
    _sgContactListModel.add(appRepo.appUserEvents);
    _sgContactListModel.add(contactRepo.contactEvents);
    _sgContactListModel.add(unreadRepo.unreadEvents);
  }

  Stream<List<ContactDetails>?> get stateStream => _scContactListModel.stream;
  
  Function(int) get tapAction => (int index) { 
    ContactDetails cd = _contacts![index];
    _appRepo.appSendUserEvent(
      UserEventSelectContact(
        age: cd.age,
        gender: cd.gender,
        id: cd.id,
        loc: cd.loc,
        location: cd.location,
        name: cd.name,
        unread: cd.unread,
      )
    ); 
  }; 

  Future<Contact> get self async {
    if(_self != null) {
      return _self!;
    }

    if(await _authRepo.isAuthenticated) {
      return Contact(id: _authRepo.info!['galn']);
    }

    return ContactListModel.NONE;
  }

  Future<List<ContactDetails>> get contacts async {

    // 0. check if contacts is null
    // print("ContactList: ${_contacts}");
    if(_contacts != null) {
      return _contacts!;
    }

    _contacts = <ContactDetails>[];

    Contact contactSelf = await self;
    if(contactSelf == ContactListModel.NONE) {
      return _contacts!;
    }

    // 2. get conversations from Unread Repo, for each convo, get id
    //    put corresponding ContactDetails into "contacts" and update unread count
    for(final MapEntry(key: c, value: count) in _unreadRepo.getAllUnread(contactSelf).entries) {
      await _insertContactIntoContacts(c, count);
    }

    // 3. get contacts from Contact Repo and store in ContactDetails
    List<Contact> repoContacts = await _contactRepo.contacts;
    for(final Contact c in repoContacts) {
      // print("ContactList: From Repo = ${c.id}");
      if(_contacts!.any((ContactDetails cd) => cd.id == c.id)) {
        continue;
      }
      if(c == contactSelf) {
        continue;
      }
      // print("ContactList: Insert into list = ${c.id}");
      await _insertContactIntoContacts(c, 0);
    }

    // print("ContactList: _contacts = ${_contacts}");
    return _contacts!;
  }

  Future<void> _handleEvents(Event event) async {
    bool pushState = true;
    switch(event) {
      case ServerEventContactOnline():
        if((await self).id != event.id) {
          await _insertContactIntoContacts(Contact(id: event.id), 0);
        }
        print("ContactListModel: contact online");

      case ServerEventContactOffline():
        _removeContactFromContacts(Contact(id: event.id));
        print("ContactListModel: contact offline");

      case ServerEventMessageDelivery():
        if(event.toInbox) {
          await _updateUnreadInContacts(Contact(id: event.from));
          print("ContactListModel: message received with contact");
        }

      case UserEventLogout():
        _contacts = null;
        print("ContactListModel: user logged out ");

      case UserEventSelectContact():
        if(event.unread > 0) {
          String userID = _authRepo.info!['galn'];
          await _updateUnreadInContacts(Contact(id: event.id), reset: true);
          _unreadRepo.unreadSendEvent(UserEventReadMessage(id1: userID, id2: event.id));
        }

      default:
        pushState = false;
        print("ContactListModel : no handler for event");
    }

    // print("Checkpoint: pushState = ${pushState}, hasListen = ${_scContactListModel.hasListener}, contacts = ${_contacts}");
    if(pushState) {
      _scContactListModel.sink.add(_contacts);
    }
  }

  Future<void> _removeContactFromContacts(Contact contact) async {
    await contacts;
    _contacts!.removeWhere((ContactDetails c) => c.id == contact.id);
  }

  Future<void> _updateUnreadInContacts(Contact contact, {bool reset = false}) async {
    int index = (await contacts).indexWhere((ContactDetails c) => c.id == contact.id);
    if(index == -1) {
      await _insertContactIntoContacts(contact, reset ? 0: 1);
    } else {
      final int unread = _contacts![index].unread + 1; 
      final ContactDetails cd = _contacts![index].copyWith(unread: reset ? 0 : unread);
      await _removeContactFromContacts(contact);
      await _insertIntoContacts(cd);
    }
  }

  Future<void> _insertContactIntoContacts(Contact newContact, int unreadCount) async {
    RD.Result<String> result = await _locationRepo.getLocationName(newContact.loc);
    await _insertIntoContacts(ContactDetails(
      gender: newContact.gender,
      age: newContact.age,
      loc: newContact.loc,
      name: newContact.name,
      location: result.getOrDefault(""),
      unread: unreadCount,
      timestamp: 0,
      message: ""
    ));
  }

  Future<void> _insertIntoContacts(ContactDetails newContact) async {
    await contacts;
    // assume list is sorted
    if(_contacts!.isEmpty) {
      _contacts!.add(newContact);
    } else {
      //find the best position to insert in sorted list
      int insertAt = 0;

      //insert by name, loc and unread
      insertAt = _contacts!.indexWhere((ContactDetails c) {
        return c.name.compareTo(newContact.name) > 0 && 
              c.loc.compareTo(newContact.loc) == 0 && 
              c.unread == newContact.unread;
      });
      if(insertAt != -1) {
        _contacts!.insert(insertAt, newContact);
        return;  
      }

      //insert by loc and unread
      insertAt = _contacts!.indexWhere((ContactDetails c) {
        return c.loc.compareTo(newContact.loc) > 0 && 
              c.unread == newContact.unread;
      });
      if(insertAt != -1) {
        _contacts!.insert(insertAt, newContact);
        return;  
      }

      // insert by unread
      insertAt = _contacts!.indexWhere((ContactDetails c) => c.unread < newContact.unread); 
      if(insertAt != -1 ) {
        _contacts!.insert(insertAt, newContact);
        return;
      }
  
      // insert at end
      _contacts!.insert(_contacts!.length, newContact);
    }
  }
}

class ContactList extends StatelessWidget {
  ContactList({
    super.key,
    required this.viewModel,
  }): tapAction = viewModel.tapAction;

  final ContactListModel viewModel;
  final Function(int) tapAction;

  Widget _buildRegular(
    BuildContext context,
    List<ContactDetails>? contacts,
  ) {
    return ListView.builder(
      itemCount: contacts?.length,
      itemBuilder: (BuildContext context, int index) {
        return ContactCard(
          contact: contacts![index],
          onTapped: () => tapAction(index),
        );
      },
    );
  }

  Widget _buildCompact(
    BuildContext context,
    List<ContactDetails>? contacts,
  ) {
    return GridView.builder(
      padding: EdgeInsets.all(4.0),
      itemCount: contacts?.length,
      itemBuilder: (BuildContext context, int index) {
        return ContactCard(
          contact: contacts![index],
          onTapped: () => tapAction(index),
          isCompact: true,
        );
      },
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 90,
        mainAxisExtent: 70,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (
        BuildContext context, 
        BoxConstraints constraints
      ) => FutureBuilder<List<ContactDetails>?> (
        future: viewModel.contacts,
        initialData: null,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<ContactDetails>?> futureSnapshot,
        ){
          if(futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading ..."));
          }
          return StreamBuilder<List<ContactDetails>?> (
            stream: viewModel.stateStream,
            initialData: futureSnapshot.data,
            builder: (
              BuildContext context, 
              AsyncSnapshot<List<ContactDetails>?> snapshot
            ){
              // print("Checkpoint: hasData=${snapshot.hasData} hasError=${snapshot.hasError} state=${snapshot.connectionState.toString()}");
              // print(snapshot.data);
              if(snapshot.data == null || snapshot.data?.length == 0) {
                return Center(child: Text("No Contacts!"));
              }
              return (constraints.maxHeight < 500) ? 
                _buildCompact(context, snapshot.data):
                _buildRegular(context, snapshot.data);
            },
          );
        },
      ),  
    );
  }
}