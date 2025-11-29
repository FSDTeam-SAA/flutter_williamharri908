// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:williamharri/src/module/assignment/model/submitit_scaffold.dart';
// import 'package:williamharri/src/module/assignment/repo/application_repo.dart';
// import 'package:williamharri/src/module/home/model/job_cart_model.dart';

// class RamsDocumentController extends GetxController {
//   final SubmitRepo repo;

//   RamsDocumentController({required this.repo});

//   var isAgreed = false.obs;
//   var isLoading = false.obs;
//   var uploadedImage = Rx<File?>(null);





//   // ADD THESE 4 LINES
//   var hasOpenedMethodStatement = false.obs;
//   var hasOpenedRiskAssessment = false.obs;

//   bool get canAgree => hasOpenedMethodStatement.value && hasOpenedRiskAssessment.value;


//   Future<void> openPdf(String url, String type) async {
//     if (url.isEmpty) {
//       Get.snackbar("Error", "Document not available", backgroundColor: Colors.red);
//       return;
//     }

//     final result = await OpenFilex.open(url);

//     if (result.type == ResultType.done) {
//       if (type == "method") {
//         hasOpenedMethodStatement.value = true;
//       } else if (type == "risk") {
//         hasOpenedRiskAssessment.value = true;
//       }
//     }
//   }

//   /// Pick image file only (jpg, jpeg, png)
//   Future<void> pickImage() async {
//     final result = await FilePicker.platform.pickFiles(
//       allowMultiple: false,
//       type: FileType.image,
//     );

//     if (result != null && result.files.single.path != null) {
//       uploadedImage.value = File(result.files.single.path!);

//       Get.snackbar(
//         "Uploaded",
//         "Image selected successfully",
//         colorText: Colors.white,
//         backgroundColor: Colors.green,
//       );
//     }
//   }

//   /// Remove uploaded image
//   void removeImage() {
//     uploadedImage.value = null;
//   }

//   /// Submit RAMS document
//   Future<void> submitRamsDocument(JobModel job) async {
//     if (!isAgreed.value) {
//       Get.snackbar(
//         "Agreement Required",
//         "Please agree to the documents first",
//         colorText: Colors.white,
//         backgroundColor: Colors.red,
//       );
//       return;
//     }

//     if (uploadedImage.value == null) {
//       Get.snackbar(
//         "Signature Required",
//         "Please upload your signature image",
//         colorText: Colors.white,
//         backgroundColor: Colors.red,
//       );
//       return;
//     }

//     isLoading.value = true;

//     try {
//       final model = SubmititScaffoldModel(
//         jobid: job.id,
//         description: job.description,
//         methodStatementAgreed: true,
//         riskAssessmentAgreed: true,
//         termsAccepted: true,
//         photos: [],
//         signature: uploadedImage.value!.path,
//       );

//       // await repo.submititScaffold(model);

//       Get.snackbar(
//         "Success",
//         "RAMS document submitted",
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );

//       Get.back();
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         e.toString(),
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }


import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:williamharri/src/module/assignment/model/submitit_scaffold.dart';
import 'package:williamharri/src/module/assignment/repo/application_repo.dart';
import 'package:williamharri/src/module/home/model/job_cart_model.dart';
import 'package:williamharri/src/module/home/ui/widget/pdf_view_screen.dart';

class RamsDocumentController extends GetxController {
  final SubmitRepo repo;

  RamsDocumentController({required this.repo});

  // Agreement Checkbox
  var isAgreed = false.obs;

  // Loader
  var isLoading = false.obs;

  // Signature image file
  var uploadedImage = Rx<File?>(null);

  // Track if PDFs are opened
  var hasOpenedMethodStatement = false.obs;
  var hasOpenedRiskAssessment = false.obs;

  // Allow agreement only if both PDF opened
  bool get canAgree => hasOpenedMethodStatement.value && hasOpenedRiskAssessment.value;

  // -------------------------------------------------------------------------
  // OPEN PDF – Download + View Inside App
  // -------------------------------------------------------------------------
  Future<void> openPdf(String url, String type) async {
  if (url.isEmpty) {
    Get.snackbar("Error", "Document not available",
        backgroundColor: Colors.red, colorText: Colors.white);
    return;
  }

  await Get.to(() => PdfViewerScreen(
        url: url,
        title: type == "method" ? "Method Statement" : "Risk Assessment",
      ));

  if (type == "method") {
    hasOpenedMethodStatement.value = true;
  } else {
    hasOpenedRiskAssessment.value = true;
  }
}



  // -------------------------------------------------------------------------
  // PICK IMAGE ONLY (jpg/jpeg/png)
  // -------------------------------------------------------------------------
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

  // -------------------------------------------------------------------------
  // REMOVE IMAGE
  // -------------------------------------------------------------------------
  void removeImage() {
    uploadedImage.value = null;
  }

  // -------------------------------------------------------------------------
  // SUBMIT RAMS DOCUMENT
  // -------------------------------------------------------------------------
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
      final model = SubmititScaffoldModel(
        jobid: job.id,
        description: job.description,
        methodStatementAgreed: true,
        riskAssessmentAgreed: true,
        termsAccepted: true,
        photos: [],
        signature: uploadedImage.value!.path,
      );

      // Call your API
      // await repo.submititScaffold(model);

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
