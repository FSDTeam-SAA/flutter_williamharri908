import 'package:get/get.dart';
import 'package:williamharri/src/core/base/reactive_ui/process_notifier.dart';
import 'package:williamharri/src/core/notifiers/snackbar_notifier.dart';
import 'package:williamharri/src/core/utils/utils.dart';
import 'package:williamharri/src/module/auth/model/forget_password_model.dart';
import 'package:williamharri/src/module/auth/repo/auth_repo.dart';
import 'package:williamharri/src/module/auth/ui/view/reset_otp-code_view.dart';

class ForgetPasswordController extends GetxController {
  final AuthRepo authRepo = Get.find<AuthRepo>();
  final ProcessStatusNotifier processNotifier = ProcessStatusNotifier(
    initialStatus: DisabledStatus(),
  );
  final SnackbarNotifier snackbarNotifier;

  ForgetPasswordController({required this.snackbarNotifier});

  String _email = '';
  String get email => _email;

  set email(String value) {
    _email = value.trim();
    if (_email.isNotEmpty) {
      processNotifier.setEnabled();
    } else {
      processNotifier.setDisabled();
    }
  }

  Future<void> sendOtp() async {
    if (_email.isEmpty) {
      // snackbarNotifier.showError("Please enter email");
      return;
    }

    if (processNotifier.status is LoadingStatus) return;

    processNotifier.setLoading();

    final result = await authRepo.forgetpassword(
      ForgetPasswordModel(email: _email),
    );

    handleFold(
      either: result,
      processStatusNotifier: processNotifier,
      successSnackbarNotifier: snackbarNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      onSuccess: (_) {
        // snackbarNotifier.showSuccess("OTP sent to your email");
        Get.to(() => ResetOtpCodeView(email: _email));
      },
    );
  }
}
