import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/responsive_setup.dart';
import 'package:kfazer3/src/features/groups/presentation/group_setup/group_setup_controller.dart';
import 'package:kfazer3/src/features/groups/presentation/motivation/motivational_message_field.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';

import 'initial_messages_controller.dart';

class MotivationPage extends ConsumerStatefulWidget {
  final VoidCallback? onSuccess;
  const MotivationPage({super.key, required this.onSuccess});

  @override
  ConsumerState<MotivationPage> createState() => _MotivationPageState();
}

class _MotivationPageState extends ConsumerState<MotivationPage> {
  final formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  final firstNode = FocusNode();
  final lastNode = FocusNode();

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  var submitted = false;

  void submit(List<String> messages) async {
    lastNode
      ..requestFocus()
      ..nextFocus()
      ..unfocus();
    setState(() => submitted = true);
    if (!formKey.currentState!.validate()) return;
    final controller = ref.read(groupSetupControllerProvider.notifier);
    controller.saveMessages(messages);
    widget.onSuccess?.call();
  }

  @override
  void dispose() {
    firstNode.dispose();
    lastNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(initialMessagesControllerProvider.notifier);
    final messageControllers = ref.watch(initialMessagesControllerProvider);
    final showClearAllButton = messageControllers.length <= 1;
    return ResponsiveSetup(
      formKey: formKey,
      onCancel: () => context.goNamed(AppRoute.home.name),
      controller: scrollController,
      title: 'Keep everyone motivated'.hardcoded,
      description: 'Motivational messages are shown when completing a task, '
              'so you can keep the motivation flying high.\n\n'
              'We\'ve added some messages to get you started!'
          .hardcoded,
      content: ListView.separated(
        shrinkWrap: true,
        controller: scrollController,
        itemCount: messageControllers.length,
        separatorBuilder: (context, _) => const Divider(),
        itemBuilder: (context, i) => MotivationalMessageField(
          submitted: submitted,
          controller: messageControllers[i],
          focusNode: i == 0
              ? firstNode
              : i == messageControllers.length - 1
                  ? lastNode
                  : null,
          onDelete: () => controller.removeMessage(i),
        ),
      ),
      actions: [
        OutlinedButton.icon(
          onPressed: () {
            controller.addMessage();
            scrollController.jumpTo(0);
            firstNode.requestFocus();
          },
          icon: const Icon(Icons.add),
          label: Text(context.loc.newMessage),
        ),
        ElevatedButton(
          onPressed: () => submit(controller.messages),
          child: Text(context.loc.next),
        ),
      ],
    );
  }
}
