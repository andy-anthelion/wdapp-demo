import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/login_form.dart';
import '../widgets/logo.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> screenContent = <Widget>[
      Flexible(child: const Logo()),
      Card(
        color: ColorScheme.of(context).surface,
        elevation: 5.0,
        child: LoginForm(
          viewModel: LoginFormModel(
            authRepo: context.read(),
          )
        )
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final isPotrait = constraints.maxWidth < constraints.maxHeight;
        return Center(
          child: (isPotrait) ?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: screenContent
          ) :
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: screenContent, 
          ), 
        );
      }
    );
  }
}