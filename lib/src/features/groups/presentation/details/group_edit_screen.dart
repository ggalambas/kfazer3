import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/common_widgets/image_picker_badge.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/common_widgets/responsive_scaffold.dart';
import 'package:kfazer3/src/common_widgets/tap_to_unfocus.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/auth/presentation/account/image_editing_controller.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/domain/mutable_group.dart';
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
  TextEditingController? titleController;
  TextEditingController? descriptionController;
  ImageProvider? image;

  Uint8List? _imageBytes;
  set imageBytes(Uint8List? bytes) {
    _imageBytes = bytes;
    image = bytes == null ? null : MemoryImage(bytes);
  }

  String get title => titleController!.text;
  String get description => descriptionController!.text;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  var submitted = false;

  void init(Group group) {
    titleController ??= TextEditingController(text: group.title);
    descriptionController ??= TextEditingController(text: group.description);
    image ??= group.photoUrl == null ? null : NetworkImage(group.photoUrl!);
  }

  @override
  void dispose() {
    titleController?.dispose();
    descriptionController?.dispose();
    super.dispose();
  }

  Future<void> save(Group group) async {
    setState(() => submitted = true);
    if (!formKey.currentState!.validate()) return;
    final updatedGroup =
        group.updateTitle(title).updateDescription(description);
    await ref
        .read(groupEditControllerProvider.notifier)
        .save(updatedGroup, _imageBytes);
    if (mounted) goBack();
  }

  void applyImage(XFile? file) async {
    if (file == null) return setState(() => imageBytes = null);
    final bytes = await ref
        .read(imageEditingControllerProvider.notifier)
        .readAsBytes(file);
    if (bytes != null) setState(() => imageBytes = bytes);
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
          final maybeSave = imageState.isLoading ? null : () => save(group);
          final maybeCancel = state.isLoading ? null : goBack;
          return TapToUnfocus(
            child: ResponsiveScaffold(
              padding: EdgeInsets.all(kSpace * 2),
              appBar: AppBar(
                leading: CloseButton(onPressed: maybeCancel),
                title: Text(context.loc.group),
                actions: [
                  LoadingTextButton(
                    loading: state.isLoading,
                    onPressed: () => save(group),
                    child: Text(context.loc.save),
                  ),
                ],
              ),
              rail: Rail(
                leading: CloseButton(onPressed: maybeCancel),
                title: context.loc.group,
                actions: [
                  TextButton(
                    onPressed: maybeSave,
                    child: Text(context.loc.save),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: titleController!,
                        builder: (context, _, __) {
                          return ImagePickerBadge(
                            loading: imageState.isLoading,
                            disabled: state.isLoading,
                            onImagePicked: applyImage,
                            showDeleteOption: image != null,
                            child: Avatar(
                              icon: Icons.workspaces,
                              radius: kSpace * 10,
                              shape: BoxShape.rectangle,
                              foregroundImage: image,
                              text: title,
                            ),
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
            ),
          );
        });
  }
}
