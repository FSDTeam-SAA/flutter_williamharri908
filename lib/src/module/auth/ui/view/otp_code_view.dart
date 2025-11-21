import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/base/reactive_ui/save_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/routing/route_names.dart';
import '../../controller/login_controller.dart';
import 'reset_password_view.dart';

class OtpCodeView extends StatelessWidget {
  OtpCodeView({super.key});
  final otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final SignInController signInController = Get.put(SignInController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: const Text('Enter security code'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset(Assets.appLogo, width: 161, height: 100)),
            Text(
              'Enter OTP code',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            Text(
              maxLines: 2,
              "We have share a code of your registered email ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 20),
            Pinput(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              autofocus: true,
              length: 6,
              controller: otpController,
              defaultPinTheme: PinTheme(
                height: 55,
                width: 50,
                textStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.context(context).primaryColor,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              submittedPinTheme: PinTheme(
                height: 55,
                width: 50,
                textStyle: TextStyle(
                  fontSize: 18,
                  color: AppColors.context(context).primaryColor,
                  fontWeight: FontWeight.w700,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onCompleted: (pin) => print("Entered OTP: $pin"),
            ),
            SizedBox(height: 50),
            RSaveButton(
              height: 52,
              key: UniqueKey(),
              buttonStatusNotifier: signInController.stn,
              saveText: "Verify",
              doneText: "Successful",
              loadingText: "Sending OTP...",
              onSave: (processNotifier) async {
                Get.to(() => ResetPasswordView());
                // await signInController .resetPassword(SnackbarNotifier(context: context));
              },
              onDone: () {
                // Navigator.pushNamed(context, RouteNames.resetPassword);
              },
            ),
            SizedBox(height: 30),
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Don\'t get a code ? ',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  children: [
                    TextSpan(
                      text: 'Click Here',

                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, RouteNames.login);
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
            ),
          ],
        ),
      ),
    );
  }
}
