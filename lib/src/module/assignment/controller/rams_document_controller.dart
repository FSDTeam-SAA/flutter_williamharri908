import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/module/assignment/repo/application_repo.dart';
import 'package:williamharri/src/module/home/model/job_cart_model.dart';
import 'package:williamharri/src/module/home/ui/widget/pdf_view_screen.dart';

class RamsDocumentController extends GetxController {
  final ApplicationRepo repo;

  RamsDocumentController({required this.repo});
  var isAgreed = false.obs;
  var isLoading = false.obs;
  var uploadedImage = Rx<File?>(null);
  var hasOpenedMethodStatement = false.obs;
  var hasOpenedRiskAssessment = false.obs;

  bool get canAgree =>
      hasOpenedMethodStatement.value && hasOpenedRiskAssessment.value;

  Future<void> openPdf(String url, String type) async {
    if (url.isEmpty) {
      Get.snackbar(
        "Error",
        "Document not available",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    await Get.to(
      () => PdfViewerScreen(
        url: url,
        title: type == "method" ? "Method Statement" : "Risk Assessment",
      ),
    );

    if (type == "method") {
      hasOpenedMethodStatement.value = true;
    } else {
      hasOpenedRiskAssessment.value = true;
    }
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image, // 🔥 only images allowed
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      uploadedImage.value = File(result.files.single.path!);

      Get.snackbar(
        "Uploaded",
        "Image selected successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  void removeImage() {
    uploadedImage.value = null;
  }

  Future<void> submitRamsDocument(JobModel job) async {
    if (!isAgreed.value) {
      Get.snackbar(
        "Agreement Required",
        "Please confirm that you read both documents",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (uploadedImage.value == null) {
      Get.snackbar(
        "Signature Required",
        "Please upload your signature image",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      Get.snackbar(
        "Success",
        "RAMS document submitted successfully",
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
