import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/core/base/reactive_ui/save_button.dart';
import 'package:williamharri/src/core/common/textfields/password_textfield.dart';
import 'package:williamharri/src/core/notifiers/snackbar_notifier.dart';
import 'package:williamharri/src/core/constants/assets.dart';
import 'package:williamharri/src/module/auth/controller/resate_password_controller.dart';

class ResetPasswordView extends StatelessWidget {
  final String email;
  final String otp;

  const ResetPasswordView({super.key, required this.email, required this.otp});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      CreateNewPasswordController(email: email, otp: otp),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset(Assets.appLogo, width: 150, height: 100)),
            const SizedBox(height: 20),
            const Text(
              "Create a New Password",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),

            PasswordTextfield(
              labelText: "New Password",
              onChanged: (value) {
                controller.newPassword = value;
                controller.validatePasswords();
              },
              validationCheck: (String text) {
                return null;
              },
            ),
            const SizedBox(height: 12),

            PasswordTextfield(
              labelText: "Confirm Password",
              onChanged: (value) {
                controller.confirmPassword = value;
                controller.validatePasswords();
              },
              validationCheck: (String text) {
                return null;
              },
            ),

            const SizedBox(height: 20),

            RSaveButton(
              height: 52,
              key: UniqueKey(),
              buttonStatusNotifier: controller.processNotifier,
              saveText: "Reset Password",
              doneText: "Successful",
              loadingText: "Please wait...",
              onSave: (_) async {
                controller.resetPassword(SnackbarNotifier(context: context));
              },
              onDone: () {
                Get.offAllNamed('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
