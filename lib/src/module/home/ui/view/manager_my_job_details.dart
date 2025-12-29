import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/core/component/reactive_ui/process_notifier.dart';
import 'package:williamharri/src/core/component/reactive_ui/widget/save_button.dart';
import 'package:williamharri/src/module/assignment/controller/my_job_maneger_controller.dart';
import 'package:williamharri/src/module/assignment/model/my_jobs_manager_model.dart';
import 'package:williamharri/src/module/home/ui/view/rams_documents.dart';
import 'package:williamharri/src/module/home/ui/widget/image_view_screen.dart';

class JobDetailsScreen extends StatelessWidget {
  final JobModelManager job;

  JobDetailsScreen({super.key, required this.job});

  final controller = Get.find<MyJobManagerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Scaffold Details',
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              job.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Company & Location
            Text(
              '${job.companyName} • ${job.location}',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Description
            const Text(
              'Scaffold Description',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              job.description,
              maxLines: 5,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),

            // Job Photos
            const Text(
              'Photos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            _buildPhotoGrid(job.photos),

            const SizedBox(height: 32),

            // Staff Submitted Section
            if (job.latestScaffold != null) ...[
              // Description
              const Text(
                'Scaffold Description',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                job.latestScaffold!.description,
                maxLines: 5,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 12),

              const Text(
                'Scaffold Photos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              _buildPhotoGrid(job.latestScaffold!.photos),

              const Text(
                'Signature',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              _buildSignature(job.latestScaffold!.signatureUrl),

              SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => controller.markComplete(job),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF99B07),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Complete',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.to(() => Scaffold()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF99B07),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 32),

            // Column(
            //   children: [
            //     RSaveButton(
            //       height: 52,
            //       key: UniqueKey(),
            //       buttonStatusNotifier: ProcessStatusNotifier(
            //         initialStatus: EnabledStatus(),
            //       ),
            //       saveText: "Accept",
            //       doneText: "Accepted",
            //       loadingText: "Accepting...",
            //       onDone: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => ManagerRamsDocumentScreen(job: job),
            //           ),
            //         );
            //       },
            //       onSave: (ProcessStatusNotifier processNotifier) {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => ManagerRamsDocumentScreen(job: job),
            //           ),
            //         );
            //       },
            //     ),
            //   ],
            // ),
            Column(
              children: [
                if (job.latestScaffold == null)
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
                          builder: (context) =>
                              ManagerRamsDocumentScreen(job: job),
                        ),
                      );
                    },
                    onSave: (ProcessStatusNotifier processNotifier) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ManagerRamsDocumentScreen(job: job),
                        ),
                      );
                    },
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // you can pass an `isEdit` flag if your screen needs it
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ManagerRamsDocumentScreen(job: job),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF99B07),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Edit Scaffold',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Detects and loads correct image type
  ImageProvider loadImage(String path) {
    if (path.startsWith('http')) {
      return NetworkImage(path);
    } else {
      return FileImage(File(path));
    }
  }

  /// Grid builder for photos
  Widget _buildPhotoGrid(List<String> photos) {
    if (photos.isEmpty) {
      return const Text(
        'No photos available',
        style: TextStyle(color: Colors.white54),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: photos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        final url = photos[index];

        return GestureDetector(
          onTap: () => Get.to(() => FullImageViewScreen(imageUrl: url)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(image: loadImage(url), fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignature(String url) {
    if (url.isEmpty) {
      return const Text(
        'No signature submitted',
        style: TextStyle(color: Colors.white54),
      );
    }

    return GestureDetector(
      onTap: () => Get.to(() => FullImageViewScreen(imageUrl: url)),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(image: loadImage(url), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
