import 'package:get/get.dart';
import 'package:williamharri/src/core/base/reactive_ui/process_notifier.dart';
import 'package:williamharri/src/core/notifiers/snackbar_notifier.dart';
import 'package:williamharri/src/core/utils/utils.dart';
import 'package:williamharri/src/module/auth/model/resate_password_model.dart';
import 'package:williamharri/src/module/auth/repo/auth_repo.dart';

class CreateNewPasswordController extends GetxController {
  final String email;
  final String otp;

  CreateNewPasswordController({
    required this.email,
    required this.otp,
  });

  final processNotifier =
      ProcessStatusNotifier(initialStatus: DisabledStatus());

  String _newPassword = "";
  String _confirmPassword = "";

  bool get matchOk =>
      _newPassword.isNotEmpty &&
      _confirmPassword.isNotEmpty &&
      _newPassword == _confirmPassword;

  set newPassword(String value) {
    _newPassword = value.trim();
  }

  set confirmPassword(String value) {
    _confirmPassword = value.trim();
  }

  void validatePasswords() {
    if (matchOk) {
      processNotifier.setEnabled();
    } else {
      processNotifier.setDisabled();
    }
  }

  Future<void> resetPassword(SnackbarNotifier snackbarNotifier) async {
    if (!matchOk) {
      // snackbarNotifier.showError("Passwords do not match!");
      return;
    }

    processNotifier.setLoading();

    final result = await Get.find<AuthRepo>().createNewPassword(
      ResatePasswordModel(
        email: email,
        password: _newPassword,
        otp: otp,
      ),
    );

    handleFold(
      either: result,
      processStatusNotifier: processNotifier,
      successSnackbarNotifier: snackbarNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      onSuccess: (_) {},
    );
  }
}
