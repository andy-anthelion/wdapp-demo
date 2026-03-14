import 'package:flutter/material.dart';

import '../models/contact/contact_details.dart'; 
import 'contact_badge.dart';
import 'contact_notification.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.contact,
    this.isSelected = false,
  });

  final ContactDetails contact;
  final bool isSelected;

  @override
  Widget build(BuildContext context){
    return Card(
      color: isSelected ? 
        ColorScheme.of(context).primaryContainer :
        ColorScheme.of(context).surface,
      elevation: 2.0,
      child: Container(
        constraints: BoxConstraints(
          //maxHeight: 100,
          //maxWidth: 377,
        ),
        padding: EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 2.0,
          children: <Widget>[
            ContactBadge(
              contact: contact,
              isSelected: isSelected,
            ),
            ContactNotification(
              contact: contact,
              isSelected: isSelected,
            ),
          ],  
        ),
      ), 
    );
  }
}