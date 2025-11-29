import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:williamharri/src/module/assignment/controller/rams_document_controller.dart';
import 'package:williamharri/src/module/home/model/job_cart_model.dart';
import 'package:williamharri/src/module/home/ui/view/job_application.dart';

class RamsDocumentScreen extends GetView<RamsDocumentController> {
  final JobModel job;

  const RamsDocumentScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "RAMS Document",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Required Documents",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            _buildDocTile(
              title: "Method Statement",
              url: job.methodStatementUrl,
            ),
            const SizedBox(height: 15),
            _buildDocTile(title: "Risk Assessment", url: job.riskAssessmentUrl),
            const SizedBox(height: 30),
            const Text(
              "Upload Your Signature",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: controller.pickImage,
              child: Obx(
                () => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white12,
                  ),
                  child: Row(
                    children: [
                      if (controller.uploadedImage.value != null)
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Image.file(
                              controller.uploadedImage.value!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                            GestureDetector(
                              onTap: controller.removeImage,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(2),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        const Icon(
                          Icons.upload_file,
                          color: Colors.blue,
                          size: 30,
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          controller.uploadedImage.value == null
                              ? "Tap to upload your signature image"
                              : controller.uploadedImage.value!.path
                                    .split('/')
                                    .last,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: controller.isAgreed.value,
                        activeColor: Color(0xFFF99B07),
                        checkColor: Colors.black,
                        side: const BorderSide(color: Colors.white70, width: 2),
                        onChanged: (val) =>
                            controller.isAgreed.value = val ?? false,
                      ),
                      const Expanded(
                        child: Text(
                          "I agree that I have read both documents",
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FloatingActionButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: controller.isAgreed.value
                          ? Color(0xFFF99B07)
                          : Colors.grey.shade700,
                      elevation: 0,
                      onPressed: controller.isAgreed.value
                          ? () {
                              Get.to(
                                () => JobApplicationScreen(),
                                arguments: {
                                  "job": job,
                                  "signatureFile":
                                      controller.uploadedImage.value!,
                                },
                              );
                            }
                          : null,
                      child: const Text(
                        "Next",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocTile({required String title, required String url}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white12,
      ),
      child: Row(
        children: [
          Icon(
            url.toLowerCase().endsWith(".pdf")
                ? Icons.picture_as_pdf
                : Icons.image,
            color: Colors.red,
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.visibility, color: Colors.green),
            onPressed: () {
              if (url.isEmpty) {
                Get.snackbar(
                  "Error",
                  "Document not available",
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                );
              } else {
                OpenFilex.open(url);
              }
            },
          ),
        ],
      ),
    );
  }
}
