import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/module/assignment/model/submitit_scaffold.dart';
import 'package:williamharri/src/module/assignment/repo/submit_repo.dart';
import 'package:williamharri/src/module/home/model/job_cart_model.dart';

class RamsDocumentController extends GetxController {
  final SubmitRepo repo;

  RamsDocumentController({required this.repo});

  var isAgreed = false.obs;
  var isLoading = false.obs;

  var uploadedFile = Rx<File?>(null);

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      uploadedFile.value = File(result.files.single.path!);

      Get.snackbar(
        "Uploaded",
        "File selected successfully",
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );
    }
  }
  Future<void> submitRamsDocument(JobModel job) async {
    if (!isAgreed.value) {
      Get.snackbar(
        "Agreement Required",
        "Please agree to the documents first",
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    if (uploadedFile.value == null) {
      Get.snackbar(
        "Signature Required",
        "Please upload your signature",
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    isLoading.value = true;

    try {
      final model = SubmititScaffoldModel(
        jobid: job.id,
        description: job.description,
        methodStatementAgreed: true,
        riskAssessmentAgreed: true,
        termsAccepted: true,
        photos: [],
        signature: uploadedFile.value!.path,
      );

      // final response = await repo.submititScaffold(model);

      Get.snackbar(
        "Success",
        "RAMS document submitted",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.back();
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
