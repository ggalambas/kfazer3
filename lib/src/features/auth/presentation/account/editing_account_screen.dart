import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/common_widgets/tap_to_unfocus.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/domain/updatable_app_user.dart';
import 'package:kfazer3/src/features/auth/presentation/account/image_editing_controller.dart';
import 'package:kfazer3/src/features/auth/presentation/country_picker/phone_code_dropdown_button.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

import 'account_bar.dart';
import 'editing_account_screen_controller.dart';

class EditingAccountScreen extends ConsumerStatefulWidget {
  const EditingAccountScreen({super.key});

  @override
  ConsumerState<EditingAccountScreen> createState() =>
      _EditingAccountScreenState();
}

class _EditingAccountScreenState extends ConsumerState<EditingAccountScreen> {
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

  void save() async {
    setState(() => submitted = true);
    if (!formKey.currentState!.validate()) return;
    final phoneNumber = PhoneNumber(phoneCode, this.phoneNumber);
    final updatedUser = user.updateName(name).updatePhoneNumber(phoneNumber);
    await ref
        .read(editingAccountScreenControllerProvider.notifier)
        .save(updatedUser);
    if (mounted) context.goNamed(AppRoute.account.name);
  }

  void pickImage() async {
    final option = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Profile photo'.hardcoded),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, //?
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    side: BorderSide(color: context.theme.dividerColor),
                    fixedSize: const Size.square(
                      kMinInteractiveDimension,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, 0),
                  child: const Icon(Icons.camera),
                ),
                Space(),
                Text('Camera'.hardcoded),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    side: BorderSide(color: context.theme.dividerColor),
                    fixedSize: const Size.square(
                      kMinInteractiveDimension,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, 1),
                  child: const Icon(Icons.image),
                ),
                Space(),
                Text('Gallery'.hardcoded),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    onPrimary: context.colorScheme.error,
                    side: BorderSide(color: context.theme.dividerColor),
                    fixedSize: const Size.square(
                      kMinInteractiveDimension,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, 2),
                  child: const Icon(Icons.delete),
                ),
                Space(),
                Text('Delete'.hardcoded),
              ],
            ),
          ],
        ),
      ),
    );
    print(option);
    if (option == null) return;
    if (option == 3) return; //TODO delete photo

    final source = option == 1 ? ImageSource.gallery : ImageSource.gallery;
    final bytes = await ref
        .read(imageEditingControllerProvider.notifier)
        .pickProfilePicture(source);
    if (bytes != null) setState(() => image = MemoryImage(bytes));
  }

  void removeImage() => setState(() => image = null);

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      editingAccountScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(editingAccountScreenControllerProvider);
    final imageState = ref.watch(imageEditingControllerProvider);
    return TapToUnfocus(
      child: Scaffold(
        appBar: EditingAccountBar(
          loading: state.isLoading,
          onSave: imageState.isLoading ? null : save,
        ),
        body: ResponsiveCenter(
          maxContentWidth: Breakpoint.tablet,
          padding: EdgeInsets.all(kSpace * 2),
          child: ListView(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: nameController,
                      builder: (context, _, __) {
                        return Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Avatar(
                              radius: kSpace * 10,
                              foregroundImage: image,
                              text: nameController.text,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: context.colorScheme.surface,
                                shape: const CircleBorder(),
                                fixedSize: const Size.square(
                                  kMinInteractiveDimension,
                                ),
                              ),
                              onPressed: state.isLoading ? null : pickImage,
                              child: const Icon(Icons.camera_alt),
                            ),
                          ],
                        );
                      },
                    ),
                    Space(4),
                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Display name'.hardcoded,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (name) {
                        if (!submitted) return null;
                        return ref
                            .read(
                                editingAccountScreenControllerProvider.notifier)
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
                            .read(
                                editingAccountScreenControllerProvider.notifier)
                            .phoneNumberErrorText(phoneNumber ?? '');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
