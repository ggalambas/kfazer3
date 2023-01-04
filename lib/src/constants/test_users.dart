import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';

const kTestUsersLength = 20;

/// Test users to be used until a data source is implemented
final kTestUsers = List.generate(
  kTestUsersLength,
  (i) => AppUser(
    id: i.toString(),
    name: 'User $i',
    phoneNumber: PhoneNumber('+351', '${900000000 + i}'),
  ),
);
