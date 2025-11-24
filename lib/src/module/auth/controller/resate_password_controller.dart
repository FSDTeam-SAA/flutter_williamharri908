// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:williamharri/src/core/base/reactive_ui/process_notifier.dart';
// import 'package:williamharri/src/core/notifiers/snackbar_notifier.dart';
// import 'package:williamharri/src/core/utils/utils.dart';
// import 'package:williamharri/src/module/auth/model/resate_password_model.dart';
// import 'package:williamharri/src/module/auth/repo/auth_repo.dart';

// class CreateNewPasswordController extends GetxController {
//   final String email;
//   final String otp;
//   CreateNewPasswordController({required this.email, required this.otp});
//   final ProcessStatusNotifier processNotifier = ProcessStatusNotifier(
//     initialStatus: DisabledStatus()
//   );

//   String _newPassword = '';
//   String get newPassword => _newPassword;
//   set newPassword(String value) {
//     _newPassword = value;
//     debugPrint("New Password: $_newPassword");
//     debugPrint("Confirm Password: $_confirmPassword");

//   }

//   String _confirmPassword = '';
//   String get confirmPassword => _confirmPassword;
//   set confirmPassword(String value) {
//     _confirmPassword = value;
//     debugPrint("Confirm Password: $_confirmPassword");
//     debugPrint("New Password: $_newPassword");

//   }


//   void resetPassword(SnackbarNotifier? snackbarNotifier) async {
//     if (matchOk.value) {
//       processNotifier.setEnabled();
//     } else {
//       processNotifier.setDisabled();
//     }

//     await Get.find<AuthRepo>()
//         .createNewPassword(
//           ResatePasswordModel(
//             email: email,
//             password: newPassword,
//             otp: otp,
//           ),
//         )
//         .then((lr) {
//           handleFold(
//             either: lr,
//             processStatusNotifier: processNotifier,
//             successSnackbarNotifier: snackbarNotifier,
//             errorSnackbarNotifier: snackbarNotifier,
//           );
//         });
//   }
// }
