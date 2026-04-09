import 'dart:async';
import 'package:flutter/material.dart';

import '../repos/app_repo.dart';

import '../models/events/events.dart';
import '../models/contact/contact.dart';
import '../models/contact/contact_details.dart';
import '../models/message/message.dart';
import '../widgets/conversation_bubble.dart';

class ConversationListModel {
  ConversationListModel({
    required AppRepo appRepo,
  }): 
    _appRepo = appRepo
  {
    selectedID = '+23USCA.MaryJane....';
    messages = <Message>[
      Message(
        from: '+23USCA.MaryJane....',
        to: '-30US...JohnDoe.....',
        message: 'How are you doing?',
        nonce: '34nsds',
        timestamp: 300000,
      ),
      Message(
        to: '+23USCA.MaryJane....',
        from: '-30US...JohnDoe.....',
        message: 'I am doing great and all but lets see if this becomes multiline or does it reamin in single line lol!',
        nonce: '34nsds',
        timestamp: 600000,
      ),
    ];
  }

  String? selectedID;
  List<Message>? messages;

  final AppRepo _appRepo;

  final StreamController<List<Message>?> _scConvoListModel = StreamController<List<Message>?>();
  Stream<List<Message>?> get stateStream => _scConvoListModel.stream;
}

class ConversationList extends StatelessWidget {
  ConversationList({
    super.key,
    required this.viewModel,
  });

  final ConversationListModel viewModel;

  Widget _buildRegular(
    BuildContext context,
    List<Message>? messages
  ) {
    return ListView.builder(
      itemCount: messages?.length,
      itemBuilder: (BuildContext context, int index) {
        return ConversationBubbleTray(
          message: messages![index],
          isUsers: viewModel.selectedID == messages![index].to,
        );
      },
    );
  }

  Widget _buildCompact(
    BuildContext context,
    List<Message>? messages
  ) {
    return _buildRegular(context, messages);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        bool isCompact = constraints.maxHeight < 500;
        return StreamBuilder(
          stream: viewModel.stateStream,
          initialData: viewModel.messages,
          builder: (
            BuildContext context, 
            AsyncSnapshot<List<Message>?> snapshot
          ){
            if(snapshot.data == null || snapshot.data?.length == 0) {
              return Center(child: Text("No Messages!"));
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
