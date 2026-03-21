import 'package:flutter/material.dart';

import '../models/contact/contact_details.dart'; 

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.contact,
    required this.onTapped,
    this.isCompact = false,
  });

  final ContactDetails contact;
  final GestureTapCallback onTapped;
  final bool isCompact;

  Widget _buildRegular(BuildContext context) {
    return Card(
      elevation: 1.0,
      child:ListTile(
        leading: ContactAvatar(
          name: contact.name,
          count: contact.unread,
        ),
        title : Text(
          "${contact.name} ${contact.age}${contact.gender}"
        ),
        subtitle: Text(contact.location),
        onTap: onTapped,
        hoverColor: Colors.transparent,
      ),
    );
  }

  Widget _buildCompact(BuildContext context) {
    return InkWell(
      onTap: onTapped,
      hoverColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ContactAvatar(
            name: contact.name,
            count: contact.unread,
          ),
          Text(contact.name),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isCompact ? 
      _buildCompact(context):
      _buildRegular(context);
  }
}

class ContactAvatar extends StatelessWidget{
  const ContactAvatar({
    super.key,
    required this.name,
    required this.count,
  });

  final String name;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Badge.count(
      count: count,
      isLabelVisible: count != 0,
      child: CircleAvatar(
        child: Text(
          name.substring(0,2).toUpperCase(),
        ),
      ),
    );
  }
}