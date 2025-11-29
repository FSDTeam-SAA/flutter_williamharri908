import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:williamharri/src/module/home/model/job_cart_model.dart';
import 'package:williamharri/src/module/home/ui/screen/rams_documents.dart';
import 'package:williamharri/src/module/profile/controller/get_profile_controller.dart';
import 'package:williamharri/src/module/home/controller/job_controller.dart';
import 'package:williamharri/src/module/home/ui/screen/edit_job.dart';

// ⬇️ add these imports
import 'package:williamharri/src/module/profile/controller/staff_list_controller.dart';
import 'package:williamharri/src/module/profile/repo/profile_repo.dart';

class JobDetailsUi extends StatelessWidget {
  final JobModel job;

  const JobDetailsUi({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final jobsController = Get.find<JobController>();

    // ---------------- THUMBNAIL IMAGE ----------------
    ImageProvider? avatarImage;
    if (job.thumbnail != null && job.thumbnail!.isNotEmpty) {
      avatarImage = NetworkImage(job.thumbnail!);
    } else if (job.photos.isNotEmpty) {
      avatarImage = NetworkImage(job.photos.first);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Details"),
        backgroundColor: Colors.transparent,
        actions: [
          if (controller.profile.value?.role == "manager")
            IconButton(
              onPressed: () {
                // ✅ make sure StaffController exists before opening EditJobScreen
                if (!Get.isRegistered<StaffController>()) {
                  final profileRepo = Get.find<ProfileRepo>();
                  Get.put(StaffController(repo: profileRepo));
                }

                Get.to(() => EditJobScreen(job: job));
              },
              icon: const Icon(
                Icons.edit_outlined,
                color: Colors.orange,
              ),
            ),
          if (controller.profile.value?.role == "manager")
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

                if (confirm != true) return;

                await jobsController.deleteJob(job.id);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
        
              // HEADER INFO
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: avatarImage == null
                        ? Colors.blue
                        : Colors.transparent,
                    backgroundImage: avatarImage,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title + Price
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                job.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "£ ${job.price}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
        
                        const SizedBox(height: 10),
        
                        // Company
                        Row(
                          children: [
                            const Icon(Icons.business),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                job.companyName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
        
                        const SizedBox(height: 8),
        
                        // Location
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                job.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        
              const SizedBox(height: 20),
        
              // DESCRIPTION
              const Text(
                "Description",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Text(
                job.description.isEmpty
                    ? "No description available"
                    : job.description,
                textAlign: TextAlign.justify,
                maxLines: 40,
                style: const TextStyle(fontSize: 14),
              ),
        
              const SizedBox(height: 20),
        
              // PHOTOS
              const Text(
                "Photos",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: job.photos.isEmpty
                    ? const Text("No photos available")
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: job.photos.length,
                  itemBuilder: (_, index) {
                    final photoUrl = job.photos[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade300,
                        ),
                        child: Image.network(photoUrl, fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
              ),
        
              const SizedBox(height: 20),
        
              if (controller.profile.value?.role == "staff")
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF99B07),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Get.to(() => RamsDocumentScreen(job: job));
                        },
                        child: const Text(
                          "Accept",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
