import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/alert_dialogs.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/common_widgets/single_item_popup_menu_button.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/data/country_repository.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/features/auth/presentation/account/account_screen_controller.dart';
import 'package:kfazer3/src/features/auth/presentation/country_picker/country_picker.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_controller.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:smart_space/smart_space.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  late final user = ref.watch(authRepositoryProvider).currentUser!;

  late Country selectedCountry;
  final formKey = GlobalKey<FormState>();
  late final nameController = TextEditingController(text: user.name);
  late final phoneNumberController = TextEditingController(
    text: user.phoneNumber,
  );

  String get name => nameController.text;
  String get phoneNumber => phoneNumberController.text;

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

  void selectCountry(List<Country> countryList) {
    final localeCode = Localizations.localeOf(context).countryCode;
    selectedCountry = countryList.firstWhere(
      (country) => country.code == localeCode,
      orElse: () => countryList.first,
    );
  }

  void save() async {
    setState(() => submitted = true);
    if (!formKey.currentState!.validate()) return;

    final controller = ref.read(accountScreenControllerProvider.notifier);
    await controller.save(name, phoneNumber);
  }

  void signOut() async {
    final logout = await showAlertDialog(
      context: context,
      title: 'Are you sure?'.hardcoded,
      cancelActionText: 'Cancel'.hardcoded,
      defaultActionText: 'Logout'.hardcoded,
    );
    if (logout == true) ref.read(signOutControllerProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context) {
    //TODO when coming back, country get late initialization error
    ref.listen<AsyncValue<List<Country>>>(
      countryListFutureProvider,
      (_, countryListValue) => countryListValue.whenData(selectCountry),
    );
    ref.listen<AsyncValue>(
      signOutControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final countryListValue = ref.watch(countryListFutureProvider);
    final state = ref.watch(accountScreenControllerProvider);
    final signOutState = ref.watch(signOutControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'.hardcoded),
        actions: [
          state.value
              ? LoadingTextButton(
                  isLoading: state.isLoading,
                  onPressed: save,
                  child: Text('Save'.hardcoded),
                )
              : IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed:
                      ref.read(accountScreenControllerProvider.notifier).edit),
          SingleItemPopupMenuButton(
            onSelected: () => showNotImplementedAlertDialog(context: context),
            item: Text('Delete account'.hardcoded),
          ),
        ],
      ),
      body: AsyncValueWidget<List<Country>>(
          value: countryListValue,
          data: (countryList) => CustomScrollView(
                slivers: [
                  ResponsiveSliverCenter(
                    maxContentWidth: Breakpoint.tablet,
                    padding: EdgeInsets.all(kSpace * 2),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Center(
                            child: Avatar.fromUser(user, radius: 80),
                          ),
                          Space(4),
                          //TODO refact input decoration to the theme?
                          TextFormField(
                            enabled: state.value,
                            controller: nameController,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Display name'.hardcoded,
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(kSpace),
                              ),
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (name) {
                              if (!submitted) return null;
                              final controller =
                                  ref.read(signInControllerProvider.notifier);
                              return controller.nameErrorText(name ?? '');
                            },
                          ),
                          Space(),
                          TextFormField(
                            enabled: state.value,
                            controller: phoneNumberController,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              labelText: 'Phone number'.hardcoded,
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(kSpace),
                              ),
                              prefix: Padding(
                                padding: EdgeInsets.only(right: kSpace),
                                child: CountryPicker(
                                  selected: selectedCountry,
                                  countries: countryList,
                                  onChanged: (country) {
                                    if (country != selectedCountry) {
                                      setState(() => selectedCountry = country);
                                    }
                                  },
                                ),
                              ),
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (phoneNumber) {
                              if (!submitted) return null;
                              final controller =
                                  ref.read(signInControllerProvider.notifier);
                              return controller
                                  .phoneNumberErrorText(phoneNumber ?? '');
                            },
                          ),
                          Space(2),
                          LoadingElevatedButton(
                            isLoading: signOutState.isLoading,
                            onPressed: signOut,
                            child: Text('Sign out'.hardcoded),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
    );
  }
}
