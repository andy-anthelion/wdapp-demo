import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:result_dart/result_dart.dart' as RD;

import '../models/contact/contact.dart';
import '../models/events/events.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class ContactRepo {

  //tbd make sure you add all event types here
  static const List<Type> CONTACT_EVENT_TYPES = [
    ServerEventContactOnline,
    ServerEventContactOffline,
  ];

  ContactRepo({
    required ApiService apiService,
    required StorageService storageService,
  }): 
    _apiService = apiService,
    _storageService = storageService
  {
    _contactController.stream.listen(_handleContactEvents);
    _contactController.add(_contactSES);
    _contactController.add(_contactUEC.stream);
  }

  final ApiService _apiService;
  final StorageService _storageService;

  Map<Contact, bool>? _cachedContacts;
  Future<List<Contact>> get contacts async {
    // print("ContactRepo: cache = ${_cachedContacts}");
    if(_cachedContacts != null) {
      return _cachedContacts!.keys.toList();
    }
    await _fetch();
    // print("ContactRepo: cache after fetch = ${_cachedContacts}");
    return (_cachedContacts ?? {}).keys.toList();
  }

  final StreamController<UserEvent> _contactUEC = StreamController<UserEvent>();
  Function(UserEvent) get contactSendEvent => _contactUEC.sink.add;

  late final Stream<ServerEvent> _contactSES = _apiService.serverEvents.where(
    (e) => CONTACT_EVENT_TYPES.contains(e.runtimeType)
  );
  Stream<ServerEvent> get contactEvents => _contactSES;

  final StreamGroup<Event> _contactController = StreamGroup<Event>();

  Future<void> _fetch() async {
    RD.Result<String> result = await _storageService.fetchContacts();
    _cachedContacts = result.fold(
      (success) {
        // print("ContactRepo: fetch string = ${success}");
        final jsonData = Map<String, bool>.from(jsonDecode(success));
        // print("ContactRepo: fetch JSON = ${jsonData}");
        return jsonData.map(
          (key, value) => MapEntry<Contact, bool>(
            Contact(id: key),
            value,
          )
        );
      },
      (failure) => null,
    );
  }

  Future<RD.Result<void>> _store() async {
    final Map<String,bool> jsonData = _cachedContacts!.map(
      (key, value) => MapEntry<String, bool>(key.id, value)
    );
    return await _storageService.saveContacts(jsonEncode(jsonData));
  }
  Future<RD.Result<void>> _clear() async => await _storageService.saveContacts(null);

  Future<void> _handleContactEvents(Event event) async {
    // print("handle contact events called in Contact repo ... $event ");
    switch(event) 
    {
      case ServerEventContactOnline():
        (_cachedContacts ??= {})[Contact(id: event.id)] = true;
        await _store();
        // print("Contacts length : ${_cachedContacts.length}");
      case ServerEventContactOffline():
        (_cachedContacts ??= {})[Contact(id: event.id)] = false;
        await _store();
        // print("Contacts length : ${_cachedContacts.length}");
      case UserEventSync():
        await _apiService.synchronize();
      case UserEventLogout():
        _cachedContacts = null;
        await _clear();
      default:
        print("ContactRepo : no handler for event");
    }
  }
}