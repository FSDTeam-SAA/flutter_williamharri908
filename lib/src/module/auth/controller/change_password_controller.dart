import 'package:get/get.dart';
import 'package:williamharri/src/core/component/reactive_ui/process_notifier.dart';
import 'package:williamharri/src/core/notifiers/snackbar_notifier.dart';
import 'package:williamharri/src/module/auth/model/change_password_model.dart';
import 'package:williamharri/src/module/auth/repo/auth_repo.dart';

class ChangePasswordController extends GetxController {
  final ProcessStatusNotifier processNotifier = ProcessStatusNotifier();
  final SnackbarNotifier snackbarNotifier;
  

  ChangePasswordController(this.snackbarNotifier);

  String _oldPass = '';
  String _newPass = '';
  String _confirmPass = '';

  set currentPassword(String value) {
    _oldPass = value;
    _validate();
  }

  set newPassword(String value) {
    _newPass = value;
    _validate();
  }

  set confirmPassword(String value) {
    _confirmPass = value;
    _validate();
  }

  void _validate() {
    if (_oldPass.isNotEmpty &&
        _newPass.isNotEmpty &&
        _newPass.length >= 6 &&
        _confirmPass == _newPass) {
      processNotifier.setEnabled();
    } else {
      processNotifier.setDisabled();
    }
  }

  Future<void> changePassword() async {
    processNotifier.setLoading();

    final param = ChangePasswordModel(
      oldPassword: _oldPass,
      newPassword: _newPass,
    );

    final result = await Get.find<AuthRepo>().changePassword(param);

    result.fold(
      (failure) {
        processNotifier.setError();
        snackbarNotifier.notifyError(message: failure.uiMessage);
      },
      (success) {
        processNotifier.setSuccess(message: success.message);
        snackbarNotifier.notifySuccess(message: success.message);

        Future.delayed(const Duration(milliseconds: 600), () {
          Get.back();
        });
      },
    );
  }
}
 