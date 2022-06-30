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
import 'package:smart_space/smart_space.dart';

class PhoneSignInPage extends ConsumerStatefulWidget {
  final VoidCallback? onSuccess;
  const PhoneSignInPage({super.key, this.onSuccess});

  @override
  ConsumerState<PhoneSignInPage> createState() => _PhoneSignInPageState();
}

class _PhoneSignInPageState extends ConsumerState<PhoneSignInPage> {
  // final formKey = GlobalKey<FormState>();
  final phoneNumberNode = FocusNode();
  final phoneNumberController = TextEditingController();

  String get phoneNumber => phoneNumberController.text;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  // final submitted = false;

  @override
  void dispose() {
    phoneNumberController.dispose();
    phoneNumberNode.dispose();
    super.dispose();
  }

  void submit(BuildContext context) async {
    phoneNumberNode
      ..nextFocus()
      ..unfocus();
    final controller = ref.read(signInControllerProvider.notifier);
    final success = await controller.submit(SignInPage.phone, phoneNumber);
    if (success) widget.onSuccess?.call();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signInControllerProvider);
    final countryListValue = ref.watch(countryListFutureProvider);
    return SignInLayout(
      // formKey: formKey,
      title: 'Welcome to KFazer'.hardcoded,
      description: 'We will need to verify your phone number.\n'
              'On pressing "next", you are accepting our Terms of Use '
              'and agreeing with our Privacy Policy.'
          .hardcoded,
      content: [
        AsyncValueWidget<List<Country>>(
          value: countryListValue,
          data: (countryList) => TextField(
            focusNode: phoneNumberNode,
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
                child: CountryPicker(countries: countryList),
              ),
            ),
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            // validator: (phoneNumber) => !submitted ? null : state,
          ),
        ),
      ],
      cta: [
        LoadingElevatedButton(
          isLoading: state.isLoading,
          onPressed: () => submit(context),
          text: 'Next'.hardcoded,
        ),
      ],
    );
  }
}
