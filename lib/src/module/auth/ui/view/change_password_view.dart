import 'package:flutter/material.dart';
import 'package:williamharri/src/core/common/textfields/s_textfield.dart';
import '../../../../core/base/reactive_ui/save_button.dart';
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
            ),
            CustomTextField(
              controller: controller,
              hintText: "New Password",
            ),
            CustomTextField(
              controller: controller,
              hintText: "Confirm Password",
            ),
            RSaveButton(
              height: 52,
              key: UniqueKey(),
              buttonStatusNotifier: signupController.processNotifier,
              saveText: "Save",
              doneText: "Successful",
              loadingText: "Signing Up...",
              onSave: (processNotifier) async {
                signupController.signup();
              },
              onDone: () {},
            ),
          ],
        ),
      ),
    );
  }
}

