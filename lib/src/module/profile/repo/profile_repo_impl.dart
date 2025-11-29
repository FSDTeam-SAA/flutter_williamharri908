import 'package:flutter/rendering.dart';
import 'package:williamharri/src/core/api_handler/request.dart';
import 'package:williamharri/src/core/api_handler/success.dart';
import 'package:williamharri/src/core/constants/api_endpoints.dart';
import 'package:williamharri/src/core/services/app_pigeon/app_pigeon.dart';
import 'package:williamharri/src/module/profile/model/profile_model.dart';
import 'package:williamharri/src/module/profile/repo/profile_repo.dart';

import '../model/update_profile_req_param.dart';

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

  @override
  FutureRequest<Success<List<ProfileModel>>> staffList() async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.get(ApiEndpoints.staffList);

        final list = (response.data["data"]["results"] as List)
            .map((e) => ProfileModel.fromMap(e))
            .toList();

        return Success<List<ProfileModel>>(
          data: list,
          message: response.data["message"] ?? "Success",
        );
      },
    );
  }

  @override
  FutureRequest<Success<ProfileModel>> updateProfile(
    UpdateProfileReqParam param,
  ) async {
    return await asyncTryCatch(
      tryFunc: () async {
        // First updates the profile
        final response = await appPigeon.patch(
          ApiEndpoints.updateUser,
          data: param.toUpdateProfileDetailsData(),
        );
        // Then updates the avatar, if avatar file is not null
        if (param.avatar != null) {
          final response2 = await appPigeon.patch(
            ApiEndpoints.uploadProfileImage,
            data: await param.toUpdateAvatarData(),
          );
        }

        final updatedData = response.data["data"] as Map<String, dynamic>;
        final updatedProfile = ProfileModel.fromMap(updatedData);

        return Success<ProfileModel>(
          data: updatedProfile,
          message: extractSuccessMessage(response) ?? "Profile is updated!",
        );
      },
    );
  }
}
