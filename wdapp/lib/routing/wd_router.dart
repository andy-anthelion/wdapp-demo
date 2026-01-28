import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'routes.dart';

import '../repos/auth_repo.dart';

import '../screens/login/login_screen.dart';
import '../screens/chat/chat_screen.dart';

class WDRouter {

  //WDSize
  
  Future<String?> _redirectCallback(BuildContext context, GoRouterState state) async {
    final bool loggedIn = await context.read<AuthRepo>().isAuthenticated;
    final bool loggingIn = state.matchedLocation == Routes.login;

    if(!loggedIn) {
      return Routes.login;
    }

    if(loggedIn) {
      return Routes.home;
    }

    return null;
  }

  List<RouteBase> _getAppRoutes(AuthRepo authRepo) {
    return [
      GoRoute(
        path: Routes.login,
        builder: (context, state) {
          return LoginScreen();
        }
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) {
          return ChatScreen();
        }
      ),
    ];
  }

  GoRouter routerConfig(AuthRepo authRepo) => GoRouter(
    initialLocation: Routes.home,
    redirect: _redirectCallback,
    refreshListenable: authRepo,
    routes: _getAppRoutes(authRepo),
  );
}