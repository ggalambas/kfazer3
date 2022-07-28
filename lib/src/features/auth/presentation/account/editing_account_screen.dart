import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/common_widgets/tap_to_unfocus.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/data/country_repository.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/features/auth/domain/phone_number.dart';
import 'package:kfazer3/src/features/auth/domain/updatable_app_user.dart';
import 'package:kfazer3/src/features/auth/presentation/account/account_screen_controller.dart';
import 'package:kfazer3/src/features/auth/presentation/country_picker/country_picker.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:smart_space/smart_space.dart';

import 'account_bar.dart';

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
  final countryController = CountryController();

  String get name => nameController.text;
  String get phoneNumber => phoneNumberController.text;
  String get phoneCode => countryController.value.phoneCode;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  var submitted = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  void save() {
    setState(() => submitted = true);
    if (!formKey.currentState!.validate()) return;
    final phoneNumber = PhoneNumber(phoneCode, this.phoneNumber);
    final updatedUser = user.updateName(name).updatePhoneNumber(phoneNumber);
    ref.read(accountScreenControllerProvider.notifier).save(updatedUser);
  }

  void signOut() async {
    final logout = await showAlertDialog(
      context: context,
      title: 'Are you sure?'.hardcoded,
      cancelActionText: 'Cancel'.hardcoded,
      defaultActionText: 'Sign Out'.hardcoded,
    );
    if (logout == true) {
      ref.read(accountScreenControllerProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      accountScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final countryListValue = ref.watch(countryListFutureProvider);
    final state = ref.watch(accountScreenControllerProvider);

    return TapToUnfocus(
      child: Scaffold(
        appBar: EditingAccountBar(
          loading: state.isLoading,
          onSave: save,
        ),
        body: AsyncValueWidget<List<Country>>(
          value: countryListValue,
          data: (countryList) => ResponsiveCenter(
            maxContentWidth: Breakpoint.tablet,
            padding: EdgeInsets.all(kSpace * 2),
            child: ListView(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      //TODO import photo
                      ValueListenableBuilder(
                        valueListenable: nameController,
                        builder: (context, _, __) {
                          return Avatar.fromUser(
                            user.updateName(nameController.text),
                            radius: kSpace * 10,
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
                              .read(accountScreenControllerProvider.notifier)
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
                          prefix: CountryPickerPrefix(
                            controller: countryController,
                            countries: countryList,
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (phoneNumber) {
                          if (!submitted) return null;
                          return ref
                              .read(accountScreenControllerProvider.notifier)
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
      ),
    );
  }
}
