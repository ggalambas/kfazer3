import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  // Future<bool> pickPhoneNumberFromContacts(List<Country> countryList) async {
  //   state = const AsyncValue.loading();
  //   state = await AsyncValue.guard(
  //     () => contactsRepository.fetchPhoneNumberFromContacts(countryList),
  //   );
  //   return !state.hasError;
  // }
}
