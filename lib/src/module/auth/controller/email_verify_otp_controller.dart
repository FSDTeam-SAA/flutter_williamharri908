import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/core/component/reactive_ui/process_notifier.dart';
import 'package:williamharri/src/core/notifiers/snackbar_notifier.dart';
import 'package:williamharri/src/core/utils/utils.dart';
import 'package:williamharri/src/module/auth/model/verify_otp_param.dart';
import 'package:williamharri/src/module/auth/repo/auth_repo.dart';
import 'package:williamharri/src/module/auth/ui/view/login_view.dart';

abstract class EmailVerifyOtpController extends ChangeNotifier {
  final AuthRepo authInterface = Get.find<AuthRepo>();
  final ProcessStatusNotifier prcessNotifier = ProcessStatusNotifier(
    initialStatus: DisabledStatus(),
  );
  final SnackbarNotifier snackbarNotifier;
  final String email;

  EmailVerifyOtpController({required this.email, required this.snackbarNotifier});

  int otpLength = 6;
  String _otp = "";

  String get otp => _otp;

  set otp(String value) {
    _otp = value;
    debugPrint("OTP: $_otp");
    if (_otp.length == otpLength) {
      prcessNotifier.setEnabled();
    } else {
      prcessNotifier.setDisabled();
    }
  }

  void verify();
}

class VerifyAccountViewController extends EmailVerifyOtpController {
  VerifyAccountViewController({
    required super.email,
    required super.snackbarNotifier,
  });

  @override
  void verify() async {
    if (prcessNotifier.status is LoadingStatus) return;

    debugPrint("Verifying OTP...");
    prcessNotifier.setLoading();

    final result = await authInterface.verifyAccount(
      VerifyOtpParam(email: email, otp: otp),
    );

    handleFold(
      either: result,
      processStatusNotifier: prcessNotifier,
      successSnackbarNotifier: snackbarNotifier,
      onSuccess: (_) {
        snackbarNotifier.notifySuccess(message: "Account verified successfully!");
        Get.to(() => LoginView());
      },
      onError: (failure) {
        prcessNotifier.setError();
        snackbarNotifier.notifyError(message: failure.uiMessage);
      },
    );
  }
}
