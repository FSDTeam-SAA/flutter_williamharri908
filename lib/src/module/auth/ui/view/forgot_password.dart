import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/base/reactive_ui/save_button.dart';
import '../../../../core/common/textfields/email_textfield.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/routing/route_names.dart';
import '../../controller/login_controller.dart';
import 'otp_code_view.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final SignInController signInController = Get.put(SignInController());
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
            Text(
              maxLines: 2,
              "Select which contact details should we use to reset your password",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: SizedBox(
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
            ),
            const SizedBox(height: 20),
            RSaveButton(
              height: 52,
              key: UniqueKey(),
              buttonStatusNotifier: signInController.stn,
              saveText: "Continue",
              doneText: "Successful",
              loadingText: "Sending OTP...",
              onSave: (processNotifier) async {
                Get.to(() => OtpCodeView());
                // await signInController .resetPassword(SnackbarNotifier(context: context));
              },
              onDone: () {
                Navigator.pushNamed(context, RouteNames.resetPassword);
              },
            ),
          ],
        ),
      ),
    );
  }
}
