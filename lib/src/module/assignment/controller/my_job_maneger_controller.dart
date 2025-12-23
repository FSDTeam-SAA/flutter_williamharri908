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

  @override
  void onReady() {
    super.onReady();
    fetchJobs(); // auto refresh when page reopens
  }

  Future<void> fetchJobs() async {
    isLoading.value = true;

    final result = await submitRepo.myJobsManager();

    result.fold(
      (failure) {
        isLoading.value = false;
      },
      (success) {
        jobs.value = success;
        isLoading.value = false;
      },
    );
  }

  Future<void> markComplete(JobModelManager param) async {
  final result = await submitRepo.completeScaffold(param);

  result.fold(
    (failure) {
      Get.snackbar("Error", failure.uiMessage);
    },
    (status) {
      final index = jobs.indexWhere((job) => job.id == param.id);

      if (index != -1) {
        jobs[index] = JobModelManager(
          companyName: jobs[index].companyName,
          title: jobs[index].title,
          location: jobs[index].location,
          description: jobs[index].description,
          price: jobs[index].price,
          photos: jobs[index].photos,
          isDeleted: jobs[index].isDeleted,
          assignedTo: jobs[index].assignedTo,
          postedBy: jobs[index].postedBy,
          scaffoldStatus: status,   // UPDATE STATUS HERE
          id: jobs[index].id,
          jobStatus: jobs[index].jobStatus,
          createdAt: jobs[index].createdAt,
          updatedAt: jobs[index].updatedAt,
          latestScaffold: jobs[index].latestScaffold,
          scaffoldApplication: jobs[index].scaffoldApplication,
          methodStatementUrl: jobs[index].methodStatementUrl,
          riskAssessmentUrl: jobs[index].riskAssessmentUrl,
          targetDate: jobs[index].targetDate,
          thumbnail: jobs[index].thumbnail,
        );
      }

      Get.snackbar("Success", "Scaffold Completed");
    },
  );
}

}
