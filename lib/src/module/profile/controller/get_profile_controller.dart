import 'package:get/get.dart';
import 'package:williamharri/app/app_manager.dart';
import 'package:williamharri/src/core/services/app_pigeon/app_pigeon.dart';
import 'package:williamharri/src/core/utils/utils.dart';
import 'package:williamharri/src/module/profile/repo/profile_repo.dart';
import 'package:williamharri/src/module/profile/model/profile_model.dart';

class ProfileController extends GetxController {
  ProfileController({required this.repo});

  final ProfileRepo repo;

  Rxn<ProfileModel> profile = Rxn<ProfileModel>();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentUserProfile();
  }

  Future<void> getCurrentUserProfile() async {
    final app = Get.find<AppManager>();

    if (app.currentAuthStatus is Authenticated) {
      final auth = app.currentAuthStatus as Authenticated;

      final userId = auth.auth.userId;

      final result = await repo.getProfile(userId);

      result.fold(
        (failure) => print("Error: $failure"),
        (success) {
          profile.value = success.data;
          print("PROFILE LOADED: ${profile.value?.name}");
        },
      );
    }
  }
}
