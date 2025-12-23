import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:williamharri/src/module/account/ui/terms_condition_view.dart';

import '../../../../core/component/reactive_ui/widget/save_button.dart';
import '../../../../core/common/textfields/email_textfield.dart';
import '../../../../core/common/textfields/name_textfield.dart';
import '../../../../core/common/textfields/password_textfield.dart';
import '../../../../core/common/textfields/textfield_prefix_icon.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/utils/helpers/validation.dart';
import '../../controller/signup_controller.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final SignupController signupController = SignupController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Image.asset(
                    Assets.appLogo,
                    width: 150,
                    //height: 150,
                  ),
                ),
              ),
              const Text(
                'Create Your Account',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const Text(
                'Join us and start applying today',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 20),
              Column(
                spacing: 8,
                children: [
                  NameTextfield(
                    prefiexIcon: TextfieldPrefixIcon(assetName: Assets.user),
                    labelText: "Full Name",
                    hintText: "Enter Your Full Name",

                    onChanged: (value) {},
                    validationCheck: (value) {
                      if (value.isEmpty) return "Please enter your name";
                      return null;
                    },
                  ),
                  SizedBox(height: 2),

                  NameTextfield(
                    prefiexIcon: TextfieldPrefixIcon(assetName: Assets.phone),
                    labelText: "Enter Phone Number",
                    hintText: "Enter Phone Number",

                    onChanged: (value) {},
                    validationCheck: (value) {
                      if (value.isEmpty) return "Please enter phone number";
                      return null;
                    },
                  ),
                  SizedBox(height: 2),
                  NameTextfield(
                    prefiexIcon: TextfieldPrefixIcon(assetName: Assets.user),
                    labelText: "Username",
                    hintText: "Enter Your Username",
                    onChanged: signupController.setFullName,
                    validationCheck: (value) {
                      if (value.isEmpty) return "Please enter your name";
                      return null;
                    },
                  ),
                  SizedBox(height: 2),

                  EmailTextfield(
                    onChanged: signupController.setEmail,
                    validationCheck: (value) {
                      if (value.isEmpty) return "Please enter email!";
                      if (!isValidEmail(value)) return "Not a valid email!";
                      return null;
                    },
                  ),
                  SizedBox(height: 2),

                  PasswordTextfield(
                    labelText: "Password",
                    hintText: "Enter Password",
                    onChanged: signupController.setPassword,
                    validationCheck: (value) {
                      if (value.isEmpty) return "Please enter password!";
                      return null;
                    },
                  ),
                  SizedBox(height: 2),

                  PasswordTextfield(
                    labelText: "Confirm Password",
                    hintText: "Enter Confirm Password",
                    onChanged: signupController.setConfirmPassword,
                    validationCheck: (value) {
                      if (value.isEmpty) return "Please confirm password!";
                      if (value != signupController.password.value)
                        return "Passwords do not match!";
                      return null;
                    },
                  ),
                ],
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_box, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          children: [
                            const TextSpan(text: "I agree to the "),
                            TextSpan(
                              text: "Terms & Conditions",
                              style: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TermsConditionView(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              RSaveButton(
                height: 52,
                key: UniqueKey(),
                buttonStatusNotifier: signupController.processNotifier,
                saveText: "Sign Up",
                doneText: "Successful",
                loadingText: "Signing Up...",
                onSave: (processNotifier) async {
                  await signupController.signup(
                    buttonNotifier: processNotifier,
                    snackbarNotifier: signupController.snackbarNotifier,
                  );
                },
                onDone: () {},
              ),

              SizedBox(height: 12),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Already have an account ? ",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    children: [
                      TextSpan(
                        text: "Sign In Here",
                        style: TextStyle(
                          color: AppColors.context(context).primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context, RouteNames.login);
                          },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
