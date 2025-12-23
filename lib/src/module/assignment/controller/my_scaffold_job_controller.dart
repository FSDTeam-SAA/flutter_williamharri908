import 'package:get/get.dart';
import 'package:williamharri/src/module/assignment/model/get_my_scaffold_model.dart';
import 'package:williamharri/src/module/assignment/repo/application_repo.dart';

class MyScaffoldJobController extends GetxController {
  final ApplicationRepo submitRepo;

  MyScaffoldJobController({required this.submitRepo});

  RxList<GetMyScaffoldModel> jobs = <GetMyScaffoldModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  @override
  void onReady() {
    super.onReady();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    isLoading.value = true;

    final result = await submitRepo.myScaffoldList();

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
