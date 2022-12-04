import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/groups/presentation/not_found_group.dart';
import 'package:kfazer3/src/features/workspace/data/workspace_repository.dart';
import 'package:kfazer3/src/features/workspace/domain/updatable_workspace.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/features/workspace/presentation/motivation/motivation_edit_screen_controller.dart';
import 'package:kfazer3/src/features/workspace/presentation/motivation/motivation_validators.dart';
import 'package:kfazer3/src/localization/localization_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

class MotivationEditScreen extends ConsumerStatefulWidget {
  final String workspaceId;
  const MotivationEditScreen({super.key, required this.workspaceId});

  @override
  ConsumerState<MotivationEditScreen> createState() =>
      _MotivationEditScreenState();
}

//TODO rethink messageControllers logic

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

  void clear() => setState(() => messageControllers!.clear());

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
        params: {'groupId': widget.workspaceId},
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
        //TODO loading widget
        data: (workspace) {
          if (workspace == null) return const NotFoundGroup();
          init(workspace);
          return Scaffold(
            appBar: AppBar(
              leading: CloseButton(onPressed: state.isLoading ? null : goBack),
              title: Text(context.loc.motivation),
              actions: [
                LoadingTextButton(
                  loading: state.isLoading,
                  onPressed: () => save(workspace),
                  child: Text(context.loc.save),
                ),
              ],
            ),
            body: ResponsiveCenter(
              maxContentWidth: Breakpoint.tablet,
              padding: EdgeInsets.all(kSpace * 2),
              child: Form(
                key: formKey,
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      child: ListView.separated(
                        itemCount: messageControllers!.length,
                        separatorBuilder: (context, _) => const Divider(),
                        //TODO move to another file?
                        itemBuilder: (context, i) => TextFormField(
                          focusNode: i == 0 ? firstMessageNode : null,
                          controller: messageControllers![i],
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
                              onPressed: () => delete(messageControllers![i]),
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
                      ),
                    ),
                    if (messageControllers!.length > 1)
                      SliverToBoxAdapter(
                        child: Center(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: context.colorScheme.error,
                            ),
                            onPressed: clear,
                            child: const Text('Clear all'),
                          ),
                        ),
                      ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: kFabSpace),
                    ),
                  ],
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
