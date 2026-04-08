import 'dart:async';
import 'package:flutter/material.dart';

import '../repos/app_repo.dart';

import '../models/events/events.dart';
import '../models/contact/contact.dart';
import '../models/contact/contact_details.dart';
import '../widgets/contact_card.dart';

class ContactListModel {
  ContactListModel({
    required AppRepo appRepo,
  }): 
    _appRepo = appRepo
  {
    const mj = Contact(id:'+23USCA.MaryJane....');
    contacts = <ContactDetails> [
      ContactDetails(
        name: mj.name,
        age: mj.age,
        loc: mj.loc,
        gender: mj.gender,
        unread: 0,
        timestamp: 0,
        location: 'California (United States of America)',
        message: 'How is everything Mary?',
      ),
      ContactDetails(
        name: mj.name,
        age: mj.age,
        loc: mj.loc,
        gender: mj.gender,
        unread: 3,
        timestamp: 0,
        location: 'New Jersy (United States of America)',
        message: 'Mary me!!',
      ),
    ];
  }

  List<ContactDetails>? contacts;

  final AppRepo _appRepo;

  final StreamController<List<ContactDetails>?> _scContactListModel = StreamController<List<ContactDetails>?>();
  Stream<List<ContactDetails>?> get stateStream => _scContactListModel.stream;

  Function(int) get tapAction => (int index) { 
    _appRepo.appSendUserEvent(
      UserEventSelectContact(
        age: contacts![index].age,
        gender: contacts![index].gender,
        loc: contacts![index].loc,
        location: contacts![index].location,
        name: contacts![index].name,
      )
    ); 
  }; 

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