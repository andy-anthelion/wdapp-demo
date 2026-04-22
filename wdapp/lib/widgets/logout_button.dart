import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:result_dart/result_dart.dart';

import "../models/events/events.dart";
import '../repos/auth_repo.dart';
import '../repos/app_repo.dart';
import '../routing/routes.dart';

class LogoutButtonModel {
  LogoutButtonModel({
    required AuthRepo authRepo,
    required AppRepo appRepo,
  }):
    _authRepo = authRepo,
    _appRepo = appRepo
  {}

  final AuthRepo _authRepo;
  final AppRepo _appRepo;

  Future<Result<void>> logout() async => _authRepo.logout();

  void sendLogoutEvent() => _appRepo.appSendUserEvent(UserEventLogout());
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
        widget.viewModel.sendLogoutEvent();
        GoRouter.of(context).go(Routes.home);
      },(failure) {
        _renderSnackBar("Logout Failed! ${failure.toString()}");
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
      padding: const EdgeInsets.all(8.0),
      constraints: const BoxConstraints(),
      hoverColor: Colors.transparent,
      splashRadius: 24,
    );
  }
}
