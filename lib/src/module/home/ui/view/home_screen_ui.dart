import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:williamharri/src/core/component/image_cache/smart_network_image.dart';
import 'package:williamharri/src/module/home/controller/job_controller.dart';
import 'package:williamharri/src/module/home/controller/staff_all_jobs.controller.dart';
import 'package:williamharri/src/module/home/ui/view/create_job.dart';
import 'package:williamharri/src/module/home/ui/view/job_details_ui.dart';
import 'package:williamharri/src/module/profile/controller/get_profile_controller.dart';
import 'package:williamharri/src/module/profile/controller/staff_list_controller.dart'; // <-- StaffController
import 'package:williamharri/src/module/profile/repo/profile_repo.dart';

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});
  Widget _buildJobThumbnail({
    required String? thumbnail,
    required List<String> photos,
  }) {
    String? url;

    if (thumbnail != null && thumbnail.isNotEmpty) {
      url = thumbnail;
    } else if (photos.isNotEmpty) {
      url = photos.first;
    }

    if (url == null || url.isEmpty) {
      // fallback: icon only
      return Column(
        children: const [
          Icon(Icons.image, size: 70),
          SizedBox(height: 4),
          Text("data"),
        ],
      );
    }

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(url, width: 70, height: 70, fit: BoxFit.cover),
        ),
        const SizedBox(height: 4),
        const Text("data"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final jobController = Get.find<JobController>();
    final staffJobController = Get.find<StaffJobController>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profileController.profile.value?.username ?? "Unknown",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const Text(
              "Welcome to Scaffolding app",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          // For Create job
          if (profileController.profile.value?.role == "manager")
            IconButton(
              onPressed: () async {
                if (!Get.isRegistered<StaffController>()) {
                  final profileRepo = Get.find<ProfileRepo>();
                  Get.put(StaffController(repo: profileRepo));
                }
                final result = await Get.to(() => const EditJobScreen());
                if (result == true) {
                  await jobController.fetchJobs();
                }
              },
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ObxValue((profile) {
              debugPrint("UI avatarUrl: ${profile.value?.avatarUrl}");
              return SmartNetworkImage.circle(
                key: UniqueKey(),
                imageUrl: profile.value?.avatarUrl ?? "",
                diameter: 40,
                errorWidget: Icon(Icons.person, size: 40),
              );
            }, profileController.profile),
          ),
        ],
      ),
      body: Obx(() {
        final role = profileController.profile.value?.role;
        if (role == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // ---------------- STAFF VIEW ----------------
        if (role == "staff") {
          if (staffJobController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (staffJobController.staffjobs.isEmpty) {
            return const Center(child: Text("No jobs found"));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "All Jobs",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: staffJobController.staffjobs.length,
                    itemBuilder: (context, index) {
                      final staffjob = staffJobController.staffjobs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: InkWell(
                          onTap: () =>
                              Get.to(() => JobDetailsUi(job: staffjob)),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.white),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildJobThumbnail(
                                    thumbnail: staffjob.thumbnail,
                                    photos: staffjob.photos,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                staffjob.companyName,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              staffjob.status
                                                      .toString()
                                                      .trim()
                                                      .capitalizeFirst ??
                                                  '',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    staffjob.status == "active"
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.business,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                staffjob.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on_outlined,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                staffjob.location,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }

        // ---------------- MANAGER VIEW ----------------
        if (role == "manager") {
          if (jobController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (jobController.jobs.isEmpty) {
            return const Center(child: Text("No jobs found"));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "All Jobs",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: jobController.jobs.length,
                    itemBuilder: (context, index) {
                      final job = jobController.jobs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: InkWell(
                          onTap: () => Get.to(() => JobDetailsUi(job: job)),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.white),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildJobThumbnail(
                                    thumbnail: job.thumbnail,
                                    photos: job.photos,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                job.companyName,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              job.status
                                                      .toString()
                                                      .trim()
                                                      .capitalizeFirst ??
                                                  '',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    job.status.toLowerCase() ==
                                                        "active"
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.business,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: Text(
                                                job.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),

                                        // LOCATION
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on_outlined,
                                              size: 18,
                                            ),
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

                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }

        return const Center(child: Text("Unknown role"));
      }),
    );
  }
}
