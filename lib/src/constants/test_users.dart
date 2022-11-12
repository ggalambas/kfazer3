import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';

/// Test users to be used until a data source is implemented
List<AppUser> get kTestUsers => [..._kTestUsers];
final _kTestUsers = List.generate(
  20,
  (i) => AppUser(
    id: i.toString(),
    name: 'User $i',
    phoneNumber: PhoneNumber('+351', (900000000 + i).toString()),
  ),
);
