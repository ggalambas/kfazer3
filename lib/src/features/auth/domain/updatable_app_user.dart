import 'package:kfazer3/src/features/auth/domain/phone_number.dart';

import 'app_user.dart';

extension UpdatableAppUser on AppUser {
  AppUser updateName(String name) => AppUser(
        id: id,
        name: name,
        phoneNumber: phoneNumber,
      );

  AppUser updatePhoneNumber(PhoneNumber phoneNumber) => AppUser(
        id: id,
        name: name,
        phoneNumber: phoneNumber,
      );
}
