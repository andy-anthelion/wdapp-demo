import 'dart:async';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../services/api_service.dart';
import '../services/event_service.dart';
import '../services/location_service.dart';
import '../services/random_service.dart';
import '../services/storage_service.dart';

import '../repos/app_repo.dart';
import '../repos/auth_repo.dart';
import '../repos/contact_repo.dart';
import '../repos/location_repo.dart';
import '../repos/message_repo.dart';
import '../repos/unread_repo.dart';

import '../widgets/contact_badge.dart';
import '../widgets/contact_list.dart';
import '../widgets/conversation_list.dart';
import '../widgets/logout_button.dart';

List<SingleChildWidget> get providersBetaConfig {
  return [
    Provider(create: (context) => LocationService(), lazy: false),
    Provider(create: (context) => RandomService(), lazy: false),
    Provider(create: (context) => StorageService(), lazy: false),
    Provider(create: (context) => WDEventService() as EventService, lazy: false),
    Provider(create: (context) => ApiService(
      eventTransformer: StreamTransformer.fromHandlers(
        handleData: context.read<EventService>().handleData,
        handleError: context.read<EventService>().handleError,
        handleDone: context.read<EventService>().handleDone,
      )
    ), lazy: false),
    Provider(create: (context) => AppRepo(), lazy: false),
    ChangeNotifierProvider(create: (context) => AuthRepo(
      apiService: context.read<ApiService>(),
      storageService: context.read<StorageService>(),
    ), lazy: false),
    Provider(create: (context) => ContactRepo(
      apiService: context.read<ApiService>(),
    ), lazy: false),
    Provider(create: (context) => LocationRepo(
      locationService: context.read<LocationService>(),
    ), lazy: false),
    Provider(create: (context) => MessageRepo(
      apiService: context.read<ApiService>(),
      randomService: context.read<RandomService>(),
    ), lazy: false),
    Provider(create: (context) => UnreadRepo(
      apiService: context.read<ApiService>(),
    ), lazy: false),
    Provider(create: (context) => ContactBadgeModel(
      appRepo: context.read<AppRepo>(),
    ), lazy: false),
    Provider(create: (context) => ContactListModel(
      appRepo: context.read<AppRepo>(),
      authRepo: context.read<AuthRepo>(),
      contactRepo: context.read<ContactRepo>(),
      locationRepo: context.read<LocationRepo>(),
      unreadRepo: context.read<UnreadRepo>(),
    ), lazy: false),
    Provider(create: (context) => ConversationListModel(
      appRepo: context.read<AppRepo>(),
    ), lazy: false),
    Provider(create: (context) => LogoutButtonModel(
      appRepo: context.read<AppRepo>(),
      authRepo: context.read<AuthRepo>(),
    ), lazy: false),
  ];
}

