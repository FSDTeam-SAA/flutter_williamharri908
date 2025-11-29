import 'dart:io';
import 'package:get/get.dart';
import 'package:williamharri/src/core/constants/api_endpoints.dart';

import '../../../core/services/app_pigeon/app_pigeon.dart';
import '../model/profile_model.dart';

class ProfileEditController extends GetxController {
  final AppPigeon appPigeon;
  ProfileEditController({required this.appPigeon});

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

    try {
      isLoading.value = true;

      // 2. Prepare payload for server
      final payload = {
        "name": profile.value!.name,
        "phone": profile.value!.phone,
        "address": profile.value!.address,
        "nationality": profile.value!.nationality,
        // avatar handled separately if needed
      };

      // 3. Server call using AppPigeon
      final response = await appPigeon.patch(
        ApiEndpoints.updateUser, // <-- শুধুমাত্র /users/me
        data: payload,
      );

      // 4. Check response & update local profile
      if (response.data != null && response.data["data"] != null) {
        profile.value = ProfileModel.fromMap(response.data["data"]);
        Get.snackbar("Success", "Profile updated successfully");
      } else {
        Get.snackbar("Error", "Profile update failed");
      }
    } catch (e) {
      print("Profile update error: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
