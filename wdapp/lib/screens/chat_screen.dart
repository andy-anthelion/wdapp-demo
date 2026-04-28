import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/contact/contact.dart';
import '../models/contact/contact_details.dart';
import '../models/message/message.dart';
import '../widgets/logout_button.dart';
import '../widgets/contact_header.dart';
import '../widgets/contact_badge.dart';
import '../widgets/contact_list.dart';
import '../widgets/conversation_bar.dart';
import '../widgets/conversation_list.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorScheme.of(context).surfaceContainer,
      body: Center(
        child: Row(
        spacing: 4.0,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget> [
          Flexible(
            child: SizedBox(),
          ),
          SizedBox(
            width: 331,
            child: Column(
              children: <Widget>[
                const ContactHeader(),
                Expanded(
                  child: ContactList(
                    viewModel: context.read(),
                  ),
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 610,
              minWidth: 331,
            ),
            child: Column(
              children: <Widget>[
                ContactBadge(
                  viewModel: context.read(),
                ),
                Expanded(
                  child: ConversationList(
                    viewModel: context.read(),
                  ),
                ),
                ConversationBar(),
              ],
            ),
          ),
          Flexible(
            child: SizedBox(),
          ),
        ],
      ),
    ),
    );   
  }
}
