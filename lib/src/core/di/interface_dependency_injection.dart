import 'package:get/get.dart';
import 'package:williamharri/src/core/notifiers/snackbar_notifier.dart';
import 'package:williamharri/src/module/auth/repo/auth_repo.dart';
import 'package:williamharri/src/module/auth/repo/auth_repo_impl.dart';
import 'package:williamharri/src/module/profile/controller/get_profile_controller.dart';
import 'package:williamharri/src/module/profile/repo/profile_repo.dart';
import 'package:williamharri/src/module/profile/repo/profile_repo_impl.dart';
import 'package:williamharri/app/app_manager.dart';

// void initInterfaces() {
//   // Auth Repo
//   Get.lazyPut<AuthRepo>(() => AuthRepoImpl(appPigeon: Get.find()), fenix: true);

//   Get.lazyPut<ProfileRepo>(
//     () => ProfileRepoImpl(appPigeon: Get.find()),
//     fenix: true,
//   );
//   Get.lazyPut<ProfileController>(
//     () => ProfileController(repo: Get.find()),
//     fenix: true,
//   );
  
//   Get.put<AppManager>(AppManager(), permanent: true);
// }

void initInterfaces() {
  // Auth Repo
  Get.lazyPut<AuthRepo>(() => AuthRepoImpl(appPigeon: Get.find()), fenix: true);

  // Profile Repo & Controller
  Get.lazyPut<ProfileRepo>(() => ProfileRepoImpl(appPigeon: Get.find()), fenix: true);
  Get.lazyPut<ProfileController>(() => ProfileController(repo: Get.find()), fenix: true);

  // SnackbarNotifier
  Get.put<SnackbarNotifier>(SnackbarNotifier(), permanent: true);

  // App Manager
  Get.put<AppManager>(AppManager(), permanent: true);
}
