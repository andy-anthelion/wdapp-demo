// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  from: json['from'] as String,
  message: json['message'] as String,
  nonce: json['nonce'] as String,
  to: json['to'] as String,
  timestamp: (json['timestamp'] as num).toInt(),
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'from': instance.from,
  'message': instance.message,
  'nonce': instance.nonce,
  'to': instance.to,
  'timestamp': instance.timestamp,
};
