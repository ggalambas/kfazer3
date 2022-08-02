import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/common_widgets/setup_layout.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/auth/data/country_repository.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/presentation/country_picker/phone_code_dropdown_button.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:smart_space/smart_space.dart';

class InvitesPage extends ConsumerStatefulWidget {
  const InvitesPage({super.key});

  @override
  ConsumerState<InvitesPage> createState() => _InvitesPageState();
}

class _InvitesPageState extends ConsumerState<InvitesPage> {
  final formKey = GlobalKey<FormState>();
  final phoneNumberNode = FocusNode();
  final phoneNumberController = TextEditingController();
  PhoneCodeController? phoneCodeController;

  final members = <PhoneNumber>[];

  String get phoneNumber => phoneNumberController.text;
  String get phoneCode => phoneCodeController!.code;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  var submitted = false;

  @override
  void dispose() {
    phoneCodeController?.dispose();
    phoneNumberController.dispose();
    phoneNumberNode.dispose();
    super.dispose();
  }

  void shareInviteLink() {}

  void remove(PhoneNumber member) => setState(() => members.remove(member));

  void add() {
    setState(() => members.add(PhoneNumber(phoneCode, phoneNumber)));
    phoneNumberController.clear();
  }

  void submit() async {
    phoneNumberNode
      ..nextFocus()
      ..unfocus();

    setState(() => submitted = true);
    if (!formKey.currentState!.validate()) return;

    // final controller = ref.read(signInControllerProvider.notifier);
    // final success = await controller.submit();
    // if (success)
    context.goNamed(
      AppRoute.workspace.name,
      params: {'workspaceId': '0'},
    );
  }

  @override
  Widget build(BuildContext context) {
    // final state = ref.watch(signInControllerProvider);
    final countryListValue = ref.watch(countryListFutureProvider);
    return SetupLayout(
      formKey: formKey,
      title: 'Add members'.hardcoded,
      description: TextSpan(
        text:
            'You can invite your workspace members through their phone number or by sending them an invite link. You can also do this later.'
                .hardcoded,
      ),
      content: [
        AsyncValueWidget<List<Country>>(
          value: countryListValue,
          data: (countryList) {
            phoneCodeController ??= PhoneCodeController.fromLocale(
              Localizations.localeOf(context),
              countryList,
            );
            return TextFormField(
              focusNode: phoneNumberNode,
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: context.loc.phoneNumber,
                prefix:
                    PhoneCodeDropdownPrefix(controller: phoneCodeController!),
                suffixIcon: TextButton(
                  onPressed: add,
                  child: Text('Add'.hardcoded),
                ),
              ),
              onEditingComplete: submit,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (phoneNumber) {
                return null;
                // if (!submitted) return null;
                // return ref
                //     .read(signInControllerProvider.notifier)
                //     .phoneNumberErrorText(context, phoneNumber ?? '');
              },
            );
          },
        ),
        for (final member in members)
          ListTile(
            visualDensity: VisualDensity.compact,
            contentPadding: EdgeInsets.only(left: kSpace * 2),
            title: Text(member.toString()),
            trailing: IconButton(
              tooltip: context.loc.delete, //!
              iconSize: kSmallIconSize,
              onPressed: () => remove(member),
              icon: const Icon(Icons.clear),
            ),
          ),
      ],
      cta: [
        OutlinedButton.icon(
          onPressed: shareInviteLink,
          icon: const Icon(Icons.link),
          label: Text('Share invite link'.hardcoded),
        ),
        LoadingElevatedButton(
          // loading: state.isLoading,
          onPressed: submit,
          child: Text('Create workspace'.hardcoded),
        ),
      ],
    );
  }
}
