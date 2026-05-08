import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'routes.dart';

import '../models/events/events.dart';
import '../repos/app_repo.dart';
import '../repos/auth_repo.dart';

import '../screens/chat_screen.dart';
import '../screens/contacts_screen.dart';
import '../screens/login_screen.dart';

class WDRouter {
  
  Future<String?> _redirectAuthCallback(BuildContext context, GoRouterState state) async {
    final bool loggedIn = await context.read<AuthRepo>().isAuthenticated;
    final bool loggingIn = state.matchedLocation == Routes.login;

    if(!loggedIn) {
      return Routes.login;
    }

    if(loggingIn) {
      return Routes.home;
    }

    return null;
  }

  List<RouteBase> _getAppRoutes() {
    return [
      GoRoute(
        path: Routes.login,
        builder: (context, state) {
          context.read<AppRepo>().stopAppSync();
          return LoginScreen();
        }
      ),
      GoRoute(
        path: Routes.home,
        redirect: (context, state) {
          final isCompact = MediaQuery.sizeOf(context).width <= 600;
          return isCompact ? Routes.contacts : Routes.chat;
        }
      ),
      GoRoute(
        path: Routes.chat,
        builder: (context, state) {
          context.read<AppRepo>().startAppSync();
          return ChatScreen();
        }
      ),
      GoRoute(
        path: Routes.contacts,
        builder: (context, state) {
          return ContactsScreen();
        }
      ),
    ];
  }

  GoRouter routerConfig(AuthRepo authRepo) => GoRouter(
    initialLocation: Routes.home,
    redirect: _redirectAuthCallback,
    refreshListenable: authRepo,
    routes: _getAppRoutes(),
  );
}