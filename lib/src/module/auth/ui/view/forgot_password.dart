import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/component/reactive_ui/widget/save_button.dart';
import '../../../../core/common/textfields/email_textfield.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/notifiers/snackbar_notifier.dart';
import '../../controller/forget_password_controller.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgetPasswordController controller = Get.put(
      ForgetPasswordController(snackbarNotifier: SnackbarNotifier(context: context)),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: const Text("Forgot Password"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(Assets.appLogo, width: 150, height: 150),
            const SizedBox(height: 16),
            const Text(
              maxLines: 3,
              "Select which contact details should we use to reset your password",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            EmailTextfield(
              onChanged: (value) => controller.email = value,
              validationCheck: (value) {
                if (value.isEmpty) return "Please enter email";
                if (!value.contains("@")) return "Invalid email";
                return null;
              },
              labelText: "Email",
              hintText: "Enter Your Email",
              maxLines: 1,
            ),
            const SizedBox(height: 30),
            RSaveButton(
              height: 52,
              key: UniqueKey(),
              buttonStatusNotifier: controller.processNotifier,
              saveText: "Continue",
              loadingText: "Sending OTP...",
              doneText: "OTP Sent",
              onSave: (_) async {
                await controller.sendOtp();
              },
              onDone: () {},
            ),
          ],
        ),
      ),
    );
  }
}
