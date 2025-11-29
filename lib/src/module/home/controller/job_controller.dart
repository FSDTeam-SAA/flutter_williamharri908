import 'package:get/get.dart';
import 'package:williamharri/src/module/home/model/job_cart_model.dart';
import 'package:williamharri/src/module/home/repo/job_repo.dart';
import 'package:williamharri/src/module/home/model/create_job_model.dart';

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


  Future<void> deleteJob(String id) async {
    isLoading.value = true;

    final result = await jobRepo.deleteJob(id);

    result.fold(
          (failure) {
        isLoading.value = false;
        Get.snackbar('Error', failure.uiMessage);
      },
          (_) {
        isLoading.value = false;

        // keep list in sync (adjust field name if not `id`)
        jobs.removeWhere((j) => j.id == id);

        // close JobDetails screen
        if (Get.isOverlaysOpen || Get.key.currentState?.canPop() == true) {
          Get.back();
        }

        Get.snackbar('Success', 'Job deleted');
      },
    );
  }


  /// PATCH /jobs/{id}
  Future<void> updateJob(String id, CreateJobModel data) async {
    isLoading.value = true;

    final result = await jobRepo.updateJob(id, data);

    result.fold(
          (failure) {
        isLoading.value = false;
        Get.snackbar('Error', failure.uiMessage);
      },
          (updatedJob) {
        isLoading.value = false;

        // update item in list
        final index = jobs.indexWhere((j) => j.id == updatedJob.id);
        if (index != -1) {
          jobs[index] = updatedJob;
          jobs.refresh();
        }

        // close edit screen
        Get.back();

        Get.snackbar('Success', 'Job updated');
      },
    );
  }


}
