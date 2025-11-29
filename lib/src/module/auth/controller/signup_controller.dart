import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/core/component/reactive_ui/process_notifier.dart';
import 'package:williamharri/src/core/utils/utils.dart';
import 'package:williamharri/src/module/auth/model/signup_model.dart';
import 'package:williamharri/src/module/auth/repo/auth_repo.dart';
import 'package:williamharri/src/module/auth/ui/view/otp_code_view.dart';
import '../../../core/notifiers/snackbar_notifier.dart';

class SignupController extends GetxController {
  final ProcessStatusNotifier processNotifier = ProcessStatusNotifier(
    initialStatus: EnabledStatus(),
  );

  SnackbarNotifier? snackbarNotifier;

  final fullName = ''.obs;
  final email = ''.obs;
  final number = ''.obs;
  final gender = ''.obs;
  final address = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;

  void setFullName(String value) {
    fullName.value = value;
    processNotifier.setEnabled();
  }

  void setEmail(String value) {
    email.value = value;
    processNotifier.setEnabled();
  }

  void setNumber(String value) {
    number.value = value;
    processNotifier.setEnabled();
  }

  void setPassword(String value) {
    password.value = value;
    processNotifier.setEnabled();
  }

  void setConfirmPassword(String value) {
    confirmPassword.value = value;
    processNotifier.setEnabled();
  }

  // --- Build request model ---
  SignupRequestParam get signupModel => SignupRequestParam(
    fullName: fullName.value,
    email: email.value,
    number: number.value,
    address: address.value,
    password: password.value,
    confirmPassword: confirmPassword.value,
  );

  // --- Signup method ---
  Future<void> signup({
  ProcessStatusNotifier? buttonNotifier,
  SnackbarNotifier? snackbarNotifier,
  VoidCallback? onDone,
}) async {
  buttonNotifier?.setLoading();
  final result = await Get.find<AuthRepo>().signup(signupModel);

  handleFold(
    either: result,
    errorSnackbarNotifier: snackbarNotifier,
    successSnackbarNotifier: snackbarNotifier,
    onError: (failure) {
      buttonNotifier?.setError();
      snackbarNotifier?.notifyError(message: failure.uiMessage);
    },
    onSuccess: (success) {
      buttonNotifier?.setSuccess();

      // Navigate to OTP screen if needed
      Get.to(() => OtpCodeView(email: email.value,));
      snackbarNotifier?.notifySuccess(message: success.message);
      onDone?.call();
    },
  );
}

}
