import 'package:equatable/equatable.dart';

import 'phone_number.dart';

/// The user identifier is an important concept and can have its own type
typedef UserId = String;

/// Simple class representing the user id, name, and phone number.
class AppUser with EquatableMixin {
  final UserId id;
  final String name;
  final PhoneNumber phoneNumber;
  final String? photoUrl;

  const AppUser({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [id];
}



//TODO
// class AuthUser extends AppUser {}
