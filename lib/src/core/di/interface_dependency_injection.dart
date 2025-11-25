// import 'package:get/get.dart';
// import 'package:williamharri/src/module/auth/repo/auth_repo.dart';
// import 'package:williamharri/src/module/auth/repo/auth_repo_impl.dart';
// import 'package:williamharri/src/module/profile/controller/get_profile_controller.dart';
// import 'package:williamharri/src/module/profile/repo/profile_repo.dart';
// import 'package:williamharri/src/module/profile/repo/profile_repo_impl.dart';

// void initInterfaces() {
//   // Initialize other interfaces here
//   Get.put<AuthRepo>(AuthRepoImpl(appPigeon: Get.find()));
//   Get.lazyPut<ProfileRepo>(() => ProfileRepoImpl(appPigeon: Get.find()));
//   Get.lazyPut(() => ProfileController(repo: Get.find()));
  
// }


// src/core/di/interface_dependency_injection.dart
import 'package:get/get.dart';
import 'package:williamharri/src/module/auth/repo/auth_repo.dart';
import 'package:williamharri/src/module/auth/repo/auth_repo_impl.dart';
import 'package:williamharri/src/module/profile/controller/get_profile_controller.dart';
import 'package:williamharri/src/module/profile/repo/profile_repo.dart';
import 'package:williamharri/src/module/profile/repo/profile_repo_impl.dart';
import 'package:williamharri/app/app_manager.dart';

void initInterfaces() {
  // Auth Repo
  Get.lazyPut<AuthRepo>(() => AuthRepoImpl(appPigeon: Get.find()), fenix: true);

  // Profile Repo
  Get.lazyPut<ProfileRepo>(
    () => ProfileRepoImpl(appPigeon: Get.find()),
    fenix: true,
  );

  // Profile Controller – will be recreated on every tab switch (perfect for bottom nav)
  Get.lazyPut<ProfileController>(
    () => ProfileController(repo: Get.find()),
    fenix: true,
  );

  // AppManager – MUST be permanent (only one instance in whole app)
  Get.put<AppManager>(AppManager(), permanent: true);
}