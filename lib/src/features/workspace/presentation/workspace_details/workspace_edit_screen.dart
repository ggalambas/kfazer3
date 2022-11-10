import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/common_widgets/image_picker_badge.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/common_widgets/tap_to_unfocus.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/auth/presentation/account/image_editing_controller.dart';
import 'package:kfazer3/src/features/workspace/data/workspace_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/updatable_workspace.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_screen/not_found_workspace.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:smart_space/smart_space.dart';

import 'workspace_edit_screen_controller.dart';

class WorkspaceEditScreen extends ConsumerStatefulWidget {
  final String workspaceId;
  const WorkspaceEditScreen({super.key, required this.workspaceId});

  @override
  ConsumerState<WorkspaceEditScreen> createState() =>
      _WorkspaceEditScreenState();
}

class _WorkspaceEditScreenState extends ConsumerState<WorkspaceEditScreen> {
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

  void init(Workspace workspace) {
    titleController ??= TextEditingController(text: workspace.title);
    descriptionController ??=
        TextEditingController(text: workspace.description);
    image ??=
        workspace.photoUrl == null ? null : NetworkImage(workspace.photoUrl!);
  }

  @override
  void dispose() {
    titleController?.dispose();
    descriptionController?.dispose();
    super.dispose();
  }

  Future<void> save(Workspace workspace) async {
    setState(() => submitted = true);
    if (!formKey.currentState!.validate()) return;
    final updatedWorkspace =
        workspace.updateTitle(title).updateDescription(description);
    await ref
        .read(workspaceEditScreenControllerProvider.notifier)
        .save(updatedWorkspace, _imageBytes);
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
        AppRoute.workspaceDetails.name,
        params: {'groupId': widget.workspaceId},
      );

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      workspaceEditScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    ref.listen<AsyncValue>(
      imageEditingControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(workspaceEditScreenControllerProvider);
    final imageState = ref.watch(imageEditingControllerProvider);
    final workspaceValue =
        ref.watch(workspaceStreamProvider(widget.workspaceId));

    return AsyncValueWidget<Workspace?>(
        value: workspaceValue,
        data: (workspace) {
          if (workspace == null) return const NotFoundWorkspace();
          init(workspace);
          return TapToUnfocus(
            child: Scaffold(
              appBar: AppBar(
                leading: CloseButton(
                  onPressed: state.isLoading ? null : goBack,
                ),
                title: Text(context.loc.workspace),
                actions: [
                  LoadingTextButton(
                    loading: state.isLoading,
                    onPressed: () => save(workspace),
                    child: Text(context.loc.save),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: ResponsiveCenter(
                  maxContentWidth: Breakpoint.tablet,
                  padding: EdgeInsets.all(kSpace * 2),
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
                                .read(workspaceEditScreenControllerProvider
                                    .notifier)
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
                                .read(workspaceEditScreenControllerProvider
                                    .notifier)
                                .descriptionErrorText(
                                    context, description ?? '');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
