import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:williamharri/src/module/auth/controller/verify_reset_otp_controller.dart';
import '../../../../core/base/reactive_ui/save_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/notifiers/snackbar_notifier.dart';

class ResetOtpCodeView extends StatefulWidget {
  final String email;

  const ResetOtpCodeView({super.key, required this.email});

  @override
  State<ResetOtpCodeView> createState() => _OtpCodeViewState();
}

class _OtpCodeViewState extends State<ResetOtpCodeView> {
  late final TextEditingController otpController;
  late final ResetPasswordOtpController controller;

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();

    controller = ResetPasswordOtpController(
      email: widget.email,
      snackbarNotifier: SnackbarNotifier(context: context),
    );
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: const Text('Enter Security Code'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset(Assets.appLogo, width: 161, height: 100)),
            SizedBox(height: 16),
            Text('Enter OTP code', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            Text(
              "We have sent a code to your registered email",
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
                textStyle: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.context(context).primaryColor, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (pin) => controller.otp = pin,
              onCompleted: (pin) => controller.otp = pin,
            ),
            SizedBox(height: 50),
            RSaveButton(
              height: 52,
              key: UniqueKey(),
              buttonStatusNotifier: controller.processNotifier,
              saveText: "Verify",
              doneText: "Verified",
              loadingText: "Verifying...",
              onSave: (processNotifier) async {
                controller.verifyOtp();
              },
              onDone: () {},
            ),
            SizedBox(height: 30),
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Didn\'t get a code? ',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  children: [
                    TextSpan(
                      text: 'Click Here',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, RouteNames.login);
                        },
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
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
