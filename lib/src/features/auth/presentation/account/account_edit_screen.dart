import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/avatar_picker/avatar_picker.dart';
import 'package:kfazer3/src/common_widgets/avatar_picker/image_controller.dart';
import 'package:kfazer3/src/common_widgets/edit_bar.dart';
import 'package:kfazer3/src/common_widgets/responsive_scaffold.dart';
import 'package:kfazer3/src/common_widgets/tap_to_unfocus.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/domain/mutable_app_user.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/presentation/auth_validators.dart';
import 'package:kfazer3/src/features/auth/presentation/country_picker/phone_code_controller.dart';
import 'package:kfazer3/src/features/auth/presentation/country_picker/phone_code_dropdown_button.dart';
import 'package:kfazer3/src/localization/localization_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:smart_space/smart_space.dart';

import 'account_edit_controller.dart';

class AccountEditScreen extends ConsumerStatefulWidget {
  const AccountEditScreen({super.key});

  @override
  ConsumerState<AccountEditScreen> createState() => _AccountEditScreenState();
}

class _AccountEditScreenState extends ConsumerState<AccountEditScreen> {
  final formKey = GlobalKey<FormState>();
  late final user = ref.read(currentUserStateProvider);
  late final nameController = TextEditingController(text: user.name);
  late final phoneNumberController = TextEditingController(
    text: user.phoneNumber.number,
  );
  late final phoneCodeController = PhoneCodeController(
    code: user.phoneNumber.code,
  );
  late final imageController = ImageController(url: user.photoUrl);

  String get name => nameController.text;
  String get phoneNumber => phoneNumberController.text;
  String get phoneCode => phoneCodeController.code;
  ImageProvider? get image => imageController.value;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  var submitted = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneCodeController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    setState(() => submitted = true);
    if (!formKey.currentState!.validate()) return;

    final phoneNumber = PhoneNumber(phoneCode, this.phoneNumber);
    final updatedUser = user.updateName(name).updatePhoneNumber(phoneNumber);

    await ref
        .read(accountEditControllerProvider.notifier)
        .save(updatedUser, imageController);

    if (mounted) goBack();
  }

  void goBack() => context.goNamed(AppRoute.accountDetails.name);

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      accountEditControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(accountEditControllerProvider);

    return TapToUnfocus(
      child: ResponsiveScaffold(
        padding: EdgeInsets.all(kSpace * 2),
        appBar: EditBar(
          loading: state.isLoading,
          title: context.loc.account,
          onSave: save,
          onCancel: goBack,
        ),
        rail: EditRail(
          loading: state.isLoading,
          title: context.loc.account,
          onSave: save,
          onCancel: goBack,
        ),
        builder: (railPadding) => Form(
          key: formKey,
          child: ListView(
            padding: railPadding,
            children: [
              AvatarPicker(
                imageController: imageController,
                textController: nameController,
                disabled: state.isLoading,
              ),
              Space(4),
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                maxLength: kNameLength,
                decoration: InputDecoration(
                  counterText: '',
                  labelText: context.loc.displayName,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (name) {
                  if (!submitted) return null;
                  return ref
                      .read(accountEditControllerProvider.notifier)
                      .nameErrorText(context, name ?? '');
                },
              ),
              Space(),
              TextFormField(
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: context.loc.phoneNumber,
                  prefix: PhoneCodeDropdownPrefix(
                    controller: phoneCodeController,
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (phoneNumber) {
                  if (!submitted) return null;
                  return ref
                      .read(accountEditControllerProvider.notifier)
                      .phoneNumberErrorText(context, phoneNumber ?? '');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
