import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:williamharri/src/module/assignment/model/submitit_scaffold.dart';
import 'package:williamharri/src/module/assignment/repo/application_repo.dart';
import 'package:williamharri/src/module/home/model/job_cart_model.dart';
import 'package:williamharri/src/module/home/ui/widget/image_view_screen.dart';
import 'package:williamharri/src/module/home/ui/widget/return_home.dart';

class JobApplicationScreen extends StatefulWidget {
  const JobApplicationScreen({super.key});

  @override
  State<JobApplicationScreen> createState() => _JobApplicationScreenState();
}

class _JobApplicationScreenState extends State<JobApplicationScreen> {
  late JobModel job;

  File? signatureFile;
  String? signaturePath;

  final TextEditingController _descriptionController = TextEditingController();
  final RxList<File> uploadedPhotos = RxList<File>();
  final RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    job = args["job"];

    if (args["signatureFile"] != null) {
      signatureFile = args["signatureFile"];
    } else if (job.signatureUrl.isNotEmpty) {
      signaturePath = job.signatureUrl;
    }

    _descriptionController.text = job.description;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  /// PICK ONLY IMAGES
  Future<void> pickPhotos() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isEmpty) return;

    uploadedPhotos.addAll(images.map((img) => File(img.path)));

    Get.snackbar(
      "Uploaded",
      "${images.length} image(s) selected",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  /// SUBMIT APPLICATION
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
        signature: signatureFile?.path ?? signaturePath ?? "",
      );

      final repo = Get.find<ApplicationRepo>();
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

  Widget buildSignaturePreview() {
    if (signatureFile != null) {
      return Image.file(signatureFile!, fit: BoxFit.contain);
    } else if (signaturePath != null) {
      if (signaturePath!.toLowerCase().endsWith(".pdf")) {
        return const Center(
          child: Text(
            "PDF signature (cannot preview)",
            style: TextStyle(color: Colors.white54),
          ),
        );
      } else {
        return Image.network(
          signaturePath!,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Text(
              "Cannot load signature",
              style: TextStyle(color: Colors.white54),
            ),
          ),
        );
      }
    } else {
      return const Center(
        child: Text(
          "No signature uploaded",
          style: TextStyle(color: Colors.white54),
        ),
      );
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

            // Upload images
            const Text(
              "Upload images",
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
                  children: const [
                    Icon(
                      Icons.cloud_upload_outlined,
                      color: Colors.white54,
                      size: 48,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Browse your images",
                      style: TextStyle(color: Colors.white54, fontSize: 15),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "You can select JPG, JPEG, PNG",
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
                      children: uploadedPhotos.map((file) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(
                                  () =>
                                      FullImageViewScreen(imageUrl: file.path),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  file,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => uploadedPhotos.remove(file),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
            ),

            const SizedBox(height: 24),

            // Signature preview
            const Text(
              "Signature",
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F1F),
                borderRadius: BorderRadius.circular(16),
              ),
              child: buildSignaturePreview(),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: FloatingActionButton.extended(
              onPressed: isLoading.value ? null : submitApplication,
              backgroundColor: isLoading.value ? Colors.grey : Colors.orange,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
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
