import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/features/auth/data/country_repository.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/features/auth/presentation/country_picker/country_picker.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in_flow/sign_in_layout.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in_flow/sign_in_screen.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:smart_space/smart_space.dart';

class PhoneNumberSignInPage extends ConsumerStatefulWidget {
  const PhoneNumberSignInPage({super.key});

  @override
  ConsumerState<PhoneNumberSignInPage> createState() =>
      _PhoneNumberSignInPageState();
}

class _PhoneNumberSignInPageState extends ConsumerState<PhoneNumberSignInPage> {
  final formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();

  String get phoneNumber => phoneNumberController.text;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  // var _submitted = false;

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  void submit(BuildContext context) {
    FocusScope.of(context).nextFocus();
    context.goNamed(
      AppRoute.signInSubRoute.name,
      params: {'subRoute': SignInSubRoute.verification.name},
    );
  }

  @override
  Widget build(BuildContext context) {
    final countryListValue = ref.watch(countryListFutureProvider);
    return SignInLayout(
      formKey: formKey,
      title: 'Welcome to KFazer'.hardcoded,
      description: 'We will need to verify your phone number.\n'
              'On pressing "next", you are accepting our Terms of Use '
              'and agreeing with our Privacy Policy.'
          .hardcoded,
      form: AsyncValueWidget<List<Country>>(
        value: countryListValue,
        data: (countryList) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'Phone number'.hardcoded,
                        prefix: Padding(
                          padding: EdgeInsets.only(right: kSpace),
                          child: CountryPicker(
                            countries: countryList,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Space(3),
              LoadingElevatedButton(
                text: 'Next'.hardcoded,
                onPressed: () => submit(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
