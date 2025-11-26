import 'package:flutter/rendering.dart';
import 'package:williamharri/src/core/base/api_handler/request.dart';
import 'package:williamharri/src/core/base/api_handler/success.dart';
import 'package:williamharri/src/core/constants/api_endpoints.dart';
import 'package:williamharri/src/core/services/app_pigeon/app_pigeon.dart';
import 'package:williamharri/src/module/profile/model/profile_model.dart';
import 'package:williamharri/src/module/profile/repo/profile_repo.dart';

final class ProfileRepoImpl extends ProfileRepo {
  ProfileRepoImpl({required this.appPigeon});
  final AppPigeon appPigeon;

  @override
  FutureRequest<Success<ProfileModel>> getProfile(String id) async {
    return await asyncTryCatch(
      tryFunc: () async {
        debugPrint("FETCHING PROFILE FOR USER ID: $id");

        final response = await appPigeon.get(ApiEndpoints.getuserbyId(id));

        debugPrint("RAW RESPONSE: ${response.data}");

        if (response.data == null || response.data["data"] == null) {
          throw Exception("No data in response");
        }

        final data = response.data["data"] as Map<String, dynamic>;
        debugPrint("PARSED DATA MAP: $data");

        final ProfileModel profileModel = ProfileModel.fromMap(data);
        final message = response.data["message"]?.toString() ?? "Success";

        debugPrint(
          "PROFILE MODEL CREATED: ${profileModel.username} (${profileModel.email})",
        );

        return Success(data: profileModel, message: message);
      },
    );
  }
  
  @override
  FutureRequest<Success> logout() async {
    return await asyncTryCatch(
      tryFunc: () async {
        await appPigeon.logOut();
        return Success(message: "Logout Successfull");
      },
    );
  }
}
