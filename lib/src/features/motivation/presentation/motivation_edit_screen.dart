import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/edit_bar.dart';
import 'package:kfazer3/src/common_widgets/responsive_scaffold.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/domain/mutable_group.dart';
import 'package:kfazer3/src/features/groups/presentation/not_found_group.dart';
import 'package:kfazer3/src/features/motivation/presentation/motivation_edit_controller.dart';
import 'package:kfazer3/src/features/motivation/presentation/motivational_message_field.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

class MotivationEditScreen extends ConsumerStatefulWidget {
  final String groupId;
  const MotivationEditScreen({super.key, required this.groupId});

  @override
  ConsumerState<MotivationEditScreen> createState() =>
      _MotivationEditScreenState();
}

class _MotivationEditScreenState extends ConsumerState<MotivationEditScreen> {
  final formKey = GlobalKey<FormState>();
  final firstNode = FocusNode();
  final List<TextEditingController> controllers = [];

  List<String> get messages =>
      controllers.map((controller) => controller.text).toList();

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  var submitted = false;

  var controllersInitialized = false;
  void initControllers(List<String> messages) {
    if (controllersInitialized) return;
    for (final message in messages) {
      controllers.add(TextEditingController(text: message));
    }
    controllersInitialized = true;
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void save(Group group) async {
    setState(() => submitted = true);
    if (!formKey.currentState!.validate()) return;
    final updatedWorkspace = group.setMotivationalMessages(messages);
    await ref
        .read(motivationEditControllerProvider.notifier)
        .save(updatedWorkspace);
    if (mounted) back();
  }

  void back() => context.goNamed(
        AppRoute.motivation.name,
        params: {'groupId': widget.groupId},
      );

  void clear() => setState(controllers.clear);

  void removeMessage(TextEditingController controller) =>
      setState(() => controllers.remove(controller));

  void addMessage() {
    setState(() => controllers.insert(0, TextEditingController()));
    firstNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      motivationEditControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(motivationEditControllerProvider);
    final groupValue = ref.watch(groupStreamProvider(widget.groupId));
    return AsyncValueWidget<Group?>(
      value: groupValue,
      data: (group) {
        if (group == null) return const NotFoundGroup();
        initControllers(group.motivationalMessages);
        return ResponsiveScaffold(
          appBar: EditBar(
            loading: state.isLoading,
            title: context.loc.motivation,
            onSave: () => save(group),
            onCancel: back,
          ),
          rail: EditRail(
            loading: state.isLoading,
            title: context.loc.motivation,
            onSave: () => save(group),
            onCancel: back,
          ),
          builder: (railPadding) => CustomScrollView(
            slivers: [
              if (messages.length > 1)
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
              SliverFillRemaining(
                child: ListView.separated(
                  padding: railPadding,
                  itemCount: group.motivationalMessages.length,
                  separatorBuilder: (context, _) => const Divider(),
                  itemBuilder: (context, i) => MotivationalMessageField(
                    submitted: submitted,
                    controller: controllers[i],
                    focusNode: i == 0 ? firstNode : null,
                    onDelete: () => removeMessage(controllers[i]),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: kFabSpace),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: addMessage,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
