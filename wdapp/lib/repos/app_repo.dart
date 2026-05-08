import 'dart:async';

import 'package:async/async.dart';
import 'package:result_dart/result_dart.dart' as RD;

import '../models/events/events.dart';
import '../services/api_service.dart';
import '../services/random_service.dart';
import '../services/storage_service.dart';

class AppRepo {

  final ApiService _apiService;
  final RandomService _randomService;
  final StorageService _storageService;
  final StreamController<UserEvent> _appUEC = StreamController<UserEvent>.broadcast();

  AppRepo({
    required ApiService apiService,
    required RandomService randomService,
    required StorageService storageService,
  }):
    _apiService = apiService,
    _randomService = randomService,
    _storageService = storageService;

  Function(UserEvent) get appSendUserEvent => _appUEC.sink.add;
  Stream<UserEvent> get appUserEvents => _appUEC.stream;

  Future<void> startAppSync() async {
    String nonce = await _randomService.generateNonce();
    RD.Result<void> result = await _storageService.saveSyncNonce(nonce);
    if(result.isSuccess()) {
      _syncTimer(nonce);
    }
  }

  Future<void> stopAppSync() async => await _storageService.saveSyncNonce(null); 

  Future<void> _syncTimer(String nonce, {int duration=30}) async {
    // fetch nonce from storage
    RD.Result<String> result = await _storageService.fetchSyncNonce();
    String storageNonce = result.getOrDefault("");
    // check nonce 
    if(storageNonce != nonce) {
      print("SyncTimer: ${storageNonce} , ${nonce} : Nonce mismatch! Terminating");
      return;
    }
    //TBD update duration based on sync success
    await _apiService.synchronize();
    Future.delayed(Duration(seconds: duration), () => _syncTimer(nonce, duration: duration));
  }
}