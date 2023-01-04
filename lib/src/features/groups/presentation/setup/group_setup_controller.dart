import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/presentation/auth_validators.dart';
import 'package:kfazer3/src/features/groups/application/groups_service.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/domain/group_plan.dart';
import 'package:kfazer3/src/features/groups/presentation/group_validators.dart';
import 'package:kfazer3/src/features/motivation/presentation/quote_validators.dart';
import 'package:kfazer3/src/features/users/data/contacts_repository.dart';
import 'package:share_plus/share_plus.dart';

final groupSetupControllerProvider = StateNotifierProvider.autoDispose<
    GroupSetupController, AsyncValue<String?>>(
  (ref) => GroupSetupController(
    groupsService: ref.watch(groupsServiceProvider),
    contactsRepository: ref.watch(contactsRepositoryProvider),
  ),
);

//TODO save values when going back the pages
//TODO trim input fields
//then trim name on account setup page as well
//TODO setup plan page
class GroupSetupController extends StateNotifier<AsyncValue<String?>>
    with GroupValidators, QuoteValidators, AuthValidators {
  final GroupsService groupsService;
  final ContactsRepository contactsRepository;

  GroupSetupController({
    required this.groupsService,
    required this.contactsRepository,
  }) : super(const AsyncValue.data(null));

  Future<String?> createGroup() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final group = Group(
        id: '',
        name: _name,
        plan: _plan,
        members: {},
        pendingMembersPhoneNumber: _invites,
      );
      return groupsService.createGroup(group, _quotes);
    });
    return state.valueOrNull;
  }

  // Details

  String _name = '';
  void saveName(String name) => _name = name;

  // Motivation

  List<String> _quotes = [];
  void saveQuotes(List<String> quotes) => _quotes = quotes;

  // Invites

  final Set<PhoneNumber> _invites = {};
  Set<PhoneNumber> get invites => _invites;
  void addInvite(PhoneNumber invite) => _invites.add(invite);
  void removeInvite(PhoneNumber invite) => _invites.remove(invite);

  Future<PhoneNumber> pickFromContacts(List<Country> countryList) =>
      contactsRepository.fetchPhoneNumberFromContacts(countryList);

  void shareInviteLink() => Share.share(
        'https://k-fazer.com/invite?code=FGH54V',
        subject: 'Join us at KFazer!',
      );

  // Plan

  GroupPlan _plan = GroupPlan.family;
  void savePlan(GroupPlan plan) => _plan = plan;
}
