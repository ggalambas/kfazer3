import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/responsive_setup.dart';
import 'package:kfazer3/src/features/groups/presentation/setup/group_setup_controller.dart';
import 'package:kfazer3/src/features/motivation/presentation/quote_field.dart';
import 'package:kfazer3/src/features/motivation/presentation/quote_validators.dart';
import 'package:kfazer3/src/features/motivation/presentation/quotes_form.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

class MotivationPage extends ConsumerStatefulWidget {
  final VoidCallback? onSuccess;
  const MotivationPage({super.key, required this.onSuccess});

  @override
  ConsumerState<MotivationPage> createState() => _MotivationPageState();
}

/// Use the [AutomaticKeepAliveClientMixin] to keep the state.
class _MotivationPageState extends ConsumerState<MotivationPage>
    with QuoteForm, AutomaticKeepAliveClientMixin {
  final formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  final firstNode = FocusNode();

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  var submitted = false;

  // override `wantKeepAlive` when using `AutomaticKeepAliveClientMixin`
  @override
  bool get wantKeepAlive => true;

  void submit() async {
    if (quotes.isNotEmpty) {
      firstNode
        ..requestFocus()
        ..nextFocus()
        ..unfocus();
    }
    setState(() => submitted = true);
    if (!formKey.currentState!.validate()) return;
    final controller = ref.read(groupSetupControllerProvider.notifier);
    controller.saveQuotes(quotes);
    widget.onSuccess?.call();
  }

  bool get showClearAllButton => quoteControllers.length > 1;

  @override
  void dispose() {
    firstNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // call `super.build` when using `AutomaticKeepAliveClientMixin`
    super.build(context);

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
        itemCount: quoteControllers.length,
        separatorBuilder: (context, _) => const Divider(),
        itemBuilder: (context, i) => QuoteField(
          controller: quoteControllers[i],
          focusNode: i == 0 ? firstNode : null,
          onDelete: () => removeQuote(i),
          validator: (message) {
            if (!submitted) return null;
            return ref
                .read(groupSetupControllerProvider.notifier)
                .quoteErrorText(context, message ?? '');
          },
        ),
      ),
      actions: [
        if (showClearAllButton)
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colorScheme.error,
            ),
            onPressed: clearAllQuotes,
            child: Text(context.loc.clearAll),
          ),
        OutlinedButton(
          onPressed: () {
            addQuote();
            scrollController.jumpTo(0);
            firstNode.requestFocus();
          },
          child: Text(context.loc.newMessage),
        ),
        ElevatedButton(
          onPressed: submit,
          child: Text(context.loc.next),
        ),
      ],
    );
  }
}
