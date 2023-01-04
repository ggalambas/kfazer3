import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/common_widgets/responsive_setup.dart';
import 'package:kfazer3/src/features/auth/data/country_repository.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/presentation/country_picker/phone_code_controller.dart';
import 'package:kfazer3/src/features/groups/presentation/setup/group_setup_controller.dart';
import 'package:kfazer3/src/features/users/data/contacts_repository.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:smart_space/smart_space.dart';

import 'invite_field.dart';
import 'invite_tile.dart';

class InvitesPage extends ConsumerStatefulWidget {
  final VoidCallback? onSuccess;
  const InvitesPage({super.key, this.onSuccess});

  @override
  ConsumerState<InvitesPage> createState() => _InvitesPageState();
}

class _InvitesPageState extends ConsumerState<InvitesPage> {
  final formKey = GlobalKey<FormState>();
  late final phoneNumberNode = FocusNode();
  final phoneNumberController = TextEditingController();
  final phoneCodeController = PhoneCodeController();

  String get phoneNumber => phoneNumberController.text;
  String get phoneCode => phoneCodeController.code;

  void initPhoneCodeController(List<Country> countryList) {
    if (phoneCodeController.code == '') {
      phoneCodeController.setCodeFromLocale(context.locale, countryList);
    }
  }

  void addInvite() {
    if (!formKey.currentState!.validate()) return;
    final phoneNumber = PhoneNumber(phoneCode, this.phoneNumber);
    ref.read(groupSetupControllerProvider.notifier).addInvite(phoneNumber);
    phoneNumberController.clear();
  }

  void removeInvite(PhoneNumber phoneNumber) => setState(() => ref
      .read(groupSetupControllerProvider.notifier)
      .removeInvite(phoneNumber));

  Future<PhoneNumber> pickFromContacts(List<Country> countryList) => ref
      .read(contactsRepositoryProvider)
      .fetchPhoneNumberFromContacts(countryList);

  //TODO import contacts
  void importContacts() {}

  void shareInviteLink() =>
      ref.read(groupSetupControllerProvider.notifier).shareInviteLink();

  void submit() async {
    phoneNumberNode
      ..nextFocus()
      ..unfocus();
    widget.onSuccess?.call();
  }

  @override
  void dispose() {
    phoneCodeController.dispose();
    phoneNumberController.dispose();
    phoneNumberNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(groupSetupControllerProvider);
    final controller = ref.watch(groupSetupControllerProvider.notifier);
    final countryListValue = ref.watch(countryListFutureProvider);
    return ResponsiveSetup(
      formKey: formKey,
      onCancel: () => context.goNamed(AppRoute.home.name),
      title: 'Add some people'.hardcoded,
      description:
          'You can invite your group members through their phone number or by sending them an invite link. You can also do this later.\n\n'
                  'Have a CSV or vCard file? Import contacts instead.'
              .hardcoded,
      content: Column(
        children: [
          //TODO im not liking the country list pattern
          //? im not liking the fact that it is a future basically, and so we have to pass it to wierd places, idk
          //? lets just ignore it because it works or?
          AsyncValueWidget<List<Country>>(
            value: countryListValue,
            //TODO loading widget
            data: (countryList) {
              initPhoneCodeController(countryList);
              return InviteField(
                focusNode: phoneNumberNode,
                phoneNumberController: phoneNumberController,
                phoneCodeController: phoneCodeController,
                pickFromContacts: () => pickFromContacts(countryList),
                onSubmit: addInvite,
              );
            },
          ),
          if (controller.invites.isNotEmpty) ...[
            Space(),
            //TODO give size just like to the messages
            for (final invite in controller.invites)
              InviteTile(invite, onRemove: removeInvite),
          ],
        ],
      ),
      actions: countryListValue.hasValue
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
                child: Text('Create group'.hardcoded),
              ),
            ]
          : [],
    );
  }
}
