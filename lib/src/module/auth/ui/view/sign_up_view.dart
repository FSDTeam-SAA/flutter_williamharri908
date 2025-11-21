import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/base/reactive_ui/save_button.dart';
import '../../../../core/common/textfields/email_textfield.dart';
import '../../../../core/common/textfields/name_textfield.dart';
import '../../../../core/common/textfields/password_textfield.dart';
import '../../../../core/common/textfields/textfield_prefix_icon.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/notifiers/snackbar_notifier.dart';
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
    // TODO: implement initState
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
                    labelText: "Name",
                    hintText: "Enter Your Name",

                    onChanged: (value) {},
                    validationCheck: (value) {
                      if (value.isEmpty) return "Please enter your name";
                      return null;
                    },
                  ),

                  NameTextfield(
                    prefiexIcon: TextfieldPrefixIcon(assetName: Assets.phone),
                    labelText: "Ener Phone Number",
                    hintText: "Enter Phone Number",

                    onChanged: (value) {},
                    validationCheck: (value) {
                      if (value.isEmpty) return "Please enter phone number";
                      return null;
                    },
                  ),
                  NameTextfield(
                    prefiexIcon: TextfieldPrefixIcon(
                      assetName: Assets.location,
                    ),
                    labelText: "Ener Address",
                    hintText: "Enter Address",

                    onChanged: (value) {},
                    validationCheck: (value) {
                      if (value.isEmpty) return "Please enter phone number";
                      return null;
                    },
                  ),

                  EmailTextfield(
                    onChanged: (value) {
                      signupController.setEmail(value);
                    },
                    validationCheck: (value) {
                      if (value.isEmpty) return "Please enter email!";
                      if (!value.contains("@")) return "Invalid email!";
                      if (!isValidEmail(value)) return "Not a valid email!";
                      return null;
                    },
                    labelText: "Email",
                    hintText: "Enter Your Email",
                    maxLines: 1,
                  ),

                  PasswordTextfield(
                    labelText: "Password",
                    hintText: "Enter Your Password",
                    onChanged: (value) {},
                    validationCheck: (value) {
                      if (value.isEmpty) return "Please enter password!";
                      if (value.length < 6) return "Password too short!";
                      if (!isStrongPassword(value)) return "Password too weak!";
                      return null;
                    },
                  ),

                  PasswordTextfield(
                    labelText: "Confirm Password",
                    hintText: "Enter Your Password",
                    onChanged: (value) {},
                    validationCheck: (value) {
                      if (value.isEmpty) return "Please enter password";
                      if (value.length < 6) return "Password too short";
                      return null;
                    },
                  ),
                ],
              ),

              // terms and condition
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  children: [
                    Icon(Icons.check_box, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: "I agree to the ",
                          style: TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                              text: "Terms & Conditions",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                //decoration: TextDecoration.underline,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(
                                    context,
                                    RouteNames.terms,
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

              // sign up button
              RSaveButton(
                height: 52,
                key: UniqueKey(),
                buttonStatusNotifier: signupController.stn,
                saveText: "Sign Up",
                doneText: "Successful",
                loadingText: "Signing Up...",
                onSave: (processNotifier) async {
                  signupController.signup(SnackbarNotifier(context: context));
                },
                onDone: () {},
              ),
              // Add other text fields like EmailTextfield, PasswordTextfield here
              Padding(
                padding: const EdgeInsets.symmetric(
                  //horizontal: 16.0,
                  vertical: 15.0,
                ),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.context(context).primaryColor,
                    ),
                    //color: AppColors.context(context).primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Join As A Manager',
                      style: TextStyle(
                        color: AppColors.context(context).primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
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
                    Navigator.pushNamed(context, RouteNames.login);
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
