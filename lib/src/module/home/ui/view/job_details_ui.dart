import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/core/component/reactive_ui/process_notifier.dart';
import 'package:williamharri/src/core/component/reactive_ui/widget/save_button.dart';
import 'package:williamharri/src/module/home/controller/job_controller.dart';
import 'package:williamharri/src/module/home/ui/view/edit_job.dart';
import 'package:williamharri/src/module/home/ui/view/rams_documents.dart';
import 'package:williamharri/src/module/profile/controller/profile_data_controller.dart';
import 'package:williamharri/src/module/profile/controller/staff_list_controller.dart';
import 'package:williamharri/src/module/profile/repo/profile_repo.dart';
import 'package:williamharri/src/module/home/model/job_cart_model.dart';

class FullImageViewScreen extends StatelessWidget {
  final String imageUrl;
  const FullImageViewScreen({super.key, required this.imageUrl});

  bool get isNetwork => imageUrl.startsWith('http');

  @override
  Widget build(BuildContext context) {
    final image = isNetwork
        ? Image.network(imageUrl)
        : Image.file(File(imageUrl));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(child: InteractiveViewer(maxScale: 5, child: image)),
    );
  }
}

class JobPdfViewerScreen extends StatelessWidget {
  final String url;
  final String title;

  const JobPdfViewerScreen({super.key, required this.url, required this.title});

  @override
  Widget build(BuildContext context) {
    final pdfUrl = "https://docs.google.com/gview?embedded=true&url=$url";
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: WebViewPlaceholder(pdfUrl: pdfUrl),
    );
  }
}

class WebViewPlaceholder extends StatelessWidget {
  final String pdfUrl;
  const WebViewPlaceholder({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('PDF will load from: $pdfUrl'));
  }
}

class JobDetailsUi extends StatelessWidget {
  final JobModel job;
  const JobDetailsUi({super.key, required this.job});

  bool isPdf(String url) => url.toLowerCase().endsWith('.pdf');
  bool isImage(String url) =>
      url.toLowerCase().endsWith('.png') ||
      url.toLowerCase().endsWith('.jpg') ||
      url.toLowerCase().endsWith('.jpeg') ||
      url.toLowerCase().endsWith('.webp');

  void openAttachment({required String url, required String title}) {
    if (isPdf(url)) {
      Get.to(() => JobPdfViewerScreen(url: url, title: title));
    } else if (isImage(url)) {
      Get.to(() => FullImageViewScreen(imageUrl: url));
    } else {
      Get.snackbar("Unsupported file", "Cannot open this file type");
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileDataController>();

    ImageProvider? avatarImage;
    if (job.thumbnail != null && job.thumbnail!.isNotEmpty) {
      avatarImage = NetworkImage(job.thumbnail!);
    } else if (job.photos.isNotEmpty) {
      avatarImage = NetworkImage(job.photos.first);
    }

    final attachments = <Map<String, String>>[];
    if (job.methodStatementUrl.isNotEmpty)
      attachments.add({'Method Statement': job.methodStatementUrl});
    if (job.riskAssessmentUrl.isNotEmpty)
      attachments.add({'Risk Assessment': job.riskAssessmentUrl});

    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Details"),
        backgroundColor: Colors.transparent,
        actions: [
          if (profileController.profile.value?.role == "manager")
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.orange),
              onPressed: () async {
                if (!Get.isRegistered<StaffController>()) {
                  final profileRepo = Get.find<ProfileRepo>();
                  Get.put(StaffController(repo: profileRepo));
                }
                final updated = await Get.to<bool>(
                  () => EditJobScreen(job: job),
                );
                if (updated == true) {
                  Get.snackbar(
                    'Job updated',
                    'Job has been updated successfully.',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.green.shade600,
                    colorText: Colors.white,
                  );
                }
              },
            ),
          if (profileController.profile.value?.role == "manager")
            IconButton(
              icon: const Icon(
                Icons.delete_forever_outlined,
                color: Colors.red,
              ),
              onPressed: () async {
                final confirm = await Get.dialog<bool>(
                  AlertDialog(
                    title: const Text('Delete job'),
                    content: const Text(
                      'Are you sure you want to delete this job?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(result: false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Get.back(result: true),
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  Get.find<JobController>().deleteJob(job.id);
                }
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: avatarImage,
                  backgroundColor: avatarImage == null ? Colors.blue : null,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.companyName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        job.client.clientEmail,
                        style: const TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Phone:${job.client.clientPhoneNo}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      // const SizedBox(height: 8),
                      // Text(job.title, style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text(
                        'Address: ${job.location}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Longitude: ${job.coordinates.lang ?? '-'}',
                        style: const TextStyle(fontSize: 14),
                      ),

                      Text(
                        'Latitude: ${job.coordinates.lat ?? '-'}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              "Description",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              job.description.isEmpty
                  ? "No description available"
                  : job.description,
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 20),
            // ATTACHMENTS
            if (attachments.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Documents",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  for (var map in attachments)
                    _pdfTile(
                      label: map.keys.first,
                      enabled: map.values.first.isNotEmpty,
                      onTap: () => openAttachment(
                        url: map.values.first,
                        title: map.keys.first,
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 20),
            // PHOTOS
            const Text(
              "Photos",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: job.photos.isEmpty
                  ? const Text("No photos available")
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: job.photos.length,
                      itemBuilder: (_, index) {
                        final photoUrl = job.photos[index];
                        return GestureDetector(
                          onTap: () => openAttachment(
                            url: photoUrl,
                            title: "Photo ${index + 1}",
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                photoUrl,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 60),
            Column(
              children: [
                RSaveButton(
                  height: 52,
                  key: UniqueKey(),
                  buttonStatusNotifier: ProcessStatusNotifier(
                    initialStatus: EnabledStatus(),
                  ),
                  saveText: "Accept",
                  doneText: "Accepted",
                  loadingText: "Accepting...",
                  onDone: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RamsDocumentScreen(job: job),
                      ),
                    );
                  },
                  onSave: (ProcessStatusNotifier processNotifier) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RamsDocumentScreen(job: job),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// PDF Tile widget
Widget _pdfTile({
  required String label,
  required bool enabled,
  required VoidCallback? onTap,
}) {
  return Opacity(
    opacity: enabled ? 1 : 0.5,
    child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.remove_red_eye_outlined,
              color: enabled ? Colors.green : Colors.grey,
            ),
            onPressed: enabled ? onTap : null,
          ),
        ],
      ),
    ),
  );
}
