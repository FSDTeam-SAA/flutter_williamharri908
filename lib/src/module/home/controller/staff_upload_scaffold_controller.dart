import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/module/assignment/model/get_my_scaffold_model.dart';
import 'package:williamharri/src/module/assignment/model/update_staff_scafold.dart';
import 'package:williamharri/src/module/assignment/repo/application_repo_impl.dart';

class StaffScaffoldController extends GetxController {
  final GetMyScaffoldModel job;
  final SubmitRepoImpl repo;

  StaffScaffoldController({required this.job, required this.repo});

  var isEdit = false.obs;
  var description = ''.obs;
  var photos = <String>[].obs;
  var signatureFilePath = Rx<String?>(null);

  late final TextEditingController descController;

  @override
  void onInit() {
    super.onInit();
    description.value = job.description;
    photos.addAll(job.photos);
    descController = TextEditingController(text: job.description);
  }

  /// TOGGLE EDIT MODE
  void toggleEdit() {
    isEdit.value = !isEdit.value;
  }

  /// PICK PHOTO
  Future<void> pickPhoto() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf'],
      type: FileType.custom,
    );

    if (result != null) {
      photos.add(result.files.single.path!);
    }
  }

  /// PICK SIGNATURE
  Future<void> pickSignature() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf'],
      type: FileType.custom,
    );

    if (result != null) {
      signatureFilePath.value = result.files.single.path!;
    }
  }

  /// REMOVE PHOTO
  void removePhoto(int index) {
    photos.removeAt(index);
  }

  /// REMOVE SIGNATURE
  void removeSignature() {
    signatureFilePath.value = null;
  }

  /// SUBMIT UPDATE
  Future<void> submitUpdate() async {
    final updated = UpdateStaffScafold(
      description: descController.text,
      photos: photos,
      signatureUrl: signatureFilePath.value ?? job.signatureUrl,
    );

    final result = await repo.scaffoldUpdate(job.id, updated);

    result.fold(
      (failure) {
        Get.snackbar("Error", failure.uiMessage);
      },
      (success) {
        Get.back();
      },
    );
  }
}
