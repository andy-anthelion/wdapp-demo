import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
abstract class Message with _$Message {
  
  const Message._();

  const factory Message({
    required String from,
    required String message,
    required String nonce,
    required String to,
    required int timestamp,
  }) = _Message;

  factory Message.fromJson(Map<String, Object?> json) =>
    _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this as _Message);
}
