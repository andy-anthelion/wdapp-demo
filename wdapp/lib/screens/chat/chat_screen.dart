import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/logout_button.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LogoutButtonModel viewModel = LogoutButtonModel(
      authRepo: context.read(),
    );
    return Scaffold(
      body: Center(
        child: LogoutButton(viewModel: viewModel),
      ),
    );
  }
}
