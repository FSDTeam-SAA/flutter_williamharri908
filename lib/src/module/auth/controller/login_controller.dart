import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/core/base/reactive_ui/process_notifier.dart';
import 'package:williamharri/src/core/notifiers/snackbar_notifier.dart';
import 'package:williamharri/src/core/routing/route_names.dart';
import 'package:williamharri/src/core/utils/helpers/validation.dart';
import 'package:williamharri/src/module/auth/model/login_request_params.dart';
import 'package:williamharri/src/module/auth/repo/auth_repo.dart';

class LoginController extends GetxController {
  // UI Notifiers
  final ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier(
    initialStatus: DisabledStatus(),
  );
  final SnackbarNotifier snackbarNotifier;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final keepSignedIn = false.obs;
  final isLoading = false.obs;

  String _email = '';
  String get email => _email;

  String _password = '';
  String get password => _password;

  LoginController(this.snackbarNotifier);

  /// ← This is where onInit goes
  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() => email = emailController.text.trim());
    passwordController.addListener(
      () => password = passwordController.text.trim(),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  set email(String value) {
    if (value != _email) {
      _email = value;
      canLogin();
    }
  }

  set password(String value) {
    if (value != _password) {
      _password = value;
      canLogin();
    }
  }

  void canLogin() {
    if (_email.isNotEmpty && isValidEmail(_email) && _password.isNotEmpty) {
      processStatusNotifier.setEnabled();
    } else {
      processStatusNotifier.setDisabled();
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleKeepSignedIn(bool value) {
    keepSignedIn.value = value;
  }

  Future<void> login({required VoidCallback needVerifyAccount}) async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    processStatusNotifier.setLoading();

    try {
      final lr = await Get.find<AuthRepo>().login(
        LoginRequestParams(email: email, password: password),
      );

      lr.fold(
        (error) {
          // Handle errors
          processStatusNotifier.setError();
          snackbarNotifier.notifyError(message: error.uiMessage);
          isLoading.value = false;
        },
        (success) {
          // Handle success
          processStatusNotifier.setSuccess(message: success.message);
          // Navigate to dashboard/home
          Get.offAllNamed(RouteNames.appground);
        },
      );
    } finally {
      isLoading.value = false;
    }
  }
}
