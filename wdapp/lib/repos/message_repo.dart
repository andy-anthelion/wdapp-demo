import 'dart:async';
import 'dart:convert';

import 'package:result_dart/result_dart.dart' as RD;
import 'package:async/async.dart';

import '../models/conversation/conversation.dart';
import '../models/events/events.dart';
import '../models/message/message.dart';
import '../models/message_request/message_request.dart';
import '../services/api_service.dart';
import '../services/random_service.dart';
import '../services/storage_service.dart';

class MessageRepo {

  static const List<Type> MESSAGE_EVENT_TYPES = [
    ServerEventMessageDelivery,
  ];

  MessageRepo({
    required ApiService apiService,
    required RandomService randomService,
    required StorageService storageService,
  }):
    _apiService = apiService,
    _randomService = randomService,
    _storageService = storageService
  {

    _messageController.stream.listen(_handleMessageEvents);
    _messageController.add(_messageSES);
    _messageController.add(_messageUEC.stream);

  }

  final ApiService _apiService;
  final RandomService _randomService;
  final StorageService _storageService;

  Map<Conversation,List<Message>>? _cachedMessage;
  Future<Map<Conversation,List<Message>>> get messages async {
    if(_cachedMessage != null) {
      return _cachedMessage!;
    }
    await _fetch();
    return _cachedMessage! ?? {};
  }
  
  final StreamController<UserEvent> _messageUEC = StreamController<UserEvent>();
  Function(UserEvent) get messageSendEvent => _messageUEC.sink.add;

  late final Stream<ServerEvent> _messageSES = _apiService.serverEvents.where(
    (e) => MESSAGE_EVENT_TYPES.contains(e.runtimeType)
  );
  Stream<ServerEvent> get messageEvents => _messageSES;

  final StreamGroup<Event> _messageController = StreamGroup<Event>();

  Future<void> _fetch() async {
    RD.Result<String> result = await _storageService.fetchMessages();
    _cachedMessage = result.fold(
      (success) {
        final jsonData = Map<String, String>.from(jsonDecode(success));
        return jsonData.map(
          (convo, messages) => MapEntry<Conversation, List<Message>>(
            Conversation.fromJson(convo),
            jsonDecode(messages)
          )
        ); 
      },
      (failure) => null,
    );
  }

  Future<RD.Result<void>> _store() async {
    if(_cachedMessage == null || _cachedMessage == {}) {
      return RD.Success(());
    }
    // this has to be stored in multiple blocks so that app doesnt slow down
    final Map<String, String> data = _cachedMessage!.map(
      (convo, messages) => MapEntry<String, String>(
        convo.toJson(), 
        jsonEncode(messages)
      )
    );
    return await _storageService.saveMessages(jsonEncode(data));
  }

  Future<RD.Result<void>> _clear() async => await _storageService.saveMessages(null);

  Future<void> _handleMessageEvents(Event event) async {
    
    switch(event) {
      case ServerEventMessageDelivery():
        final convo = Conversation(id1: event.from, id2: event.to);
        ((_cachedMessage ??= {})[convo] ??= []).add(Message(
          from: event.from,
          message: event.message,
          nonce: event.nonce,
          to: event.to,
          timestamp: event.timestamp.round(),
        ));
        await _store();

      case UserEventLogout():
        _cachedMessage = null;
        _clear();

      default:
        print("MessageRepo : no handler for event");
    }
  }

  Future<List<Message>> getAllMessagesOf(Conversation convo) async {
    return (await messages)[convo] ?? [];
  }

  // Message? getLatestMessageOf(Conversation convo) {
  //   final messages = getAllMessagesOf(convo);
  //   return messages.isNotEmpty ? messages.last : null;
  // }

  Future<RD.Result<void>> sendMessage({
    required String from,
    required String to,
    required String message,
  }) async {
    try {
      String nonce = await _randomService.generateNonce();
      final RD.Result<void> result = await _apiService.message(MessageRequest(
        to: to, 
        nonce: nonce, 
        message: message
      )); 
      if(result.isError()) {
        return result;
      }
      //TBD add message to waiting
      return RD.Success(());
    } on Exception catch(e) {
      return RD.Failure(e);
    } 
  }

}