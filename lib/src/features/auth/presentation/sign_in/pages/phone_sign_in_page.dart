import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/features/auth/data/country_repository.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/features/auth/presentation/country_picker/country_picker.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_controller.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_layout.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_screen.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/external_uri.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneSignInPage extends ConsumerStatefulWidget {
  final VoidCallback? onSuccess;
  const PhoneSignInPage({super.key, this.onSuccess});

  @override
  ConsumerState<PhoneSignInPage> createState() => _PhoneSignInPageState();
}

class _PhoneSignInPageState extends ConsumerState<PhoneSignInPage> {
  late Country selectedCountry;
  final formKey = GlobalKey<FormState>();
  final phoneNumberNode = FocusNode();
  final phoneNumberController = TextEditingController();

  String get phoneCode => selectedCountry.phoneCode;
  String get phoneNumber => phoneNumberController.text;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  var submitted = false;

  void selectCountry(List<Country> countryList) {
    final localeCode = Localizations.localeOf(context).countryCode;
    selectedCountry = countryList.firstWhere(
      (country) => country.code == localeCode,
      orElse: () => countryList.first,
    );
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    phoneNumberNode.dispose();
    super.dispose();
  }

  void submit() async {
    phoneNumberNode
      ..nextFocus()
      ..unfocus();

    setState(() => submitted = true);
    if (!formKey.currentState!.validate()) return;

    final controller = ref.read(signInControllerProvider.notifier);
    final success = await controller.submit(
      SignInPage.phone,
      '$phoneCode$phoneNumber',
    );
    if (success) widget.onSuccess?.call();
  }

  @override
  Widget build(BuildContext context) {
    //TODO when coming back, country get late initialization error
    ref.listen<AsyncValue<List<Country>>>(
      countryListFutureProvider,
      (_, countryListValue) => countryListValue.whenData(selectCountry),
    );
    final state = ref.watch(signInControllerProvider);
    final countryListValue = ref.watch(countryListFutureProvider);
    return SignInLayout(
      formKey: formKey,
      title: 'Welcome to KFazer'.hardcoded,
      description: TextSpan(
        text: 'We will need to verify your phone number.\n'
            'On pressing "next", you agree to the ',
        children: [
          TextSpan(
            text: 'Terms of Service',
            style: TextStyle(color: context.colorScheme.primary),
            recognizer: TapGestureRecognizer()
              ..onTap = () => launchUrl(ExternalUri.terms),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(color: context.colorScheme.primary),
            recognizer: TapGestureRecognizer()
              ..onTap = () => launchUrl(ExternalUri.privacy),
          ),
        ],
      ),
      content: [
        AsyncValueWidget<List<Country>>(
          value: countryListValue,
          data: (countryList) => TextFormField(
            focusNode: phoneNumberNode,
            controller: phoneNumberController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Phone number'.hardcoded,
              prefix: CountryPickerPrefix(
                selected: selectedCountry,
                countries: countryList,
                onChanged: (country) {
                  if (country != selectedCountry) {
                    setState(() => selectedCountry = country);
                  }
                },
              ),
            ),
            onEditingComplete: submit,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (phoneNumber) {
              if (!submitted) return null;
              final controller = ref.read(signInControllerProvider.notifier);
              return controller.phoneNumberErrorText(phoneNumber ?? '');
            },
          ),
        ),
      ],
      cta: [
        if (countryListValue.hasValue)
          LoadingElevatedButton(
            isLoading: state.isLoading,
            onPressed: submit,
            child: Text('Next'.hardcoded),
          ),
      ],
    );
  }
}
