import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/core/common/textfields/s_textfield.dart';

import '../../../../core/base/reactive_ui/save_button.dart';
import '../../../../core/notifiers/snackbar_notifier.dart';
import '../../controller/signup_controller.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final SignupController signupController = SignupController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text("Change Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          children: [
            CustomTextField(
              controller: controller,
              hintText: "Current Password",
              //isPassword: true,
            ),
            CustomTextField(
              controller: controller,
              hintText: "New Password",
              // isPassword: true,
            ),
            CustomTextField(
              controller: controller,
              hintText: "Confirm Password",
              //  isPassword: true,
            ),

         /*   RSaveButton(
              height: 52,
              key: UniqueKey(),
              //  buttonStatusNotifier: signInController.stn,
              saveText: "Continue",
              doneText: "Successful",
              loadingText: "Sending OTP...",
              onSave: (processNotifier) async {
                //  Get.to(() => OtpCodeView());
                // await signInController .resetPassword(SnackbarNotifier(context: context));
              },
              onDone: () {},
            ),*/
            RSaveButton(
              height: 52,
              key: UniqueKey(),
              buttonStatusNotifier: signupController.stn,
              saveText: "Save",
              doneText: "Successful",
              loadingText: "Signing Up...",
              onSave: (processNotifier) async {
                signupController.signup(SnackbarNotifier(context: context));
              },
              onDone: () {},
            ),
          ],
        ),
      ),
    );
  }
}

