import 'package:kfazer3/src/features/auth/domain/app_user.dart';

/// Test users to be used until a data source is implemented
final kTestUsers = List.generate(
  20,
  (i) => AppUser(
    id: '$i',
    name: 'User $i',
    phoneNumber: (911111111 + i).toString(),
  ),
);
