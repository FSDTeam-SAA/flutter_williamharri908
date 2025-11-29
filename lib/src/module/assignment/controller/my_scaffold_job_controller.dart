import 'package:get/get.dart';
import 'package:williamharri/src/module/assignment/model/get_my_scaffold_model.dart';
import 'package:williamharri/src/module/assignment/repo/submit_repo.dart';

class MyScaffoldJobController extends GetxController {
  MyScaffoldJobController({required this.submitRepo});

  final SubmitRepo submitRepo;

  RxList<GetMyScaffoldModel> jobs = <GetMyScaffoldModel>[].obs;
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