import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:williamharri/src/core/component/reactive_ui/process_notifier.dart';
import 'package:williamharri/src/core/utils/helpers/handle_fold.dart';
import 'package:williamharri/src/module/assignment/model/my_jobs_manager_model.dart';

import '../../assignment/model/update_staff_scafold.dart';
import '../../assignment/repo/application_repo.dart';

class ManagerUpdateScaffoldController extends GetxController {
  final JobModelManager job;

  ManagerUpdateScaffoldController(this.job);

  final ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier(
    initialStatus: EnabledStatus(),
  );

  final ImagePicker picker = ImagePicker();

  /// Edit mode
  final RxBool isEdit = false.obs;

  /// Description
  late TextEditingController descController;

  /// Newly added photos (local files)
  final RxList<File> newlyAddedPhotos = <File>[].obs;

  /// New signature file
  final Rx<File?> newSignatureFile = Rx<File?>(null);

  @override
  void onInit() {
    descController = TextEditingController(text: job.description);
    super.onInit();
  }

  @override
  void onClose() {
    descController.dispose();
    super.onClose();
  }

  // Check if URL is network image
  bool isNetworkUrl(String path) =>
      path.startsWith('http://') || path.startsWith('https://');

  // Check if local file exists
  bool isValidLocalFile(String path) => File(path).existsSync();

  /// Pick MULTIPLE images
  Future<void> pickMultiplePhotos() async {
    final List<XFile>? pickedFiles = await picker.pickMultiImage(
      imageQuality: 85,
    );

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      newlyAddedPhotos.addAll(pickedFiles.map((e) => File(e.path)));
      Get.snackbar(
        "Success",
        "${pickedFiles.length} photo(s) added",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  /// Pick signature
  Future<void> pickSignature() async {
    final XFile? img = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (img != null) {
      newSignatureFile.value = File(img.path);
    }
  }

  /// Remove newly added photo
  void removeNewPhoto(int index) {
    newlyAddedPhotos.removeAt(index);
  }

  /// Remove signature
  void clearNewSignature() {
    newSignatureFile.value = null;
  }

  /// Remove existing old photo (from server list)
  void removeExistingPhoto(int index) {
    job.photos.removeAt(index);
    update(); // refresh UI
  }

  /// Save changes (you can add API call)
  Future<void> saveChanges() async {
    final scaffoldId = job.latestScaffold?.id;
    if (scaffoldId == null) {
      Get.snackbar("Error", "No scaffold found for this job");
      return;
    }

    // Show loading
    processStatusNotifier.setLoading();

    final res = await Get.find<ApplicationRepo>().scaffoldUpdate(
      UpdateStaffScafoldParam(
        jobId: scaffoldId, // ✅ use scaffold/application ID
        description: descController.text,
        photos: newlyAddedPhotos,
        signature: newSignatureFile.value,
      ),
    );

    handleFold(
      either: res,
      processStatusNotifier: processStatusNotifier,
      onError: (failure) {
        debugPrint("Error: $failure");
        Get.snackbar("Error", failure.uiMessage);
      },
      onSuccess: (data) {
        debugPrint("Success: $data");
        Get.snackbar("Saved", "Changes saved successfully!");
      },
    );

    isEdit.value = false;
  }
}
