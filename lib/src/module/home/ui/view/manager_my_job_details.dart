import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/core/component/reactive_ui/process_notifier.dart';
import 'package:williamharri/src/core/component/reactive_ui/widget/save_button.dart';
import 'package:williamharri/src/module/assignment/controller/my_job_maneger_controller.dart';
import 'package:williamharri/src/module/assignment/model/my_jobs_manager_model.dart';
import 'package:williamharri/src/module/home/ui/view/manager_edit_scaffold_screen.dart';
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
            if (job.latestScaffold == null)
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
                  ),
                ],
              ),

              if (job.latestScaffold != null)
              Column(
                children: [
                  RSaveButton(
                    height: 52,
                    key: UniqueKey(),
                    buttonStatusNotifier: ProcessStatusNotifier(
                      initialStatus: EnabledStatus(),
                    ),
                    saveText: "Edit",
                    doneText: "Edited",
                    loadingText: "Editing...",
                    onDone: () {
                      Get.to(() => EditScaffoldScreen(job: job));
                    },
                    onSave: (ProcessStatusNotifier processNotifier) {
                      Get.to(() => EditScaffoldScreen(job: job));
                    },
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



// class EditScaffoldScreen extends StatefulWidget {
//   final JobModelManager job;

//   const EditScaffoldScreen({super.key, required this.job});

//   @override
//   State<EditScaffoldScreen> createState() => _EditScaffoldScreenState();
// }

// class _EditScaffoldScreenState extends State<EditScaffoldScreen> {
//   late TextEditingController descriptionController;
//   List<String> photos = [];
//   String signatureUrl = '';

//   @override
//   void initState() {
//     super.initState();
//     descriptionController =
//         TextEditingController(text: widget.job.latestScaffold?.description ?? '');
//     photos = List.from(widget.job.latestScaffold?.photos ?? []);
//     signatureUrl = widget.job.latestScaffold?.signatureUrl ?? '';
//   }

//   void saveChanges() {
//     // Here you can call your controller API to save changes
//     final controller = Get.find<MyJobManagerController>();
//     // controller.updateScaffold(
//     //   jobId: widget.job.id,
//     //   description: descriptionController.text,
//     //   photos: photos,
//     //   signatureUrl: signatureUrl,
//     // );

//     Get.back(); // go back to previous screen
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Scaffold'),
//         backgroundColor: Colors.black,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Description',
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: descriptionController,
//               maxLines: 5,
//               style: const TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: Colors.white12,
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//             ),
//             const SizedBox(height: 20),

//             const Text('Photos', style: TextStyle(color: Colors.white, fontSize: 18)),
//             const SizedBox(height: 8),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: photos
//                   .map((photo) => Stack(
//                         children: [
//                           Image(
//                             image: File(photo).existsSync()
//                                 ? FileImage(File(photo))
//                                 : NetworkImage(photo) as ImageProvider,
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                           ),
//                           Positioned(
//                             right: 0,
//                             top: 0,
//                             child: GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   photos.remove(photo);
//                                 });
//                               },
//                               child: const Icon(Icons.close, color: Colors.red),
//                             ),
//                           ),
//                         ],
//                       ))
//                   .toList(),
//             ),
//             const SizedBox(height: 20),

//             const Text('Signature', style: TextStyle(color: Colors.white, fontSize: 18)),
//             const SizedBox(height: 8),
//             signatureUrl.isNotEmpty
//                 ? Stack(
//                     children: [
//                       Image(
//                         image: signatureUrl.startsWith('http')
//                             ? NetworkImage(signatureUrl)
//                             : FileImage(File(signatureUrl)) as ImageProvider,
//                         width: double.infinity,
//                         height: 180,
//                         fit: BoxFit.cover,
//                       ),
//                       Positioned(
//                         right: 0,
//                         top: 0,
//                         child: GestureDetector(
//                           onTap: () => setState(() => signatureUrl = ''),
//                           child: const Icon(Icons.close, color: Colors.red),
//                         ),
//                       ),
//                     ],
//                   )
//                 : const Text('No signature', style: TextStyle(color: Colors.white54)),
//             const SizedBox(height: 32),

//             ElevatedButton(
//               onPressed: saveChanges,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFF99B07),
//                 minimumSize: const Size.fromHeight(52),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//               child: const Text('Save', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: Colors.black,
//     );
//   }
// }
