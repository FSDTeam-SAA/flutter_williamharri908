// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:williamharri/src/core/base/reactive_ui/process_notifier.dart';
// import 'package:williamharri/src/core/notifiers/snackbar_notifier.dart';
// import 'package:williamharri/src/core/utils/utils.dart';
// import 'package:williamharri/src/module/auth/model/change_password_model.dart';
// import 'package:williamharri/src/module/auth/repo/auth_repo.dart';

// class ChangePasswordController extends ChangeNotifier {
//   final ProcessStatusNotifier processNotifier = ProcessStatusNotifier();
//   final SnackbarNotifier snackbarNotifier;

//   ChangePasswordController(this.snackbarNotifier);

//   String _currentPassword = '';
//   String _newPassword = '';
//   String _confirmPassword = '';

//   String get password => _currentPassword;
//   String get newPassword => _newPassword;
//   String get confirmPassword => _confirmPassword;

//   set currentPassword(String value) {
//     if (value != _currentPassword) {
//       _currentPassword = value;
//       _validateForm();
//     }
//   }

//   set newPassword(String value) {
//     if (value != _newPassword) {
//       _newPassword = value;
//       _validateForm();
//     }
//   }

//   set confirmPassword(String value) {
//     if (value != _confirmPassword) {
//       _confirmPassword = value;
//       _validateForm();
//     }
//   }

//   /// Validate fields before enabling Save button
//   void _validateForm() {
//     if (_currentPassword.isNotEmpty &&
//         _newPassword.isNotEmpty &&
//         _newPassword.length >= 6 &&
//         _confirmPassword.isNotEmpty &&
//         _newPassword == _confirmPassword) {
//       processNotifier.setEnabled();
//     } else {
//       processNotifier.setDisabled();
//     }
//     notifyListeners();
//   }

//   Future<void> changePassword({
//     required SnackbarNotifier? snackbarNotifier,
//   }) async {
//     processNotifier.setLoading();

//     await Future.delayed(const Duration(milliseconds: 300));

//     final result = await Get.find<AuthRepo>().changePassword(
//       ChangePasswordModel(
//         oldPassword: _currentPassword,
//         newPassword: _newPassword,
//       ),
//     );

//     handleFold(
//       either: result,
//       processStatusNotifier: processNotifier,
//       successSnackbarNotifier: snackbarNotifier,
//     );
//   }
// }


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
        // snackbarNotifier.showError(message: failure.uiMessage);
      },
      (success) {
        processNotifier.setSuccess(message: success.message);
        // snackbarNotifier.showSuccess(message: success.message);

        Future.delayed(const Duration(milliseconds: 600), () {
          Get.back(); // go back after success
        });
      },
    );
  }
}
 