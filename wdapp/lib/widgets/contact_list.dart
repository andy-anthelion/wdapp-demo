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

  List<ContactDetails>? contacts; 

  final AppRepo _appRepo;
  final AuthRepo _authRepo;
  final ContactRepo _contactRepo;
  final LocationRepo _locationRepo;
  final UnreadRepo _unreadRepo;
  final StreamController<List<ContactDetails>?> _scContactListModel = StreamController<List<ContactDetails>?>.broadcast();
  final StreamGroup<Event> _sgContactListModel = StreamGroup<Event>();

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
    // const mj1 = Contact(id:'+23USCA.ZaryJane....');
    // const mj2 = Contact(id:'+25USCA.MaryJane....');
    // contacts = <ContactDetails> [
    //   ContactDetails(
    //     name: mj1.name,
    //     age: mj1.age,
    //     loc: mj1.loc,
    //     gender: mj1.gender,
    //     unread: 3,
    //     timestamp: 0,
    //     location: 'California (United States of America)',
    //     message: 'How is everything Mary?',
    //   ),
    //   ContactDetails(
    //     name: mj2.name,
    //     age: mj2.age,
    //     loc: mj2.loc,
    //     gender: mj2.gender,
    //     unread: 0,
    //     timestamp: 0,
    //     location: 'New Jersy (United States of America)',
    //     message: 'Mary me!!',
    //   ),
    // ];

    _sgContactListModel.stream.listen(_handleEvents);
    _sgContactListModel.add(appRepo.appUserEvents);
    _sgContactListModel.add(contactRepo.contactEvents);
    _sgContactListModel.add(unreadRepo.unreadEvents);
  }

  Stream<List<ContactDetails>?> get stateStream => _scContactListModel.stream;
  
  Function(int) get tapAction => (int index) { 
    _appRepo.appSendUserEvent(
      UserEventSelectContact(
        age: contacts![index].age,
        gender: contacts![index].gender,
        id: contacts![index].id,
        loc: contacts![index].loc,
        location: contacts![index].location,
        name: contacts![index].name,
        unread: contacts![index].unread,
      )
    ); 
  }; 

  void initalize() {

    // 0. check if contacts is null
    if(contacts != null) {
      return;
    }

    // 1. get id from Auth Repo and store
    String? id = _authRepo.info != null ? _authRepo.info!['galn'] : null;
    if(id == null) {
      return;
    }

    Contact self = Contact(id: id);
    // 2. get conversations from Unread Repo, for each convo, get id
    //    put corresponding ContactDetails into "contacts" and update unread count
    _unreadRepo.getAllUnread(self).forEach((Contact c, int count) {
      _insertContactIntoContacts(c, count);
    });

    // 3. get contacts from Contact Repo and store in ContactDetails
    _contactRepo.contacts().forEach((Contact c) {
      if(contacts!.any((ContactDetails cd) => cd.id == c.id)) {
        return;
      }
      _insertContactIntoContacts(c, 0);
    });
  }

  void _handleEvents(Event event) {
    bool pushState = true;
    switch(event) {
      case ServerEventContactOnline():
        _insertContactIntoContacts(Contact(id: event.id), 0);
        print("ContactListModel: contact online");

      case ServerEventContactOffline():
        _removeContactFromContacts(Contact(id: event.id));
        print("ContactListModel: contact offline");

      case ServerEventMessageDelivery():
        if(event.toInbox) {
          _updateUnreadInContacts(Contact(id: event.from));
          print("ContactListModel: message received with contact");
        }

      case UserEventLogout():
        contacts = null;
        print("ContactListModel: user logged out ");

      case UserEventSelectContact():
        if(event.unread > 0) {
          String userID = _authRepo.info!['galn'];
          _updateUnreadInContacts(Contact(id: event.id), reset: true);
          _unreadRepo.unreadSendEvent(UserEventReadMessage(id1: userID, id2: event.id));
        }

      default:
        pushState = false;
        print("ContactListModel : no handler for event");
    }

    if(pushState && _scContactListModel.hasListener) {
      _scContactListModel.sink.add(contacts);
    }
  }

  void _removeContactFromContacts(Contact contact) {
    contacts!.removeWhere((ContactDetails c) => c.id == contact.id);
  }

  void _updateUnreadInContacts(Contact contact, {bool reset = false}) {
    int index = contacts!.indexWhere((ContactDetails c) => c.id == contact.id);
    if(index == -1) {
      _insertContactIntoContacts(contact, reset ? 0: 1);
    } else {
      final int unread = contacts![index].unread + 1; 
      final ContactDetails cd = contacts![index].copyWith(unread: reset ? 0 : unread);
      _removeContactFromContacts(contact);
      _insertIntoContacts(cd);
      // print(contacts);
    }
  }

  void _insertContactIntoContacts(Contact newContact, int unreadCount) {
    _locationRepo.getLocationName(newContact.loc).then((RD.Result<String> result) {
      _insertIntoContacts(ContactDetails(
        gender: newContact.gender,
        age: newContact.age,
        loc: newContact.loc,
        name: newContact.name,
        location: result.getOrDefault(""),
        unread: unreadCount,
        timestamp: 0,
        message: ""
      ));
    });
  }

  void _insertIntoContacts(ContactDetails newContact) {
    contacts ??= [];
    // assume list is sorted
    if(contacts!.isEmpty) {
      contacts!.add(newContact);
    } else {
      //find the best position to insert in sorted list
      int insertAt = 0;

      //insert by name, loc and unread
      insertAt = contacts!.indexWhere((ContactDetails c) {
        return c.name.compareTo(newContact.name) > 0 && 
              c.loc.compareTo(newContact.loc) == 0 && 
              c.unread == newContact.unread;
      });
      if(insertAt != -1) {
        contacts!.insert(insertAt, newContact);
        return;  
      }

      //insert by loc and unread
      insertAt = contacts!.indexWhere((ContactDetails c) {
        return c.loc.compareTo(newContact.loc) > 0 && 
              c.unread == newContact.unread;
      });
      if(insertAt != -1) {
        contacts!.insert(insertAt, newContact);
        return;  
      }

      // insert by unread
      insertAt = contacts!.indexWhere((ContactDetails c) => c.unread < newContact.unread); 
      if(insertAt != -1 ) {
        contacts!.insert(insertAt, newContact);
        return;
      }
  
      // insert at end
      contacts!.insert(contacts!.length, newContact);
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
      builder: (BuildContext context, BoxConstraints constraints) {
        bool isCompact = constraints.maxHeight < 500;
        return StreamBuilder(
          stream: viewModel.stateStream,
          initialData: viewModel.contacts,
          builder: (
            BuildContext context, 
            AsyncSnapshot<List<ContactDetails>?> snapshot
          ){
            if(snapshot.data == null || snapshot.data?.length == 0) {
              return Center(child: Text("No Contacts!"));
            }
            return isCompact ? 
              _buildCompact(context, snapshot.data):
              _buildRegular(context, snapshot.data);
          }
        );  
      },
    );
  }
}