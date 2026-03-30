abstract class Event {}
abstract class UserEvent extends Event {}
abstract class ServerEvent extends Event {}

class ServerEventContactOnline extends ServerEvent {
  final String id;

  ServerEventContactOnline({
    required this.id
  }): super();
}

class ServerEventContactOffline extends ServerEvent {
  final String id;

  ServerEventContactOffline({
    required this.id
  }): super();
}

class ServerEventMessageDelivery extends ServerEvent {
  final double timestamp;
  final String from;
  final String message;
  final String nonce;
  final String to;
  final bool toInbox;

  ServerEventMessageDelivery({
    required this.timestamp,
    required this.from,
    required this.message,
    required this.nonce,
    required this.to,
    required this.toInbox,
  }): super();
}

class UserEventSync extends UserEvent {}

class UserEventSelectContact extends UserEvent {
  final int age;
  final String gender;
  final String loc;
  final String location;
  final String name;

  UserEventSelectContact({
    required this.age,
    required this.gender,
    required this.loc,
    required this.location,
    required this.name,
  }): super();
}

class UserEventReadMessage extends UserEvent {
  final String id1;
  final String id2;

  UserEventReadMessage({
    required this.id1,
    required this.id2,
  }): super();
}

class UserEventSendMessage extends UserEvent {
  final String from;
  final String message;
  final String to;

  UserEventSendMessage({
    required this.from,
    required this.message,
    required this.to,
  }): super();
}