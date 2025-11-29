import 'dart:io';
import 'package:get/get.dart';
import 'package:williamharri/src/core/component/reactive_ui/process_notifier.dart';
import 'package:williamharri/src/core/notifiers/snackbar_notifier.dart';
import 'package:williamharri/src/core/utils/helpers/handle_fold.dart';
import 'package:williamharri/src/module/profile/model/update_profile_req_param.dart';
import 'package:williamharri/src/module/profile/repo/profile_repo.dart';

import '../model/profile_model.dart';

class ProfileEditController extends GetxController {
  ProfileEditController();

  ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier(
    initialStatus: EnabledStatus(),
  );

  // Reactive variables
  var profile = Rx<ProfileModel?>(null);
  var pickedImage = Rx<File?>(null);
  var isLoading = false.obs;

  /// Initialize profile
  void setProfile(ProfileModel newProfile) {
    profile.value = newProfile;
  }

  /// Pick image locally
  void pickImage(File image) {
    pickedImage.value = image;
  }

  /// Update profile locally & on server
  Future<void> updateProfile({
    String? name,
    String? phone,
    String? address,
    String? nationality,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    if (profile.value == null) return;

    // 1. Update local copy
    profile.update((val) {
      val?.name = name ?? val.name;
      val?.phone = phone ?? val.phone;
      val?.address = address ?? val.address;
      val?.nationality = nationality ?? val.nationality;
      if (pickedImage.value != null)
        val?.avatarUrl = null; // local update for picked image
    });
    processStatusNotifier.setLoading();
    final lr = await Get.find<ProfileRepo>().updateProfile(
      UpdateProfileReqParam(
        name: name ?? profile.value!.name,
        phone: phone ?? profile.value!.phone,
        address: address ?? profile.value!.address,
        nationality: nationality ?? profile.value!.nationality,
        avatar: pickedImage.value,
      ),
    );

    handleFold(
      either: lr,
      successSnackbarNotifier: snackbarNotifier,
      errorSnackbarNotifier: snackbarNotifier,
      processStatusNotifier: processStatusNotifier,
    );
    processStatusNotifier.setEnabled();
    
  }
}
