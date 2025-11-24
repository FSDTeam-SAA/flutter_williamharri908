import 'package:get/get.dart';
import 'package:williamharri/src/module/auth/repo/auth_repo.dart';
import 'package:williamharri/src/module/auth/repo/auth_repo_impl.dart';

void initInterfaces() {
  // Initialize other interfaces here
  Get.put<AuthRepo>(AuthRepoImpl(appPigeon: Get.find()));
}
