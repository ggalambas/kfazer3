import 'package:flutter_test/flutter_test.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/auth/domain/mutable_app_user.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';

void main() {
  final testPhoneNumber = PhoneNumber('+351', '912345678');
  final testUser =
      AppUser(id: 'id', name: 'name', phoneNumber: testPhoneNumber);
  test('update name', () async {
    const name = 'newName';
    final user = testUser.updateName(name);
    expect(user.id, testUser.id);
    expect(user.name, name);
    expect(user.phoneNumber, testUser.phoneNumber);
  });
  test('update phoneNumber', () async {
    final phoneNumber = PhoneNumber('+351', '987654321');
    final user = testUser.updatePhoneNumber(phoneNumber);
    expect(user.id, testUser.id);
    expect(user.name, testUser.name);
    expect(user.phoneNumber, phoneNumber);
  });
}
