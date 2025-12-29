import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:williamharri/src/module/assignment/model/submitit_scaffold.dart';
import 'package:williamharri/src/module/assignment/repo/application_repo.dart';
import 'package:williamharri/src/module/home/model/job_cart_model.dart'; // JobModel
import 'package:williamharri/src/module/assignment/model/my_jobs_manager_model.dart'; // JobModelManager
import 'package:williamharri/src/module/home/ui/widget/image_view_screen.dart';
import 'package:williamharri/src/module/home/ui/widget/return_home.dart';

class JobApplicationScreen extends StatefulWidget {
  final JobModel? job;                  // For staff/applicant flow
  final JobModelManager? managerJob;    // For manager/supervisor flow

  const JobApplicationScreen({
    super.key,
    this.job,
    this.managerJob,
  }) : assert(
          job != null || managerJob != null,
          'Must provide at least one job type (job or managerJob)',
        );

  @override
  State<JobApplicationScreen> createState() => _JobApplicationScreenState();
}

class _JobApplicationScreenState extends State<JobApplicationScreen> {
  // Helpers to access common fields safely
  String get jobId => widget.job?.id ?? widget.managerJob!.id;
  String get initialDescription =>
      widget.job?.description ?? widget.managerJob!.description;
  String? get existingSignatureUrl => widget.job?.signatureUrl;

  File? signatureFile;
  String? signaturePath;

  final TextEditingController _descriptionController = TextEditingController();
  final RxList<File> uploadedPhotos = <File>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();

    // Handle signature from arguments (usually from Rams screen)
    final args = Get.arguments as Map<String, dynamic>?;

    if (args != null && args["signatureFile"] != null) {
      signatureFile = args["signatureFile"] as File?;
    }

    // Fallback to existing signature URL (mostly for staff flow)
    if (signatureFile == null &&
        existingSignatureUrl != null &&
        existingSignatureUrl!.isNotEmpty) {
      signaturePath = existingSignatureUrl;
    }

    // Set initial description
    _descriptionController.text = initialDescription;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  /// Pick multiple images from gallery
  Future<void> pickPhotos() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images == null || images.isEmpty) return;

    uploadedPhotos.addAll(images.map((xfile) => File(xfile.path)));

    Get.snackbar(
      "Uploaded",
      "${images.length} image(s) selected",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  /// Submit the scaffold/application
  Future<void> submitApplication() async {
    if (_descriptionController.text.trim().isEmpty) {
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
        jobid: jobId,
        description: _descriptionController.text.trim(),
        methodStatementAgreed: true, // Adjust if you have UI for this
        riskAssessmentAgreed: true,  // Adjust if you have UI for this
        termsAccepted: true,         // Adjust if you have UI for this
        photos: uploadedPhotos.toList(),
        signature: signatureFile,    // Can be null if manager doesn't upload
      );

      final repo = Get.find<ApplicationRepo>();
      await repo.submititScaffold(model);

      Get.snackbar(
        "Success",
        "Application submitted successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAll(() => const ReturnHomeScreen());
    } catch (e) {
      Get.snackbar(
        "Submission Failed",
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
      return Image.file(
        signatureFile!,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Icon(Icons.error, color: Colors.red),
      );
    }

    if (signaturePath != null && signaturePath!.isNotEmpty) {
      if (signaturePath!.toLowerCase().endsWith('.pdf')) {
        return const Center(
          child: Text(
            "PDF signature (preview not supported)",
            style: TextStyle(color: Colors.white54),
          ),
        );
      }

      return Image.network(
        signaturePath!,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Center(
          child: Text(
            "Failed to load signature",
            style: TextStyle(color: Colors.white54),
          ),
        ),
      );
    }

    return const Center(
      child: Text(
        "No signature available",
        style: TextStyle(color: Colors.white54),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Scaffold Submission",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description field
            const Text(
              "Description / Remarks",
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 8,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter details about the work / scaffold...",
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
            const SizedBox(height: 32),

            // Photos upload section
            const Text(
              "Upload Photos",
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
                    Icon(Icons.cloud_upload_outlined,
                        color: Colors.white54, size: 48),
                    SizedBox(height: 12),
                    Text("Tap to browse images",
                        style: TextStyle(color: Colors.white54, fontSize: 15)),
                    SizedBox(height: 4),
                    Text("JPG, JPEG, PNG supported",
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Uploaded photos preview
            Obx(
              () => uploadedPhotos.isEmpty
                  ? const SizedBox.shrink()
                  : Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: uploadedPhotos.map((file) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            GestureDetector(
                              onTap: () => Get.to(
                                () => FullImageViewScreen(imageUrl: file.path),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  file,
                                  width: 110,
                                  height: 110,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              right: -4,
                              top: -4,
                              child: GestureDetector(
                                onTap: () => uploadedPhotos.remove(file),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
            ),

            const SizedBox(height: 32),

            // Signature preview
            const Text(
              "Signature",
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F1F),
                borderRadius: BorderRadius.circular(16),
              ),
              child: buildSignaturePreview(),
            ),

            const SizedBox(height: 140),
          ],
        ),
      ),

      // Submit Button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: FloatingActionButton.extended(
              onPressed: isLoading.value ? null : submitApplication,
              backgroundColor: isLoading.value ? Colors.grey : const Color(0xFFF99B07),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              label: isLoading.value
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text(
                      "Submit Scaffold",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}