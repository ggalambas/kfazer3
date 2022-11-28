import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/avatar_picker/image_controller.dart';
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
    state = await AsyncValue.guard(() {
      switch (imageController.state) {
        case ImageControllerState.none:
          return groupsRepository.updateGroup(group);
        case ImageControllerState.updated:
          return groupsService.uploadPictureAndSaveGroup(
              group, imageController.bytes!);
        case ImageControllerState.removed:
          return groupsService.removePictureAndSaveGroup(group);
      }
    });
  }
}
