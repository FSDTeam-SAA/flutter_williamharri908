import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:williamharri/src/module/home/controller/job_controller.dart';
import 'package:williamharri/src/module/home/ui/view/edit_job.dart';
import 'package:williamharri/src/module/profile/controller/profile_data_controller.dart';
import 'package:williamharri/src/module/profile/controller/staff_list_controller.dart';
import 'package:williamharri/src/module/profile/repo/profile_repo.dart';
import 'package:williamharri/src/module/home/model/job_cart_model.dart';

/// ---------------------------------------------------------------------------
/// FULL IMAGE VIEW
/// ---------------------------------------------------------------------------
class FullImageViewScreen extends StatelessWidget {
  final String imageUrl;
  const FullImageViewScreen({super.key, required this.imageUrl});

  bool get isNetwork => imageUrl.startsWith('http');

  @override
  Widget build(BuildContext context) {
    final image = isNetwork
        ? Image.network(imageUrl, fit: BoxFit.contain)
        : Image.file(File(imageUrl), fit: BoxFit.contain);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(maxScale: 5, child: image),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// PDF VIEWER (NETWORK PDF -> SYNCFUSION VIEWER)
/// ---------------------------------------------------------------------------
class JobPdfViewerScreen extends StatefulWidget {
  final String url;
  final String title;

  const JobPdfViewerScreen({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<JobPdfViewerScreen> createState() => _JobPdfViewerScreenState();
}

class _JobPdfViewerScreenState extends State<JobPdfViewerScreen> {
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SfPdfViewer.network(
            widget.url,
            canShowScrollStatus: true,
            canShowPaginationDialog: true,
            onDocumentLoadFailed: (details) {
              setState(() {
                _errorMessage =
                'Error: ${details.error}\nDescription: ${details.description}';
              });
            },
          ),
          if (_errorMessage != null)
            Container(
              color: Colors.black,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
              child: Text(
                'Failed to load PDF:\n$_errorMessage',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// JOB DETAILS UI
/// ---------------------------------------------------------------------------
class JobDetailsUi extends StatelessWidget {
  final JobModel job;
  const JobDetailsUi({super.key, required this.job});

  bool isPdf(String url) => url.toLowerCase().endsWith('.pdf');
  bool isImage(String url) =>
      url.toLowerCase().endsWith('.png') ||
          url.toLowerCase().endsWith('.jpg') ||
          url.toLowerCase().endsWith('.jpeg') ||
          url.toLowerCase().endsWith('.webp');

  void openAttachment(
      BuildContext context, {
        required String url,
        required String title,
      }) {
    if (isPdf(url)) {
      Get.to(() => JobPdfViewerScreen(url: url, title: title));
    } else if (isImage(url)) {
      Get.to(() => FullImageViewScreen(imageUrl: url));
    } else {
      Get.snackbar(
        "Unsupported",
        "This file type cannot be opened",
        backgroundColor: Colors.orange,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileDataController>();

    final avatarImage = job.thumbnail?.isNotEmpty == true
        ? NetworkImage(job.thumbnail!)
        : (job.photos.isNotEmpty ? NetworkImage(job.photos.first) : null);

    final attachments = <Map<String, String>>[];
    if (job.methodStatementUrl.isNotEmpty) {
      attachments.add({'Method Statement': job.methodStatementUrl});
    }
    if (job.riskAssessmentUrl.isNotEmpty) {
      attachments.add({'Risk Assessment': job.riskAssessmentUrl});
    }

    final lat = job.coordinates.lat?.toStringAsFixed(6) ?? '—';
    final lng = job.coordinates.lang?.toStringAsFixed(6) ?? '—';
    final address = job.location.trim().isEmpty ? 'Not provided' : job.location;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Job Details"),
        backgroundColor: Colors.black87,
        elevation: 0,
        actions: [
          if (profileController.profile.value?.role == "manager") ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.orangeAccent),
              onPressed: () async {
                if (!Get.isRegistered<StaffController>()) {
                  final repo = Get.find<ProfileRepo>();
                  Get.put(StaffController(repo: repo));
                }

                final updated = await Get.to<bool>(
                      () => EditJobScreen(job: job),
                );
                if (updated == true) {
                  Get.snackbar(
                    'Success',
                    'Job updated successfully',
                    backgroundColor: Colors.green.shade700,
                    colorText: Colors.white,
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_forever_rounded,
                color: Colors.redAccent,
              ),
              onPressed: () async {
                final confirmed = await Get.dialog<bool>(
                  AlertDialog(
                    backgroundColor: const Color(0xFF1F1F1F),
                    title: const Text(
                      'Delete Job',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: const Text(
                      'Are you sure you want to delete this job?',
                      style: TextStyle(color: Colors.white70),
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
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  Get.find<JobController>().deleteJob(job.id);
                  Get.back();
                }
              },
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header / Company info
            Card(
              elevation: 0,
              color: Colors.white.withOpacity(0.08),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: avatarImage,
                      backgroundColor:
                      avatarImage == null ? Colors.blueGrey : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.companyName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            job.client.clientEmail,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Phone: ${job.client.clientPhoneNo}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Location Section
            const Text(
              "Location",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            Column(
              children: [
                _buildCopyRow(
                  label: "Latitude",
                  value: lat,
                  icon: Icons.location_searching_rounded,
                  onCopy: () {
                    Clipboard.setData(ClipboardData(text: lat));
                    Get.snackbar('Copied', 'Latitude copied to clipboard');
                  },
                ),
                const Divider(height: 24, color: Colors.white12),
                _buildCopyRow(
                  label: "Longitude",
                  value: lng,
                  icon: Icons.location_searching_rounded,
                  onCopy: () {
                    Clipboard.setData(ClipboardData(text: lng));
                    Get.snackbar('Copied', 'Longitude copied to clipboard');
                  },
                ),
                const Divider(height: 24, color: Colors.white12),
                _buildCopyRow(
                  label: "Address",
                  value: address,
                  icon: Icons.place_outlined,
                  multiLine: true,
                  onCopy: job.location.trim().isNotEmpty
                      ? () {
                    Clipboard.setData(
                      ClipboardData(text: job.location),
                    );
                    Get.snackbar(
                      'Copied',
                      'Address copied to clipboard',
                    );
                  }
                      : null,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Quotation
            _buildSimpleInfoRow(
              label: "Quotation No",
              value: job.quotationNo ?? "No Quotation",
            ),

            const SizedBox(height: 24),

            // Description
            const Text(
              "Description",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                job.description.isEmpty
                    ? "No description provided"
                    : job.description,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Documents
            if (attachments.isNotEmpty) ...[
              const Text(
                "Documents",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              ...attachments.map(
                    (map) => _pdfTile(
                  label: map.keys.first,
                  enabled: map.values.first.isNotEmpty,
                  onTap: () => openAttachment(
                    context,
                    url: map.values.first,
                    title: map.keys.first,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Photos
            const Text(
              "Photos",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            job.photos.isEmpty
                ? const Text(
              "No photos available",
              style: TextStyle(color: Colors.white54),
            )
                : SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: job.photos.length,
                itemBuilder: (context, index) {
                  final url = job.photos[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => openAttachment(
                        context,
                        url: url,
                        title: "Photo ${index + 1}",
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          url,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[900],
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildCopyRow({
    required String label,
    required String value,
    required IconData icon,
    VoidCallback? onCopy,
    bool multiLine = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.white70),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              SelectableText(
                value,
                maxLines: multiLine ? 4 : 1,
                style: TextStyle(
                  fontSize: multiLine ? 15 : 16,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        if (onCopy != null)
          IconButton(
            icon: const Icon(Icons.copy_rounded, size: 20),
            color: Colors.white70,
            tooltip: 'Copy',
            onPressed: onCopy,
          ),
      ],
    );
  }

  Widget _buildSimpleInfoRow({required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: SelectableText(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _pdfTile({
    required String label,
    required bool enabled,
    required VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.picture_as_pdf_rounded,
            color: enabled ? Colors.redAccent : Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: enabled ? Colors.white : Colors.white54,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.visibility_rounded,
              color: enabled ? Colors.greenAccent : Colors.grey,
            ),
            onPressed: enabled ? onTap : null,
          ),
        ],
      ),
    );
  }
}
