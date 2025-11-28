import 'package:get/get.dart';
import 'package:williamharri/src/module/home/model/job_cart_model.dart';
import 'package:williamharri/src/module/home/repo/job_repo.dart';

class JobController extends GetxController {
  JobController({required this.jobRepo});

  final JobRepo jobRepo;

  RxList<JobModel> jobs = <JobModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    isLoading.value = true;

    final result = await jobRepo.getJobs();

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
