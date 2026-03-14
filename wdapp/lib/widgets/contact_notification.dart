import 'package:flutter/material.dart';

import '../models/contact/contact_details.dart'; 

class UnreadMessageCounter extends StatelessWidget {
  const UnreadMessageCounter({
    super.key,
    required this.count,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorScheme.of(context).tertiary,
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(4),
      child: Text(
        '$count',
        style: TextTheme.of(context).bodySmall!.copyWith(
          color: ColorScheme.of(context).onTertiary,
          //height: 1.0,
        ),
      ),
    );
  }
}

class ContactNotification extends StatelessWidget {
  const ContactNotification({
    super.key,
    required this.contact,
    this.isSelected = false,
  });

  final ContactDetails contact;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    DateTime dt =  DateTime.fromMillisecondsSinceEpoch(contact.timestamp);
    final String formattedTime = "${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}";
    final Color color = isSelected ? 
      ColorScheme.of(context).onPrimaryContainer :
      ColorScheme.of(context).onSurfaceVariant;
    final bool hasUnread = contact.unread > 0;
    final tsColor = hasUnread ?
      ColorScheme.of(context).tertiary:
      color;
    return Container(
      //padding: const EdgeInsets.all(4.0),
      child: Row(
        spacing: 4.0,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Text(
              contact.message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextTheme.of(context).bodySmall!.copyWith(
                color: color,
                //height: 1.0,
              ),
            ),
          ),
          Text(
            formattedTime,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextTheme.of(context).bodySmall!.copyWith(
              color: tsColor,
              fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
              //height: 1.0,
            ),
          ),
          if(hasUnread) UnreadMessageCounter(count: contact.unread),
        ],
      ),
    );
  }
}