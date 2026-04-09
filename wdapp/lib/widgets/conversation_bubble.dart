import 'package:flutter/material.dart';

import '../models/message/message.dart';

class ConversationBubbleTray extends StatelessWidget {
  const ConversationBubbleTray({
    super.key,
    required this.message,
    required this.isUsers,
  });

  final Message message;
  final bool isUsers;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing : 4.0,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        if(isUsers == true) Spacer(),
        ConversationBubble(
          message: message,
          isUsers: isUsers,
        ),
        if(isUsers == false) Spacer(),
      ],
    );
  }
}

class ConversationBubble extends StatelessWidget {
  const ConversationBubble({
    super.key,
    required this.message,
    required this.isUsers,
  });

  final Message message;
  final bool isUsers;

  @override
  Widget build(BuildContext context) {
    final DateTime dt = DateTime.fromMillisecondsSinceEpoch(
      message.timestamp
    );
    final String hhmm = "${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}";
    final Widget widgetTime = Text(
      hhmm,
      style: TextTheme.of(context).bodySmall,
    );
    final cardColor = isUsers ? 
      ColorScheme.of(context).primaryContainer :
      ColorScheme.of(context).surface;
    final textColor = isUsers ?
      ColorScheme.of(context).onPrimaryContainer :
      ColorScheme.of(context).onSurface;
    return Card(
      elevation: 1.0,
      color: cardColor,
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: Row(
          spacing : 4.0,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 310,
              ),
              child: Text(
                message.message,
                style: TextTheme.of(context).bodyLarge!.copyWith(
                  color: textColor,
                ),
              ),
            ),
            widgetTime,
          ],
        ),
      ),
    );
  }
}