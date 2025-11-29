import 'package:williamharri/src/core/api_handler/base_repository.dart';
import 'package:williamharri/src/core/api_handler/request.dart';
import 'package:williamharri/src/core/api_handler/success.dart';
import 'package:williamharri/src/module/profile/model/profile_model.dart';
import 'package:williamharri/src/module/profile/model/update_profile_req_param.dart';

abstract base class ProfileRepo extends BaseRepository{
  FutureRequest<Success<ProfileModel>> getProfile(String id);

  FutureRequest<Success> logout();

  FutureRequest<Success<List<ProfileModel>>> staffList();
  FutureRequest<Success<ProfileModel>> updateProfile(UpdateProfileReqParam param);

}