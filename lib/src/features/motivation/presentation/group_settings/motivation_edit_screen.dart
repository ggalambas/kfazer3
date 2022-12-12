import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/edit_bar.dart';
import 'package:kfazer3/src/common_widgets/responsive_scaffold.dart';
import 'package:kfazer3/src/common_widgets/single_child_menu_button.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/groups/presentation/not_found_group.dart';
import 'package:kfazer3/src/features/motivation/data/quotes_repository.dart';
import 'package:kfazer3/src/features/motivation/presentation/group_settings/motivation_edit_controller.dart';
import 'package:kfazer3/src/features/motivation/presentation/quote_validators.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

import '../quote_field.dart';
import '../quotes_form.dart';

class MotivationEditScreen extends ConsumerStatefulWidget {
  final String groupId;
  const MotivationEditScreen({super.key, required this.groupId});

  @override
  ConsumerState<MotivationEditScreen> createState() =>
      _MotivationEditScreenState();
}

class _MotivationEditScreenState extends ConsumerState<MotivationEditScreen>
    with QuoteForm {
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
    final success = await ref
        .read(motivationEditControllerProvider.notifier)
        .save(widget.groupId, quotes);
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
    final quotesValue = ref.watch(quotesStreamProvider(widget.groupId));
    return AsyncValueWidget<List<String>?>(
      value: quotesValue,
      data: (quotes) {
        if (quotes == null) return const NotFoundGroup();
        initQuoteController(quotes);
        final showClearAllButton = quoteControllers.length > 1;
        return ResponsiveScaffold(
          appBar: EditBar(
            loading: state.isLoading,
            title: context.loc.motivation,
            onSave: save,
            onCancel: back,
            menuButton: showClearAllButton
                ? SingleChildMenuButton(
                    enabled: !state.isLoading,
                    onSelected: clearAllQuotes,
                    child: Text(
                      context.loc.clearAll,
                      style: TextStyle(color: context.colorScheme.error),
                    ),
                  )
                : null,
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
                  onPressed: state.isLoading ? null : clearAllQuotes,
                  child: Text(context.loc.clearAll),
                ),
            ],
          ),
          builder: (topPadding) {
            return Form(
              key: formKey,
              child: ListView.separated(
                controller: scrollController,
                padding: EdgeInsets.all(kSpace).add(
                  EdgeInsets.only(top: topPadding, bottom: kFabSpace - kSpace),
                ),
                itemCount: quoteControllers.length,
                separatorBuilder: (context, _) => const Divider(),
                itemBuilder: (context, i) => QuoteField(
                  enabled: !state.isLoading,
                  controller: quoteControllers[i],
                  focusNode: i == 0 ? firstNode : null,
                  onDelete: () => removeQuote(i),
                  validator: (message) {
                    if (!submitted) return null;
                    return ref
                        .read(motivationEditControllerProvider.notifier)
                        .quoteErrorText(context, message ?? '');
                  },
                ),
              ),
            );
          },
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              addQuote();
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
