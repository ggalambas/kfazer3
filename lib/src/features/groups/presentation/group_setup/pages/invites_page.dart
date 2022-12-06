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
import 'package:kfazer3/src/features/auth/presentation/country_picker/phone_code_controller.dart';
import 'package:kfazer3/src/features/auth/presentation/country_picker/phone_code_dropdown_button.dart';
import 'package:kfazer3/src/features/groups/presentation/group_setup/group_setup_controller.dart';
import 'package:kfazer3/src/features/users/data/contacts_repository.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart_space/smart_space.dart';

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

  //TODO import contacts
  void importContacts() {}

  void shareInviteLink() => Share.share(
        'https://k-fazer.com/invite?code=FGH54V',
        subject: 'Join us at KFazer!',
      );

  void addInvite() {
    if (!formKey.currentState!.validate()) return;
    final phoneNumber = PhoneNumber(phoneCode, this.phoneNumber);
    ref.read(groupSetupControllerProvider.notifier).addInvite(phoneNumber);
    phoneNumberController.clear();
  }

  void removeInvite(PhoneNumber phoneNumber) => setState(() => ref
      .read(groupSetupControllerProvider.notifier)
      .removeInvite(phoneNumber));

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
        //TODO im not liking the country list pattern
        //? im not liking the fact that it is a future basically, and so we have to pass it to wierd places, idk
        //? lets just ignore it because it works or?
        AsyncValueWidget<List<Country>>(
          value: countryListValue,
          //TODO loading widget
          data: (countryList) {
            initPhoneCodeController(countryList);
            return InviteFormField(
              focusNode: phoneNumberNode,
              phoneNumberController: phoneNumberController,
              phoneCodeController: phoneCodeController,
              countryList: countryList,
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

//TODO move to another file?
class InviteFormField extends ConsumerWidget {
  final FocusNode focusNode;
  final TextEditingController phoneNumberController;
  final PhoneCodeController phoneCodeController;
  final List<Country> countryList;
  final VoidCallback onSubmit;

  const InviteFormField({
    super.key,
    required this.focusNode,
    required this.phoneNumberController,
    required this.phoneCodeController,
    required this.countryList,
    required this.onSubmit,
  });

  Future<void> pickFromContacts(
    WidgetRef ref,
    List<Country> countryList,
  ) async {
    final phoneNumber = await ref
        .read(contactsRepositoryProvider)
        .fetchPhoneNumberFromContacts(countryList);
    if (phoneNumber.code.isNotEmpty) {
      phoneCodeController.code = phoneNumber.code;
    }
    phoneNumberController.text = phoneNumber.number;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      focusNode: focusNode,
      controller: phoneNumberController,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      onEditingComplete: onSubmit,
      validator: (phoneNumber) => ref
          .read(groupSetupControllerProvider.notifier)
          .phoneNumberErrorText(context, phoneNumber ?? ''),
      decoration: InputDecoration(
        labelText: context.loc.phoneNumber,
        prefix: PhoneCodeDropdownPrefix(controller: phoneCodeController),
        suffixIcon: ValueListenableBuilder(
            valueListenable: phoneNumberController,
            builder: (context, _, __) {
              return phoneNumberController.text.isNotEmpty
                  ? TextButton(
                      onPressed: onSubmit,
                      child: Text('Add'.hardcoded),
                    )
                  : IconButton(
                      onPressed: () => pickFromContacts(ref, countryList),
                      icon: const Icon(Icons.perm_contact_calendar),
                    );
            }),
      ),
    );
  }
}

//TODO show contact name
class InviteTile extends StatelessWidget {
  final PhoneNumber phoneNumber;
  final void Function(PhoneNumber phoneNumber) onRemove;

  const InviteTile(
    this.phoneNumber, {
    super.key,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.only(left: kSpace * 2),
      title: Text(phoneNumber.toString()),
      trailing: IconButton(
        tooltip: context.loc.delete, //!
        iconSize: kSmallIconSize,
        onPressed: () => onRemove(phoneNumber),
        icon: const Icon(Icons.clear),
      ),
    );
  }
}
