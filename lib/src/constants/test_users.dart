import 'package:kfazer3/src/constants/test_members.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/members/domain/user.dart';

/// Test users to be used until a data source is implemented
final kTestUsers = List.generate(
  kTestUsersLength,
  (i) => User(
    id: i.toString(),
    name: 'User $i',
    phoneNumber: PhoneNumber('+351', '${900000000 + i}'),
    roles: roles(i),
  ),
);
