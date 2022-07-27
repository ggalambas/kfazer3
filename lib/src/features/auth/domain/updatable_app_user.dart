import 'app_user.dart';

extension UpdatableAppUser on AppUser {
  AppUser updateName(String name) => AppUser(
        id: id,
        name: name,
        phoneNumber: phoneNumber,
      );

  AppUser updatePhoneNumber(String phoneNumber) => AppUser(
        id: id,
        name: name,
        phoneNumber: phoneNumber,
      );
}
