import 'dart:async';

import 'package:async/async.dart';

import '../models/events/events.dart';

class AppRepo {

  final StreamController<UserEvent> _appUEC = StreamController<UserEvent>.broadcast();
  Function(UserEvent) get appSendUserEvent => _appUEC.sink.add;
  Stream<UserEvent> get appUserEvents => _appUEC.stream;

}