import 'package:williamharri/src/core/base/api_handler/base_repository.dart';
import 'package:williamharri/src/core/base/api_handler/success.dart';
import 'package:williamharri/src/core/utils/utils.dart';
import 'package:williamharri/src/module/auth/model/change_password_model.dart';
import 'package:williamharri/src/module/auth/model/resate_password_model.dart';
import 'package:williamharri/src/module/auth/model/forget_password_model.dart';
import 'package:williamharri/src/module/auth/model/login_request_params.dart';
import 'package:williamharri/src/module/auth/model/signup_model.dart';
import 'package:williamharri/src/module/auth/model/verify_otp_param.dart';

abstract base class AuthRepo extends BaseRepository {

  FutureRequest<Success> signup(SignupRequestParam signupModel);
  
  FutureRequest<Success> logout();

  FutureRequest<Success> login(LoginRequestParams params);

  FutureRequest<Success> verifyAccount(VerifyOtpParam param);

  FutureRequest<Success> verifyCode(VerifyOtpParam param);

  FutureRequest<Success> forgetpassword(ForgetPasswordModel param);

  FutureRequest<Success> createNewPassword(ResatePasswordModel param);

  FutureRequest<Success> changePassword(ChangePasswordModel param);
  
}
