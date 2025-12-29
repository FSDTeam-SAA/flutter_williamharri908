import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/core/component/reactive_ui/process_notifier.dart';
import 'package:williamharri/src/module/assignment/model/my_jobs_manager_model.dart';
import 'package:williamharri/src/module/home/controller/manager_update_scaffold_controller.dart';

class EditScaffoldScreen extends StatelessWidget {
  final JobModelManager job;

  const EditScaffoldScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ManagerUpdateScaffoldController(job));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Scaffold'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Obx(
        () => Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.descController,
                    maxLines: 5,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white12,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Photos',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // Existing photos (from server)
                      for (int i = 0; i < job.photos.length; i++)
                        Stack(
                          children: [
                            Image.network(
                              job.photos[i],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () => controller.removeExistingPhoto(i),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      // Newly added photos
                      for (
                        int i = 0;
                        i < controller.newlyAddedPhotos.length;
                        i++
                      )
                        Stack(
                          children: [
                            Image.file(
                              controller.newlyAddedPhotos[i],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () => controller.removeNewPhoto(i),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: controller.pickMultiplePhotos,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF99B07),
                    ),
                    child: const Text(
                      'Update Photos',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Signature',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  if (controller.newSignatureFile.value != null)
                    Stack(
                      children: [
                        Image.file(
                          controller.newSignatureFile.value!,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: controller.clearNewSignature,
                            child: const Icon(Icons.close, color: Colors.red),
                          ),
                        ),
                      ],
                    )
                  else if ((job.latestScaffold?.signatureUrl ?? '').isNotEmpty)
                    Image.network(
                      job.latestScaffold!.signatureUrl,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    )
                  else
                    const Text(
                      'No signature',
                      style: TextStyle(color: Colors.white54),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.pickSignature,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF99B07),
                    ),
                    child: const Text(
                      'Update Signature',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: controller.saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF99B07),
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (controller.processStatusNotifier.status is LoadingStatus)
              Container(
                color: Colors.black38,
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFFF99B07)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
