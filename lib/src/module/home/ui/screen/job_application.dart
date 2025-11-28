import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/module/assignment/model/submitit_scaffold.dart';
import 'package:williamharri/src/module/assignment/repo/submit_repo.dart';
import 'package:williamharri/src/module/home/model/job_cart_model.dart';
import 'package:williamharri/src/module/home/ui/widget/return_home.dart';

class JobApplicationScreen extends StatefulWidget {
  const JobApplicationScreen({super.key});

  @override
  State<JobApplicationScreen> createState() => _JobApplicationScreenState();
}

class _JobApplicationScreenState extends State<JobApplicationScreen> {
  late JobModel job;
  late File signatureFile;

  final TextEditingController _descriptionController = TextEditingController();
  final RxList<File> uploadedPhotos = RxList<File>();
  final RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    job = args["job"];
    signatureFile = args["signatureFile"];
    _descriptionController.text = job.description;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> pickPhotos() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null) {
      uploadedPhotos.addAll(
        result.paths.whereType<String>().map((path) => File(path)),
      );

      Get.snackbar(
        "Uploaded",
        "${result.files.length} file(s) selected",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  Future<void> submitApplication() async {
    if (_descriptionController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please write a description",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final model = SubmititScaffoldModel(
        jobid: job.id,
        description: _descriptionController.text,
        methodStatementAgreed: true,
        riskAssessmentAgreed: true,
        termsAccepted: true,
        photos: uploadedPhotos.map((file) => file.path).toList(),
        signature: signatureFile.path,
      );

      final repo = Get.find<SubmitRepo>();
      await repo.submititScaffold(model);

      Get.snackbar(
        "Success",
        "Job application submitted",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAll(() => ReturnHomeScreen());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Job Application",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job description
            const Text(
              "Job description",
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 8,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Write here",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1F1F1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 24),

            // Upload photo section
            const Text(
              "Upload photo / documents (optional)",
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: pickPhotos,
              child: Container(
                width: double.infinity,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud_upload_outlined,
                      color: Colors.white54,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Browse your files",
                      style: TextStyle(color: Colors.white54, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "You can select multiple files (jpg, png, pdf)",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => uploadedPhotos.isEmpty
                  ? const SizedBox.shrink()
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: uploadedPhotos
                          .map(
                            (file) => Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                file.path.split('/').last,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ),
            const SizedBox(height: 120), // Space for floating button
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: FloatingActionButton.extended(
              onPressed: isLoading.value ? null : submitApplication,
              backgroundColor: isLoading.value ? Colors.grey : Colors.orange,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              label: isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
