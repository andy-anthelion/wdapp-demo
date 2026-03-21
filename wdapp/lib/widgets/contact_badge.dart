import 'package:flutter/material.dart';

import '../models/contact/contact_details.dart'; 

class ContactBadge extends StatelessWidget {
  const ContactBadge({
    super.key,
    required this.contact,
    this.isSelected = false,
  });

  final ContactDetails contact;
  final bool isSelected;

  @override
  Widget build(BuildContext context){
    final color = isSelected ? 
      ColorScheme.of(context).onPrimaryContainer :
      ColorScheme.of(context).onSurface;
    return Container(
      //padding: const EdgeInsets.all(4.0),
      child: Row(
        spacing: 4.0,
        children: <Widget>[
          CircleAvatar(
            child: Text(
              contact.name.substring(0, 2).toUpperCase()
            ),
          ),
          Expanded(
            child: Column(
              //spacing: 2.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "${contact.name} ${contact.age}${contact.gender}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextTheme.of(context).titleLarge!.copyWith(
                    color: color,
                    height: 1.0,
                  ),
                ),
                Text(
                  contact.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextTheme.of(context).titleMedium!.copyWith(
                    color: color,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}