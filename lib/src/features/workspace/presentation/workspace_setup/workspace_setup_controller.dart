import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/presentation/auth_validators.dart';
import 'package:kfazer3/src/features/groups/presentation/group_validators.dart';
import 'package:kfazer3/src/features/workspace/data/workspace_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/preferences.dart';
import 'package:kfazer3/src/features/workspace/presentation/motivation/motivation_edit_screen_controller.dart';

final workspaceSetupControllerProvider = StateNotifierProvider.autoDispose<
    WorkspaceSetupController, AsyncValue<String?>>(
  (ref) {
    final repository = ref.watch(workspaceRepositoryProvider);
    return WorkspaceSetupController(workspaceRepository: repository);
  },
);

class WorkspaceSetupController extends StateNotifier<AsyncValue<String?>>
    with GroupValidators, MotivationValidators, AuthValidators {
  final WorkspaceRepository workspaceRepository;

  WorkspaceSetupController({required this.workspaceRepository})
      : super(const AsyncValue.data(null));

  //TODO save values when going back the pages
  //TODO test

  String? _title;
  List<String>? _messages;
  WorkspacePlan? _plan = WorkspacePlan.family; //TODO setup plan page
  List<PhoneNumber>? _phoneNumbers;

  WorkspacePlan? get plan => _plan;

  //TODO trim input fields
  void saveTitle(String title) => _title = title;
  void saveMessages(List<String> messages) => _messages = messages;
  void savePlan(WorkspacePlan plan) => _plan = plan;
  void saveMembers(List<PhoneNumber> phoneNumbers) =>
      _phoneNumbers = phoneNumbers;

  Future<bool> createWorkspace() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => workspaceRepository.createWorkspace(
          _title!, _messages!, _plan!, _phoneNumbers!),
    );
    return !state.hasError;
  }
}
