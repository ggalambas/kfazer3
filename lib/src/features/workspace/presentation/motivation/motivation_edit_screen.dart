import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/details_bar.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/workspace/data/workspace_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/updatable_workspace.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/features/workspace/presentation/motivation/motivation_edit_controller.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_screen/not_found_workspace.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:smart_space/smart_space.dart';

class MotivationEditScreen extends ConsumerStatefulWidget {
  final String workspaceId;
  const MotivationEditScreen({super.key, required this.workspaceId});

  @override
  ConsumerState<MotivationEditScreen> createState() =>
      _MotivationEditScreenState();
}

class _MotivationEditScreenState extends ConsumerState<MotivationEditScreen> {
  final formKey = GlobalKey<FormState>();
  final firstMessageNode = FocusNode();
  List<TextEditingController>? messageControllers;

  List<String> get messages =>
      messageControllers!.map((controller) => controller.text).toList();

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  var submitted = false;

  void init(Workspace workspace) {
    if (messageControllers != null) return;

    messageControllers = [];
    for (final message in workspace.motivationalMessages) {
      messageControllers!.add(TextEditingController(text: message));
    }
  }

  @override
  void dispose() {
    messageControllers?.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void delete(TextEditingController controller) => setState(() {
        messageControllers!.remove(controller);
      });

  void add() {
    setState(() {
      messageControllers = [TextEditingController(), ...messageControllers!];
    });
    firstMessageNode.requestFocus();
  }

  Future<void> save(Workspace workspace) async {
    setState(() => submitted = true);
    if (!formKey.currentState!.validate()) return;
    final updatedWorkspace = workspace.updateMotivationalMessages(messages);
    await ref
        .read(motivationEditScreenControllerProvider.notifier)
        .save(updatedWorkspace);
    if (mounted) goBack();
  }

  void goBack() => context.goNamed(
        AppRoute.motivation.name,
        params: {'workspaceId': widget.workspaceId},
      );

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      motivationEditScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(motivationEditScreenControllerProvider);
    final workspaceValue =
        ref.watch(workspaceStreamProvider(widget.workspaceId));
    return AsyncValueWidget<Workspace?>(
        value: workspaceValue,
        data: (workspace) {
          if (workspace == null) return const NotFoundWorkspace();
          init(workspace);
          return Scaffold(
            appBar: EditingBar(
              loading: state.isLoading,
              title: context.loc.motivation,
              onCancel: goBack,
              onSave: () => save(workspace),
            ),
            body: ResponsiveCenter(
              maxContentWidth: Breakpoint.tablet,
              padding: EdgeInsets.all(kSpace * 2),
              child: Form(
                key: formKey,
                child: ListView(
                  padding: EdgeInsets.only(bottom: kSpace * 8),
                  children: messageControllers!
                      .mapIndexed(
                        (i, messageController) => TextFormField(
                          focusNode: i == 0 ? firstMessageNode : null,
                          controller: messageController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          maxLength: kMotivationalMessagesLength,
                          maxLines: null,
                          decoration: InputDecoration(
                            counterText: '',
                            filled: false,
                            isDense: true,
                            contentPadding: EdgeInsets.all(kSpace),
                            suffixIcon: IconButton(
                              tooltip: context.loc.delete,
                              onPressed: () => delete(messageController),
                              icon: const Icon(Icons.clear),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (message) {
                            if (!submitted) return null;
                            return ref
                                .read(motivationEditScreenControllerProvider
                                    .notifier)
                                .messageErrorText(context, message ?? '');
                          },
                        ),
                      )
                      .expandIndexed((i, textField) => [
                            textField,
                            if (i < messageControllers!.length - 1)
                              const Divider(),
                          ])
                      .toList(),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: add,
              child: const Icon(Icons.add),
            ),
          );
        });
  }
}
