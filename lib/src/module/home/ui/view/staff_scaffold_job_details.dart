import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/module/assignment/model/get_my_scaffold_model.dart';
import 'package:williamharri/src/module/home/controller/staff_upload_scaffold_controller.dart';
import 'package:williamharri/src/module/home/ui/widget/image_view_screen.dart';

class StaffScaffoldJobDetails extends StatelessWidget {
  final GetMyScaffoldModel job;

  const StaffScaffoldJobDetails({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StaffScaffoldJobDetailsController(job));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Job Details",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),

        actions: [
          Obx(
            () => IconButton(
              onPressed: () => controller.isEdit.toggle(),
              icon: Icon(
                controller.isEdit.value ? Icons.close : Icons.edit_note,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),

      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Company
              Text(
                job.job.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                job.job.companyName,
                style: const TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 20),

              // Description
              const Text(
                "Description",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 10),

              controller.isEdit.value
                  ? TextField(
                      controller: controller.descController,
                      maxLines: 6,
                      style: const TextStyle(color: Colors.white70),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )
                  : Text(
                      controller.descController.text.isEmpty
                          ? "No description"
                          : controller.descController.text,
                      style: const TextStyle(color: Colors.white70),
                    ),

              const SizedBox(height: 30),

              // Photos
              const Text(
                "Photos",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 190,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      job.photos.length + controller.newlyAddedPhotos.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    // Existing photos
                    if (index < job.photos.length) {
                      final path = job.photos[index];

                      return _photoItem(
                        controller,
                        url: controller.isNetworkUrl(path) ? path : null,
                        local: controller.isNetworkUrl(path)
                            ? null
                            : (controller.isValidLocalFile(path)
                                  ? File(path)
                                  : null),
                        onRemove: controller.isEdit.value
                            ? () => controller.removeExistingPhoto(index)
                            : null,
                      );
                    }
                    final newIndex = index - job.photos.length;
                    return _photoItem(
                      controller,
                      local: controller.newlyAddedPhotos[newIndex],
                      onRemove: controller.isEdit.value
                          ? () => controller.removeNewPhoto(newIndex)
                          : null,
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              // Signature
              const Text(
                "Signature",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 12),

              Center(child: _signatureWidget(controller)),

              const SizedBox(height: 40),

              // Edit Mode Buttons
              if (controller.isEdit.value)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: controller.pickMultiplePhotos,
                        icon: const Icon(
                          Icons.photo_library_outlined,
                          color: Color(0xFFF99B07),
                        ),
                        label: const Text(
                          "Add Photos",
                          style: TextStyle(
                            color: Color(0xFFF99B07),
                            fontSize: 16,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          side: const BorderSide(
                            color: Color(0xFFF99B07),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: controller.pickSignature,
                        icon: const Icon(Icons.draw, color: Color(0xFFF99B07)),
                        label: const Text(
                          "Signature",
                          style: TextStyle(
                            color: Color(0xFFF99B07),
                            fontSize: 16,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          side: const BorderSide(
                            color: Color(0xFFF99B07),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 20),

              if (controller.isEdit.value)
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: controller.saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF99B07),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
Widget _photoItem(
  StaffScaffoldJobDetailsController controller, {
  String? url,
  File? local,
  VoidCallback? onRemove,
}) {
  final imagePath = local?.path ?? url;

  return Stack(
    children: [
      GestureDetector(
        onTap: () {
          if (imagePath != null) {
            Get.to(() => FullImageViewScreen(imageUrl: imagePath));
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 160,
            height: 160,
            child: local != null
                ? Image.file(local, fit: BoxFit.cover)
                : (url != null
                      ? Image.network(
                          url,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, progress) =>
                              progress == null
                                  ? child
                                  : const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFFF99B07),
                                      ),
                                    ),
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.transparent,
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey[800],
                          child: const Icon(Icons.image, color: Colors.white54),
                        )),
          ),
        ),
      ),
      if (onRemove != null)
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
        ),
    ],
  );
}
Widget _signatureWidget(StaffScaffoldJobDetailsController controller) {
  // New signature
  if (controller.newSignatureFile.value != null) {
    return GestureDetector(
      onTap: () => Get.to(() => FullImageViewScreen(
          imageUrl: controller.newSignatureFile.value!.path)),
      child: _photoItem(
        controller,
        local: controller.newSignatureFile.value,
        onRemove: controller.isEdit.value ? controller.clearNewSignature : null,
      ),
    );
  }

  // Old signature
  if (controller.job.signatureUrl.isNotEmpty) {
    final path = controller.job.signatureUrl;

    return GestureDetector(
      onTap: () => Get.to(() => FullImageViewScreen(imageUrl: path)),
      child: _photoItem(
        controller,
        url: controller.isNetworkUrl(path) ? path : null,
        local: controller.isNetworkUrl(path)
            ? null
            : (controller.isValidLocalFile(path) ? File(path) : null),
        onRemove: controller.isEdit.value ? controller.clearNewSignature : null,
      ),
    );
  }

  // No signature
  return Container(
    width: 240,
    height: 140,
    decoration: BoxDecoration(
      color: Colors.white12,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white24),
    ),
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.draw_outlined, color: Colors.white54, size: 50),
        SizedBox(height: 8),
        Text("No signature", style: TextStyle(color: Colors.white54)),
      ],
    ),
  );
}

