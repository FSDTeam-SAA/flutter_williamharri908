import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/core/base/reactive_ui/process_notifier.dart';
import 'package:williamharri/src/core/notifiers/snackbar_notifier.dart';
import 'package:williamharri/src/core/utils/utils.dart';
import 'package:williamharri/src/module/auth/model/verify_otp_param.dart';
import 'package:williamharri/src/module/auth/repo/auth_repo.dart';
import '../ui/view/reset_password_view.dart';

class ResetPasswordOtpController extends ChangeNotifier {
  final AuthRepo authRepo = Get.find<AuthRepo>();
  final ProcessStatusNotifier processNotifier =
      ProcessStatusNotifier(initialStatus: DisabledStatus());
  final SnackbarNotifier snackbarNotifier;

  final String email;

  ResetPasswordOtpController({
    required this.email,
    required this.snackbarNotifier,
  });

  int otpLength = 6;
  String _otp = "";

  String get otp => _otp;

  set otp(String value) {
    _otp = value;
    if (_otp.length == otpLength) {
      processNotifier.setEnabled();
    } else {
      processNotifier.setDisabled();
    }
    notifyListeners();
  }

  Future<void> verifyOtp() async {
    if (processNotifier.status is LoadingStatus) return;

    processNotifier.setLoading();

    final result = await authRepo.verifyCode(
      VerifyOtpParam(email: email, otp: otp),
    );

    handleFold(
      either: result,
      processStatusNotifier: processNotifier,
      successSnackbarNotifier: snackbarNotifier,
      onSuccess: (_) {
        snackbarNotifier.notifySuccess(message: "OTP verified successfully!");
        Get.to(() => ResetPasswordView(email: email, otp: otp,));
      },
    );
  }
}
