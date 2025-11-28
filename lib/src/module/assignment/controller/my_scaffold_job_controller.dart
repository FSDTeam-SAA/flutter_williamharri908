import 'package:get/get.dart';
import 'package:williamharri/src/module/assignment/repo/submit_repo.dart';
import 'package:williamharri/src/module/home/model/job_cart_model.dart';

class MyScaffoldJobController extends GetxController {
  MyScaffoldJobController({required this.submitRepo});

  final SubmitRepo submitRepo;

  RxList<JobModel> jobs = <JobModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    isLoading.value = true;

    final result = await submitRepo.myScaffoldList();

    result.fold(
      (failure) {
        isLoading.value = false;
        Get.snackbar("Error", failure.uiMessage);
      },
      (success) {
        isLoading.value = false;
        jobs.value = success;
      },
    );

    isLoading.value = false;
  }
}