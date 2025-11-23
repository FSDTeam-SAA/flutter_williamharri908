import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:williamharri/src/core/constants/app_colors.dart';
import 'package:williamharri/src/module/account/ui/terms_condition_view.dart';
import '../../../../core/base/reactive_ui/save_button.dart';
import '../../../../core/common/textfields/email_textfield.dart';
import '../../../../core/common/textfields/password_textfield.dart';
import '../../../../core/constants/assets.dart';

import '../../../../core/routing/route_names.dart';
import '../../../profile/ui/view/profile_view.dart';
import '../../controller/login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final SignInController signInController = SignInController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(Assets.appLogo, width: 150, height: 150),
            const SizedBox(height: 20),
            const Text(
              'Welcome Back',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 60,
              child: EmailTextfield(
                onChanged: (value) {
                  print("User typed: $value");
                },
                validationCheck: (value) {
                  if (value.isEmpty) return "Please enter email";
                  if (!value.contains("@")) return "Invalid email";
                  return null;
                },
                labelText: "Email",
                hintText: "Enter Your Email",
                maxLines: 1,
              ),
            ),

            SizedBox(height: 10),

            PasswordTextfield(
              onChanged: (value) {},
              validationCheck: (value) {
                if (value.isEmpty) return "Please enter password";
                if (value.length < 6) return "Password too short";
                return null;
              },
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, RouteNames.forgotPassword);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: AppColors.context(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            RSaveButton(
              height: 52,
              key: UniqueKey(),
              buttonStatusNotifier: signInController.stn,
              saveText: "Sign In",
              doneText: "Successful",
              loadingText: "Signing Up...",
              onSave: (processNotifier) async {
                Get.to(ProfileView());
                // await signInController.signup(SnackbarNotifier(context: context));
              },
              onDone: () {},
            ),
            SizedBox(height: 30),
            RichText(
              text: TextSpan(
                text: 'Don\'t have an account? ',
                style: TextStyle(color: Colors.white, fontSize: 16),
                children: [
                  TextSpan(
                    text: 'Click Here',

                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, RouteNames.signup);
                      },
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 100.0),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.context(context).primaryColor),
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
    );
  }
}
