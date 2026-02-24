import 'dart:async';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../services/api_service.dart';
import '../services/event_service.dart';
import '../services/location_service.dart';
import '../services/random_service.dart';
import '../services/storage_service.dart';

import '../repos/auth_repo.dart';
import '../repos/contact_repo.dart';
import '../repos/location_repo.dart';
import '../repos/message_repo.dart';
import '../repos/unread_repo.dart';

List<SingleChildWidget> get providersBetaConfig {
  return [
    Provider(create: (context) => LocationService()),
    Provider(create: (context) => RandomService()),
    Provider(create: (context) => StorageService()),
    Provider(create: (context) => WDEventService() as EventService),
    Provider(create: (context) => ApiService(
      eventTransformer: StreamTransformer.fromHandlers(
        handleData: context.read<EventService>().handleData,
        handleError: context.read<EventService>().handleError,
        handleDone: context.read<EventService>().handleDone,
      )
    )),
    ChangeNotifierProvider(create: (context) => AuthRepo(
      apiService: context.read<ApiService>(),
      storageService: context.read<StorageService>(),
    )),
    Provider(create: (context) => ContactRepo(
      apiService: context.read<ApiService>(),
    )),
    Provider(create: (context) => LocationRepo(
      locationService: context.read<LocationService>(),
    )),
    Provider(create: (context) => MessageRepo(
      apiService: context.read<ApiService>(),
      randomService: context.read<RandomService>(),
    )),
    Provider(create: (context) => UnreadRepo(
      apiService: context.read<ApiService>(),
    )),
  ];
}

