import 'package:get/get.dart';
import 'package:williamharri/src/module/home/model/job_cart_model.dart';
import 'package:williamharri/src/module/home/repo/job_repo.dart';

class StaffJobController extends GetxController {
  StaffJobController({required this.jobRepo});

  final JobRepo jobRepo;

  RxList<JobModel> staffjobs = <JobModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    try {
      isLoading.value = true;

      final result = await jobRepo.getStaffJobs();

      result.fold(
        (failure) {
          Get.snackbar("Error", failure.uiMessage);
        },
        (success) {
          staffjobs.assignAll(success);
        },
      );
    } finally {
      isLoading.value = false;
    }
  }
}
