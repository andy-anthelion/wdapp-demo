import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/dependencies.dart';

import '../repos/auth_repo.dart';

import '../routing/wd_router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: providersBetaConfig,
      child: const MainApp(),
    )
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // use media query here to get screen size
    WDRouter wdRouter = WDRouter();
    return MaterialApp.router(
      routerConfig: wdRouter.routerConfig(context.read<AuthRepo>()),
    );
  }
}
