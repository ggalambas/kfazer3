import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/edit_bar.dart';
import 'package:kfazer3/src/common_widgets/responsive_scaffold.dart';
import 'package:kfazer3/src/common_widgets/single_child_menu_button.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/motivation/presentation/motivation_edit_controller.dart';
import 'package:kfazer3/src/features/motivation/presentation/motivation_form_controller.dart';
import 'package:kfazer3/src/features/motivation/presentation/motivational_message_field.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

class MotivationEditScreen extends ConsumerStatefulWidget {
  final String groupId;
  const MotivationEditScreen({super.key, required this.groupId});

  @override
  ConsumerState<MotivationEditScreen> createState() =>
      _MotivationEditScreenState();
}

class _MotivationEditScreenState extends ConsumerState<MotivationEditScreen> {
  /// motivationalMessagesControllerProvider of [widget.groupId]
  AutoDisposeStateNotifierProvider<MotivationFormController,
          AsyncValue<List<TextEditingController>>>
      get motivationFormProvider =>
          motivationFormControllerProvider(widget.groupId);

  final formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  final firstNode = FocusNode();

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  var submitted = false;

  void save() async {
    setState(() => submitted = true);
    if (!formKey.currentState!.validate()) return;
    final motivation = ref.read(motivationFormProvider.notifier).motivation;
    final success = await ref
        .read(motivationEditControllerProvider.notifier)
        .save(widget.groupId, motivation);
    if (mounted && success) back();
  }

  void back() => context.goNamed(
        AppRoute.motivation.name,
        params: {'groupId': widget.groupId},
      );

  @override
  void dispose() {
    firstNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      motivationEditControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(motivationEditControllerProvider);
    final controller = ref.watch(motivationFormProvider.notifier);
    final motivationFormValue = ref.watch(motivationFormProvider);
    return AsyncValueWidget<MessageControllers>(
      value: motivationFormValue,
      data: (motivationForm) {
        //TODO not found group on motivation edit screen
        // if (messageControllers == null) return const NotFoundGroup();
        final showClearAllButton = motivationForm.length <= 1;
        return ResponsiveScaffold(
          appBar: EditBar(
            loading: state.isLoading,
            title: context.loc.motivation,
            onSave: save,
            onCancel: back,
            menuButton: showClearAllButton
                ? null
                : SingleChildMenuButton(
                    enabled: !state.isLoading,
                    onSelected: controller.clearAllMessages,
                    child: Text(
                      context.loc.clearAll,
                      style: TextStyle(color: context.colorScheme.error),
                    ),
                  ),
          ),
          rail: EditRail(
            loading: state.isLoading,
            title: context.loc.motivation,
            onSave: save,
            onCancel: back,
            actions: [
              if (showClearAllButton)
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: context.colorScheme.error,
                  ),
                  onPressed:
                      state.isLoading ? null : controller.clearAllMessages,
                  child: Text(context.loc.clearAll),
                ),
            ],
          ),
          builder: (topPadding) {
            return ListView.separated(
              padding: EdgeInsets.all(kSpace).add(
                EdgeInsets.only(top: topPadding, bottom: kFabSpace - kSpace),
              ),
              itemCount: motivationForm.length,
              separatorBuilder: (context, _) => const Divider(),
              itemBuilder: (context, i) => MotivationalMessageField(
                enabled: !state.isLoading,
                submitted: submitted,
                controller: motivationForm[i],
                focusNode: i == 0 ? firstNode : null,
                onDelete: () => controller.removeMessage(i),
              ),
            );
          },
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              controller.addMessage();
              scrollController.jumpTo(0);
              firstNode.requestFocus();
            },
            icon: const Icon(Icons.add),
            label: Text(context.loc.newMessage),
          ),
        );
      },
    );
  }
}
