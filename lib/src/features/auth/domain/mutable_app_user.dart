import 'package:kfazer3/src/features/auth/domain/phone_number.dart';

import 'app_user.dart';

extension MutableAppUser on AppUser {
  AppUser updateName(String name) => copyWith(name: name);

  AppUser updatePhoneNumber(PhoneNumber phoneNumber) =>
      copyWith(phoneNumber: phoneNumber);

  AppUser updatePhotoUrl(String? photoUrl) =>
      copyWith(photoUrl: photoUrl, nullablePhotoUrl: true);

  AppUser copyWith({
    String? name,
    PhoneNumber? phoneNumber,
    String? photoUrl,
    bool nullablePhotoUrl = false,
  }) =>
      AppUser(
        id: id,
        name: name ?? this.name,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        photoUrl: nullablePhotoUrl ? photoUrl : (photoUrl ?? this.photoUrl),
      );
}
