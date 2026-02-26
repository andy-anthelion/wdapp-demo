import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:result_dart/result_dart.dart';

import '../repos/auth_repo.dart';
import '../routing/routes.dart';

class LogoutButtonModel {
  LogoutButtonModel({
    required AuthRepo authRepo,
  }): _authRepo = authRepo;

  final AuthRepo _authRepo;

  Future<Result<void>> logout() async => _authRepo.logout();
}

class LogoutButton extends StatefulWidget {
  final LogoutButtonModel viewModel;

  const LogoutButton({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  bool isActive = false;

  void _renderSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        showCloseIcon: true,
      ),
    );  
  }

  void _handleLogout() {
    setState(() { isActive = true; });
    widget.viewModel.logout()
    .then((Result<void> result) {
      result.fold((void _) {
        GoRouter.of(context).go(Routes.home);
      },(failure) {
        _renderSnackBar("Login Failed! ${failure.toString()}");
      });
    })
    .whenComplete(() => setState(() { isActive = false; }));
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
