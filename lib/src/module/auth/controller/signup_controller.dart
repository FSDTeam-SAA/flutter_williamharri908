
import 'package:get/get.dart';

import '../../../core/base/reactive_ui/process_notifier.dart';
import '../../../core/notifiers/snackbar_notifier.dart';

class SignupController extends GetxController{
  String email = "";
  String password = "";
  String name = "";
  String confirmPassword = "";
  
  final ProcessStatusNotifier stn = ProcessStatusNotifier(
    initialStatus: EnabledStatus()
  );

  void setEmail(String email) {
    this.email = email;
    update();
  }

  void setName(String name) {
    this.name = name;
    update();
  }

  void setPassword(String password) {
    this.password = password;
    update();
  }

  void setConfirmPassword(String confirmPassword) {
    this.confirmPassword = confirmPassword;
    update();
  }

  Future<void> signup(SnackbarNotifier? snackbarNotifier) async {
    stn.setLoading();
    snackbarNotifier?.notify(
      message: "Signing up",
    );

    Future.delayed(Duration(seconds: 2), () {
      stn.setError();
      snackbarNotifier?.notifyError(
        message: "Sign up failed!!",
      );
    });
  }
}