import 'package:flutter/material.dart';
import 'package:williamharri/src/core/api_handler/request.dart';
import 'package:williamharri/src/core/api_handler/success.dart';
import 'package:williamharri/src/core/constants/api_endpoints.dart';
import 'package:williamharri/src/core/services/app_pigeon/app_pigeon.dart';
import 'package:williamharri/src/module/auth/model/change_password_model.dart';
import 'package:williamharri/src/module/auth/model/resate_password_model.dart';
import 'package:williamharri/src/module/auth/model/forget_password_model.dart';
import 'package:williamharri/src/module/auth/model/login_request_params.dart';
import 'package:williamharri/src/module/auth/model/signup_model.dart';
import 'package:williamharri/src/module/auth/model/verify_otp_param.dart';
import 'package:williamharri/src/module/auth/repo/auth_repo.dart';

final class AuthRepoImpl extends AuthRepo {
  final AppPigeon appPigeon;
  AuthRepoImpl({required this.appPigeon});

  @override
  FutureRequest<Success> login(LoginRequestParams params) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.login,
          data: params.toJson(),
        );
        final body = response.data;
        final loginResponse = LoginResponse.fromMap(body);
        await appPigeon.saveNewAuth(
          saveAuthParams: SaveNewAuthParams(
            uid: loginResponse.userId,
            accessToken: loginResponse.accessToken,
            refreshToken: loginResponse.refreshToken,
            data: {
              "userId": loginResponse.userId,
              "name": loginResponse.user.name,
              "email": loginResponse.user.email,
              "role": loginResponse.role,
            },
          ),
        );

        return Success(message: body['message'] ?? 'Login successful');
      },
    );
  }

  @override
  FutureRequest<Success> signup(SignupRequestParam signupModel) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.signup,
          data: signupModel.toJson(),
        );
        final body = response.data;
        final signupResponse = SignupResponse.fromMap(body);
        await appPigeon.saveNewAuth(
          saveAuthParams: SaveNewAuthParams(
            uid: signupResponse.userId,
            accessToken: signupResponse.accessToken,
            refreshToken: signupResponse.refreshToken,
            data: {
              "userId": signupResponse.userId,
              "name": signupResponse.user.name,
              "email": signupResponse.user.email,
              "role": signupResponse.role,
            },
          ),
        );

        return Success(message: body['message'] ?? 'Signup successful');
      },
    );
  }

  @override
  FutureRequest<Success> logout() async {
    return await asyncTryCatch(
      tryFunc: () async {
        await appPigeon.logOut();
        return Success(message: 'Logout successfully');
      },
    );
  }

  @override
  FutureRequest<Success> createNewPassword(ResatePasswordModel param) async {
    return await asyncTryCatch(
      tryFunc: () async {
        debugPrint("createNewPassword: ${param.toJson()}");
        final response = await appPigeon.post(
          ApiEndpoints.createNewPassword,
          data: param.toJson(),
        );
        return Success(message: extractSuccessMessage(response));
      },
    );
  }

  @override
  FutureRequest<Success> forgetpassword(ForgetPasswordModel param) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.forgetPassword,
          data: param.toJson(),
        );
        return Success(message: extractSuccessMessage(response));
      },
    );
  }

  @override
  FutureRequest<Success> verifyAccount(VerifyOtpParam param) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.emailverify,
          data: param.toJson(),
        );
        final body = response.data;
        return Success(message: body['message'] ?? 'Verification successful');
      },
    );
  }

  @override
  FutureRequest<Success> verifyCode(VerifyOtpParam param) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.verifyCode, // your backend route
          data: param.toJson(),
        );
        final body = response.data;
        return Success(message: body['message'] ?? 'Code verified');
      },
    );
  }
  
  @override
  FutureRequest<Success> changePassword(ChangePasswordModel param) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.changePassword, // your backend route
          data: param.toJson(),
        );
        final body = response.data;
        return Success(message: body['message'] ?? 'Password changed');
      },
    );
  }




  
}
