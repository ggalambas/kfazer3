import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/presentation/auth_validators.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/domain/group_plan.dart';
import 'package:kfazer3/src/features/groups/presentation/group_validators.dart';
import 'package:kfazer3/src/features/workspace/presentation/motivation/motivation_validators.dart';

final groupSetupControllerProvider = StateNotifierProvider.autoDispose<
    GroupSetupController, AsyncValue<String?>>(
  (ref) {
    final repository = ref.watch(groupsRepositoryProvider);
    return GroupSetupController(groupsRepository: repository);
  },
);

class GroupSetupController extends StateNotifier<AsyncValue<String?>>
    with GroupValidators, MotivationValidators, AuthValidators {
  final GroupsRepository groupsRepository;

  GroupSetupController({required this.groupsRepository})
      : super(const AsyncValue.data(null));

  //TODO save values when going back the pages

  String _title = '';
  List<String> _messages = [];
  final Set<PhoneNumber> _invites = {};
  //TODO setup plan page
  GroupPlan _plan = GroupPlan.family;

  Set<PhoneNumber> get invites => _invites;

  //TODO trim input fields
  //then trim name on account setup page as well
  void saveTitle(String title) => _title = title;
  void saveMessages(List<String> messages) => _messages = messages;
  void addInvite(PhoneNumber invite) => _invites.add(invite);
  void removeInvite(PhoneNumber invite) => _invites.remove(invite);
  void savePlan(GroupPlan plan) => _plan = plan;

  Future<String?> createGroup() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final group = Group(
        id: '',
        title: _title,
        plan: _plan,
        motivationalMessages: _messages,
        members: {},
        pendingMembersPhoneNumber: _invites,
      );
      return groupsRepository.createGroup(group);
    });
    return state.valueOrNull;
  }
}
