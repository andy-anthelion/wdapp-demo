import 'package:flutter/material.dart';

class LogoutButton extends StatefulWidget {
  final Function() onSubmit;

  const LogoutButton({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  bool isActive = false;

  Future<void> _handleLogout() async {
    setState(() { isActive = true; });
    widget.onSubmit();
    setState(() { isActive = false; });
  }

  Widget _renderButtonContent(BuildContext context) {
    return isActive
        ? SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
              strokeWidth: 2,
            ),
          )
        : Icon(
            Icons.logout,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isActive ? null : _handleLogout,
      icon: _renderButtonContent(context),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: 24,
    );
  }
}
