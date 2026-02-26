import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LoginFormModel viewModel = LoginFormModel(
      authRepo: context.read(),
    );
    return Scaffold(
      body: Center(
        child: LoginForm(viewModel: viewModel),
      ),
    );
  }
}
