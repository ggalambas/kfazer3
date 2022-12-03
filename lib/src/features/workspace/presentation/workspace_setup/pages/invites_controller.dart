import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/users/data/contacts_repository.dart';

final invitesControllerProvider = StateNotifierProvider.autoDispose<
    InvitesController, AsyncValue<PhoneNumber?>>(
  (ref) {
    final repository = ref.watch(contactsRepositoryProvider);
    return InvitesController(contactsRepository: repository);
  },
);

class InvitesController extends StateNotifier<AsyncValue<PhoneNumber?>> {
  final ContactsRepository contactsRepository;
  InvitesController({required this.contactsRepository})
      : super(const AsyncValue.data(null));

  Future<bool> pickPhoneNumberFromContacts(
      List<Country> countryList, Locale locale) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        final phoneNumber =
            await contactsRepository.fetchPhoneNumberFromContacts(countryList);
        if (phoneNumber.code.isNotEmpty) return phoneNumber;
        final code = countryList
            .firstWhere(
              (country) => country.code == locale.countryCode,
              orElse: () => countryList.first,
            )
            .code;
        return PhoneNumber(code, phoneNumber.number);
      },
    );
    return !state.hasError;
  }
}
