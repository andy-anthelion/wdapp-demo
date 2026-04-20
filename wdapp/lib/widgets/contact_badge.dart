import 'dart:async';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

import '../repos/app_repo.dart';

import '../models/events/events.dart';
import '../models/contact/contact_details.dart';
import 'contact_card.dart' show ContactAvatar;

class ContactBadgeModel {
  ContactBadgeModel({
    required AppRepo appRepo,
  }): 
    _appRepo = appRepo
  {
    _sgContactBadgeModel.stream.listen(_handleEvents);
    _sgContactBadgeModel.add(_appRepo.appUserEvents);
  }

  final AppRepo _appRepo;

  ContactDetails? contact = null;

  final StreamController<ContactDetails?> _scContactBadgeModel = StreamController<ContactDetails?>.broadcast();
  Stream<ContactDetails?> get stateStream => _scContactBadgeModel.stream;

  final StreamGroup<Event> _sgContactBadgeModel = StreamGroup<Event>();

  Future<void> _handleEvents(Event event) async {
    switch(event) {
      case UserEventSelectContact():
        contact = ContactDetails(
          age: event.age,
          gender: event.gender,
          loc : event.loc,
          location : event.location,
          name: event.name,
          message: "",
          unread: 0,
          timestamp: 0,
        );
        _scContactBadgeModel.sink.add(contact);
      default:
        print("ContactBadgeModel : no handler for event");
    }
  }
}

class ContactBadge extends StatelessWidget {
  const ContactBadge({
    super.key,
    required this.viewModel,
  });

  final ContactBadgeModel viewModel;

  Widget _buildRegular(
    BuildContext context,
    ContactDetails? contact
  ){
    return Card(
      elevation: 0.0,
      color: ColorScheme.of(context).surfaceContainer,
      child: ListTile(
        leading: ContactAvatar(
          name: contact!.name,
          count: 0,
        ),
        title: Text(
          "${contact!.name} ${contact!.age}${contact!.gender}"
        ),
        subtitle: Text(
          contact!.location,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: viewModel.stateStream,
      initialData: viewModel.contact,
      builder: (
        BuildContext context, 
        AsyncSnapshot<ContactDetails?> snapshot
      ){
        if(snapshot.data == null) {
          return SizedBox(height: 72);
        }
        return _buildRegular(context, snapshot.data);
      },
    );
  }
}