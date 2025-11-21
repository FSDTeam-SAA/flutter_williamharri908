import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/app/splash_view.dart';

import '../../../../core/base/reactive_ui/save_button.dart';
import '../../../../core/common/textfields/password_textfield.dart';

import '../../../../core/constants/assets.dart';
import '../../controller/login_controller.dart';
import 'otp_code_view.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final SignInController signInController = Get.put(SignInController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,

        /// title: const Text("Create New Password"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset(Assets.appLogo, width: 150, height: 100)),
            Text(
              "Reset Your Password",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            Text("Create a new password"),
            const SizedBox(height: 20),

            PasswordTextfield(
              labelText: "New Password",
              onChanged: (value) {},
              validationCheck: (value) {
                if (value.isEmpty) return "Please enter password";
                if (value.length < 6) return "Password too short";
                return null;
              },
            ),
            const SizedBox(height: 12),
            PasswordTextfield(
              labelText: "Confirm Password",
              onChanged: (value) {},
              validationCheck: (value) {
                if (value.isEmpty) return "Please enter password";
                if (value.length < 6) return "Password too short";
                return null;
              },
            ),

            const SizedBox(height: 20),
            RSaveButton(
              height: 52,
              key: UniqueKey(),
              buttonStatusNotifier: signInController.stn,
              saveText: "Reset Password",
              doneText: "Successful",
              loadingText: "Sending OTP...",
              onSave: (processNotifier) async {
                Get.to(SplashView());
                //Get.toNamed(RouteNames.resetPassword);
                // await signInController  .resetPassword(SnackbarNotifier(context: context));
              },
              onDone: () {},
            ),
          ],
        ),
      ),
    );
  }
}
