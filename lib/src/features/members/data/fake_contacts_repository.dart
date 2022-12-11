import 'package:collection/collection.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart'
    hide PhoneNumber;
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/members/data/contacts_repository.dart';

class FakeContactsRepository implements ContactsRepository {
  @override
  Future<PhoneNumber> fetchPhoneNumberFromContacts(
    List<Country> countryList,
  ) async {
    final phoneContact = await FlutterContactPicker.pickPhoneContact();
    final phoneNumber = phoneContact.phoneNumber?.number?.replaceAll(' ', '');
    if (phoneNumber == null) {
      throw Exception('Failed to import contact');
    }
    String? code;
    if (phoneNumber.startsWith('00')) phoneNumber.replaceFirst('00', '+');
    if (phoneNumber.startsWith('+')) {
      code = countryList
          .firstWhereOrNull((c) => phoneNumber.startsWith(c.code))
          ?.code;
    }
    if (code == null) return PhoneNumber('', phoneNumber);
    return PhoneNumber(code, phoneNumber.replaceFirst(code, ''));
  }

  @override
  Future<List<PhoneNumber>> fetchPhoneNumbersFromCSV() {
    // https://pub.dev/packages/csv
    throw UnimplementedError();
  }

  @override
  Future<List<PhoneNumber>> fetchPhoneNumbersFromVCard() {
    // https://pub.dev/packages/simple_vcard_parser
    throw UnimplementedError();
  }
}
