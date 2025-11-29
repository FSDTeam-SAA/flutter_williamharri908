import 'package:get/get.dart';
import 'package:williamharri/src/core/notifiers/snackbar_notifier.dart';
import 'package:williamharri/src/module/assignment/controller/rams_document_controller.dart';
import 'package:williamharri/src/module/assignment/repo/application_repo.dart';
import 'package:williamharri/src/module/assignment/repo/application_repo_impl.dart';
import 'package:williamharri/src/module/auth/repo/auth_repo.dart';
import 'package:williamharri/src/module/auth/repo/auth_repo_impl.dart';
import 'package:williamharri/src/module/home/controller/job_controller.dart';
import 'package:williamharri/src/module/home/controller/staff_all_jobs.controller.dart';
import 'package:williamharri/src/module/home/repo/job_repo.dart';
import 'package:williamharri/src/module/home/repo/job_repo_impl.dart';
import 'package:williamharri/src/module/profile/controller/get_profile_controller.dart';
import 'package:williamharri/src/module/profile/controller/staff_list_controller.dart';
import 'package:williamharri/src/module/profile/repo/profile_repo.dart';
import 'package:williamharri/src/module/profile/repo/profile_repo_impl.dart';
import 'package:williamharri/app/app_manager.dart';

void initInterfaces() {
  // Auth Repo
  Get.lazyPut<AuthRepo>(() => AuthRepoImpl(appPigeon: Get.find()), fenix: true);

  // Profile Repo & Controller
  Get.lazyPut<ProfileRepo>(
    () => ProfileRepoImpl(appPigeon: Get.find()),
    fenix: true,
  );
  Get.lazyPut<ProfileController>(
    () => ProfileController(repo: Get.find()),
    fenix: true,
  );

  // SnackbarNotifier
  Get.put<SnackbarNotifier>(SnackbarNotifier(), permanent: true);

  // App Manager
  Get.put<AppManager>(AppManager(), permanent: true);

  Get.lazyPut<JobRepo>(() => JobRepoImpl(appPigeon: Get.find()), fenix: true);

  Get.lazyPut<JobController>(
    () => JobController(jobRepo: Get.find()),
    fenix: true,
  );
  Get.lazyPut<StaffJobController>(
    () => StaffJobController(jobRepo: Get.find()),
    fenix: true,
  );
  Get.lazyPut(() => StaffController(repo: Get.find()));

  Get.lazyPut<ApplicationRepo>(
    () => ApplicationRepoImpl(appPigeon: Get.find()),
    fenix: true,
  );
  Get.lazyPut<RamsDocumentController>(
    () => RamsDocumentController(repo: Get.find<ApplicationRepo>()),
    fenix: true,
  );
}
