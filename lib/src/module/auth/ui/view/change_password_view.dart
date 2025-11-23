import 'package:flutter/material.dart';
import 'package:williamharri/src/core/common/textfields/s_textfield.dart';

import '../../../../core/base/reactive_ui/save_button.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

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

            RSaveButton(
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
            ),
          ],
        ),
      ),
    );
  }
}
