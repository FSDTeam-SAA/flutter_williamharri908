// import 'package:get/get.dart';
// import 'package:williamharri/src/module/assignment/repo/submit_repo.dart';

// class MyJobManegerController extends GetxController {
//   MyJobManegerController({required this.submitRepo});

//   final SubmitRepo submitRepo;

//   RxList<usemodelhere> jobs = <usemodelhere>[].obs;
//   RxBool isLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchJobs();
//   }

//   Future<void> fetchJobs() async {
//     isLoading.value = true;

//     final result = await submitRepo.myJobsManager();

//     result.fold(
//       (failure) {
//         isLoading.value = false;
//         Get.snackbar("Error", failure.uiMessage);
//       },
//       (success) {
//         isLoading.value = false;
//         jobs.value = success;
//       },
//     );

//     isLoading.value = false;
//   }
// }

import 'package:get/get.dart';
import 'package:williamharri/src/module/assignment/model/my_jobs_manager_model.dart';
import 'package:williamharri/src/module/assignment/repo/application_repo.dart';

class MyJobManagerController extends GetxController {
  final ApplicationRepo submitRepo;

  MyJobManagerController({required this.submitRepo});

  RxList<JobModelManager> jobs = <JobModelManager>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    isLoading.value = true;

    final result = await submitRepo.myJobsManager();

    result.fold(
      (failure) {
        isLoading.value = false;
        Get.snackbar("Error", failure.uiMessage);
      },
      (success) {
        jobs.value = success;
        isLoading.value = false;
      },
    );
  }
}
