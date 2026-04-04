import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/logout_button.dart';

class ContactHeader extends StatelessWidget {
  const ContactHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    LogoutButtonModel viewModel = LogoutButtonModel(
      authRepo: context.read()
    );
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "WingDing",
              style: TextTheme.of(context).headlineLarge!.copyWith(
                color: ColorScheme.of(context).onSurfaceVariant,
              ),
            ),
          ),
          LogoutButton(viewModel: viewModel),
        ],
      ),
    );
  }
}