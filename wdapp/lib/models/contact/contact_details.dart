import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_details.freezed.dart';

@freezed
abstract class ContactDetails with _$ContactDetails {
  
  const ContactDetails._();

  const factory ContactDetails({
    required int age,
    required String gender,
    required String message,
    required String loc,
    required String location,
    required String name,
    required int timestamp,
    required int unread,
  }) = _ContactDetails;

  String get id {
    return "${gender == 'F'?'+':'-'}"
      "${age.toString().padLeft(2, '0')}"
      "$loc"
      "${name.padRight(12, '.')}";
  }
}
