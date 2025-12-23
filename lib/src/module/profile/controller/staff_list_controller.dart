import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/module/profile/repo/profile_repo.dart';
import 'package:williamharri/src/module/profile/model/profile_model.dart';

class StaffController extends GetxController {
  StaffController({required this.repo});

  final ProfileRepo repo;

  RxBool isLoading = false.obs;
  RxList<ProfileModel> staffList = <ProfileModel>[].obs;
  Rx<ProfileModel?> selectedStaff = Rx<ProfileModel?>(null);

  @override
  void onInit() {
    fetchStaff();
    super.onInit();
  }

  Future<void> fetchStaff() async {
    isLoading.value = true;

    final result = await repo.staffList();

    result.fold(
      (failure) {
        isLoading.value = false;
        debugPrint("Error loading staff list: $failure");
      },
      (success) {
        staffList.assignAll(success.data ?? []);
        isLoading.value = false;
      },
    );
  }

  void selectStaff(ProfileModel? staff) {
    selectedStaff.value = staff;
  }
}
