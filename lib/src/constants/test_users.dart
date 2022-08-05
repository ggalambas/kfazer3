import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';

/// Test users to be used until a data source is implemented
final kTestUsers = List.generate(
  20,
  (i) {
    final phoneNumber = PhoneNumber('+351', (900000000 + i).toString());
    return AppUser(
      id: phoneNumber.entire(),
      name: 'User $i',
      phoneNumber: phoneNumber,
    );
  },
);
