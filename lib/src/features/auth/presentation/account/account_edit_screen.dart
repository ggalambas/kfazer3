import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/common_widgets/image_picker_badge.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/common_widgets/tap_to_unfocus.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/domain/updatable_app_user.dart';
import 'package:kfazer3/src/features/auth/presentation/account/image_editing_controller.dart';
import 'package:kfazer3/src/features/auth/presentation/country_picker/phone_code_dropdown_button.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:smart_space/smart_space.dart';

import '../../../../common_widgets/details_bar.dart';
import 'account_edit_screen_controller.dart';

class AccountEditScreen extends ConsumerStatefulWidget {
  const AccountEditScreen({super.key});

  @override
  ConsumerState<AccountEditScreen> createState() => _AccountEditScreenState();
}

class _AccountEditScreenState extends ConsumerState<AccountEditScreen> {
  final formKey = GlobalKey<FormState>();
  late final user = ref.read(authRepositoryProvider).currentUser!;
  late final nameController = TextEditingController(text: user.name);
  late final phoneNumberController = TextEditingController(
    text: user.phoneNumber.number,
  );
  late final phoneCodeController = PhoneCodeController(
    code: user.phoneNumber.code,
  );

  late ImageProvider? image =
      user.photoUrl == null ? null : NetworkImage(user.photoUrl!);
  String get name => nameController.text;
  String get phoneNumber => phoneNumberController.text;
  String get phoneCode => phoneCodeController.code;

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
    //TODO save image
    final updatedUser = user.updateName(name).updatePhoneNumber(phoneNumber);
    await ref
        .read(accountEditScreenControllerProvider.notifier)
        .save(updatedUser);
    if (mounted) goBack();
  }

  void applyImage(XFile? file) async {
    if (file == null) return setState(() => image = null);
    final bytes = await ref
        .read(imageEditingControllerProvider.notifier)
        .readAsBytes(file);
    if (bytes != null) setState(() => image = MemoryImage(bytes));
  }

  void goBack() => context.goNamed(AppRoute.accountDetails.name);

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      accountEditScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    ref.listen<AsyncValue>(
      imageEditingControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(accountEditScreenControllerProvider);
    final imageState = ref.watch(imageEditingControllerProvider);
    return TapToUnfocus(
      child: Scaffold(
        appBar: EditingBar(
          title: 'Account'.hardcoded,
          loading: state.isLoading,
          onCancel: goBack,
          onSave: imageState.isLoading ? null : () => save(),
        ),
        body: SingleChildScrollView(
          child: ResponsiveCenter(
            maxContentWidth: Breakpoint.tablet,
            padding: EdgeInsets.all(kSpace * 2),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  ValueListenableBuilder(
                    valueListenable: nameController,
                    builder: (context, _, __) {
                      return ImagePickerBadge(
                        loading: imageState.isLoading,
                        disabled: state.isLoading,
                        onImagePicked: applyImage,
                        showDeleteOption: image != null,
                        child: Avatar(
                          radius: kSpace * 10,
                          foregroundImage: image,
                          text: name,
                        ),
                      );
                    },
                  ),
                  Space(4),
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    maxLength: kNameLength,
                    decoration: InputDecoration(
                      counterText: '',
                      labelText: 'Display name'.hardcoded,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (name) {
                      if (!submitted) return null;
                      return ref
                          .read(accountEditScreenControllerProvider.notifier)
                          .nameErrorText(name ?? '');
                    },
                  ),
                  Space(),
                  TextFormField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Phone number'.hardcoded,
                      prefix: PhoneCodeDropdownPrefix(
                        controller: phoneCodeController,
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (phoneNumber) {
                      if (!submitted) return null;
                      return ref
                          .read(accountEditScreenControllerProvider.notifier)
                          .phoneNumberErrorText(phoneNumber ?? '');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
