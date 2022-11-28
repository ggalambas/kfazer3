import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/common_widgets/edit_bar.dart';
import 'package:kfazer3/src/common_widgets/image_picker_badge.dart';
import 'package:kfazer3/src/common_widgets/responsive_scaffold.dart';
import 'package:kfazer3/src/common_widgets/tap_to_unfocus.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/auth/presentation/account/account_edit_controller.dart';
import 'package:kfazer3/src/features/auth/presentation/account/image_editing_controller.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/domain/mutable_group.dart';
import 'package:kfazer3/src/features/groups/presentation/group_validators.dart';
import 'package:kfazer3/src/features/groups/presentation/not_found_group.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:smart_space/smart_space.dart';

import 'group_edit_controller.dart';

class GroupEditScreen extends ConsumerStatefulWidget {
  final String groupId;
  const GroupEditScreen({super.key, required this.groupId});

  @override
  ConsumerState<GroupEditScreen> createState() => GroupEditScreenState();
}

class GroupEditScreenState extends ConsumerState<GroupEditScreen> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final ImageController imageController;

  String get title => titleController.text;
  String get description => descriptionController.text;
  ImageProvider? get image => imageController.image;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  var submitted = false;

  bool initCalled = false;
  void init(Group group) {
    if (initCalled) return;
    initCalled = true;
    titleController = TextEditingController(text: group.title);
    descriptionController = TextEditingController(text: group.description);
    imageController = ImageController(url: group.photoUrl);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> save(Group group) async {
    setState(() => submitted = true);
    if (!formKey.currentState!.validate()) return;

    final updatedGroup = group.setTitle(title).setDescription(description);

    await ref
        .read(groupEditControllerProvider.notifier)
        .save(updatedGroup, imageController);

    if (mounted) goBack();
  }

  void updateImage(XFile? file) async {
    // photo removed
    if (file == null) return imageController.clear();
    // new photo uploaded
    final bytes = await ref
        .read(imageEditingControllerProvider.notifier)
        .readAsBytes(file);
    if (bytes != null) imageController.bytes = bytes;
  }

  void goBack() => context.goNamed(
        AppRoute.groupDetails.name,
        params: {'groupId': widget.groupId},
      );

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      groupEditControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    ref.listen<AsyncValue>(
      imageEditingControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(groupEditControllerProvider);
    final imageState = ref.watch(imageEditingControllerProvider);
    final groupValue = ref.watch(groupStreamProvider(widget.groupId));

    return AsyncValueWidget<Group?>(
        value: groupValue,
        data: (group) {
          if (group == null) return const NotFoundGroup();

          init(group);
          return TapToUnfocus(
            child: ResponsiveScaffold(
              padding: EdgeInsets.all(kSpace * 2),
              appBar: EditBar(
                loading: state.isLoading,
                title: context.loc.group,
                onSave: () => save(group),
                onCancel: goBack,
              ),
              rail: EditRail(
                loading: state.isLoading,
                title: context.loc.group,
                onSave: () => save(group),
                onCancel: goBack,
              ),
              builder: (railPadding) => Form(
                key: formKey,
                child: ListView(
                  padding: railPadding,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: imageController,
                      builder: (context, _, __) {
                        return ImagePickerBadge(
                          loading: imageState.isLoading,
                          disabled: state.isLoading,
                          onImagePicked: updateImage,
                          showDeleteOption: image != null,
                          child: ValueListenableBuilder(
                              valueListenable: titleController,
                              builder: (context, _, __) {
                                return Avatar(
                                  icon: Icons.workspaces,
                                  radius: kSpace * 10,
                                  shape: BoxShape.rectangle,
                                  foregroundImage: image,
                                  text: title,
                                );
                              }),
                        );
                      },
                    ),
                    Space(4),
                    TextFormField(
                      controller: titleController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      maxLength: kTitleLength,
                      decoration: InputDecoration(
                        counterText: '',
                        labelText: context.loc.title,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (title) {
                        if (!submitted) return null;
                        return ref
                            .read(groupEditControllerProvider.notifier)
                            .titleErrorText(context, title ?? '');
                      },
                    ),
                    Space(),
                    TextFormField(
                      maxLines: null,
                      controller: descriptionController,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      maxLength: kDescriptionLength,
                      decoration: InputDecoration(
                        labelText: context.loc.description,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (description) {
                        if (!submitted) return null;
                        return ref
                            .read(groupEditControllerProvider.notifier)
                            .descriptionErrorText(context, description ?? '');
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
