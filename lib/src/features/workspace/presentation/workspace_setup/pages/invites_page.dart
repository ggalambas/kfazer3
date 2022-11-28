import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/common_widgets/setup_layout.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/auth/data/country_repository.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/presentation/auth_validators.dart';
import 'package:kfazer3/src/features/auth/presentation/country_picker/phone_code_dropdown_button.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_setup/workspace_setup_controller.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart_space/smart_space.dart';

class InvitesPage extends ConsumerStatefulWidget {
  const InvitesPage({super.key});

  @override
  ConsumerState<InvitesPage> createState() => _InvitesPageState();
}

class _InvitesPageState extends ConsumerState<InvitesPage> {
  final formKey = GlobalKey<FormState>();
  late final phoneNumberNode = FocusNode()..addListener(() => setState(() {}));
  final phoneNumberController = TextEditingController();
  PhoneCodeController? phoneCodeController;

  final members = <PhoneNumber>[];

  String get phoneNumber => phoneNumberController.text;
  String get phoneCode => phoneCodeController!.code;

  @override
  void dispose() {
    phoneCodeController?.dispose();
    phoneNumberController.dispose();
    phoneNumberNode.dispose();
    super.dispose();
  }

  //TODO import contacts
  void importContacts() {}

  void shareInviteLink() => Share.share(
        'https://k-fazer.com/invite?code=FGH54V',
        subject: 'Join us at KFazer!',
      );

  void remove(PhoneNumber member) => setState(() => members.remove(member));

  void add() {
    if (!formKey.currentState!.validate()) return;

    final phoneNumber = PhoneNumber(phoneCode, this.phoneNumber);
    setState(() => members.add(phoneNumber));
    phoneNumberController.clear();
  }

  void submit() async {
    phoneNumberNode
      ..nextFocus()
      ..unfocus();

    final controller = ref.read(workspaceSetupControllerProvider.notifier);
    controller.saveMembers(members);
    final success = await controller.createWorkspace();
    if (success && mounted) {
      // final workspaceId = ref.read(workspaceSetupControllerProvider).value!;
      //!
      // context.goNamed(
      //   AppRoute.group.name,
      //   params: {'groupId': workspaceId},
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(workspaceSetupControllerProvider);
    final countryListValue = ref.watch(countryListFutureProvider);
    return SetupLayout(
      formKey: formKey,
      title: 'Add members'.hardcoded,
      description: TextSpan(
        text:
            'You can invite your workspace members through their phone number or by sending them an invite link. You can also do this later.\n\n'
                    'Have a CSV or vCard file? Import contacts instead.'
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
                suffixIcon: phoneNumberNode.hasFocus
                    ? TextButton(
                        onPressed: add,
                        child: Text('Add'.hardcoded),
                      )
                    //TODO contact picker
                    : IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.perm_contact_calendar),
                      ),
              ),
              onEditingComplete: add,
              validator: (phoneNumber) => ref
                  .read(workspaceSetupControllerProvider.notifier)
                  .phoneNumberErrorText(context, phoneNumber ?? ''),
            );
          },
        ),
        if (members.isNotEmpty) Space(),
        //TODO give size just like to the messages
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
      cta: countryListValue.hasValue
          ? [
              OutlinedButton.icon(
                onPressed: state.isLoading ? null : importContacts,
                icon: const Icon(Icons.upload),
                label: Text('Import file'.hardcoded),
              ),
              OutlinedButton.icon(
                onPressed: state.isLoading ? null : shareInviteLink,
                icon: const Icon(Icons.link),
                label: Text('Share invite link'.hardcoded),
              ),
              LoadingElevatedButton(
                loading: state.isLoading,
                onPressed: submit,
                child: Text('Create workspace'.hardcoded),
              ),
            ]
          : [],
    );
  }
}
