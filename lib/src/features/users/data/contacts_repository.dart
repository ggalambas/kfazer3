import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';

import 'fake_contacts_repository.dart';

final contactsRepositoryProvider = Provider.autoDispose<ContactsRepository>(
  (ref) => FakeContactsRepository(),
);

abstract class ContactsRepository {
  Future<PhoneNumber> fetchPhoneNumberFromContacts(List<Country> countryList);
  Future<PhoneNumber> fetchPhoneNumbersFromCSV();
  Future<PhoneNumber> fetchPhoneNumbersFromVCard();
}
