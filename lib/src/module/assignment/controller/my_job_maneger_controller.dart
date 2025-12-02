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
    fetchJobs();   // auto refresh when page reopens
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
}
