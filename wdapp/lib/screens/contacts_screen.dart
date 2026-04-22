import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/logout_button.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: Center(
        child: LogoutButton(viewModel: context.read()),
      ),
    );
  }
}
