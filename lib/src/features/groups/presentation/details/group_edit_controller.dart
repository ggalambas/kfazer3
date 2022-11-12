import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/presentation/account/account_edit_controller.dart';
import 'package:kfazer3/src/features/groups/application/groups_service.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/presentation/group_validators.dart';

final groupEditControllerProvider =
    StateNotifierProvider.autoDispose<GroupEditController, AsyncValue>(
  (ref) {
    return GroupEditController(
      groupsService: ref.read(groupsServiceProvider),
      groupsRepository: ref.read(groupsRepositoryProvider),
    );
  },
);

class GroupEditController extends StateNotifier<AsyncValue>
    with GroupValidators {
  final GroupsService groupsService;
  final GroupsRepository groupsRepository;

  GroupEditController({
    required this.groupsService,
    required this.groupsRepository,
  }) : super(const AsyncValue.data(null));

  Future<void> save(Group group, ImageController imageController) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () {
        if (imageController.imageUpdated) {
          return groupsService.uploadPictureAndSaveGroup(
              group, imageController.bytes!);
        } else if (imageController.imageRemoved) {
          return groupsService.removePictureAndSaveGroup(group);
        } else {
          return groupsRepository.updateGroup(group);
        }
      },
    );
  }
}
