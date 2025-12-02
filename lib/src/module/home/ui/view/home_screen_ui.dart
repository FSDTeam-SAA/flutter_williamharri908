import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/core/component/image_cache/smart_network_image.dart';
import 'package:williamharri/src/module/home/controller/job_controller.dart';
import 'package:williamharri/src/module/home/controller/staff_all_jobs.controller.dart';
import 'package:williamharri/src/module/home/ui/view/create_job.dart';
import 'package:williamharri/src/module/home/ui/view/job_details_ui.dart';
import 'package:williamharri/src/module/profile/controller/get_profile_controller.dart';
import 'package:williamharri/src/module/profile/controller/staff_list_controller.dart';
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
        backgroundColor: Colors.transparent,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profileController.profile.value?.name ?? "Unknown",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const Text(
              "Welcome to Scaffolding app",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          // ▶ Manager can create job
          if (profileController.profile.value?.role == "manager")
            IconButton(
              onPressed: () async {
                // load staff list before open screen
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() {
              return SmartNetworkImage.circle(
                key: UniqueKey(),
                imageUrl: profileController.profile.value?.avatarUrl ?? "",
                diameter: 40,
                errorWidget: const Icon(Icons.person, size: 40),
              );
            }),
          ),
        ],
      ),
      body: Obx(() {
        final role = profileController.profile.value?.role;

        if (role == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (role == "staff") {
          return RefreshIndicator(
            onRefresh: () async => staffJobController.fetchJobs(),
            child: staffJobController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : staffJobController.staffjobs.isEmpty
                ? const Center(child: Text("No jobs found"))
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "All Jobs",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: staffJobController.staffjobs.length,
                            itemBuilder: (context, index) {
                              final staffjob =
                                  staffJobController.staffjobs[index];

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: InkWell(
                                  onTap: () =>
                                      Get.to(() => JobDetailsUi(job: staffjob)),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    staffjob
                                                            .status
                                                            .capitalize ??
                                                        "",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          staffjob.status
                                                                  .toLowerCase() ==
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
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      staffjob.title,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.location_on,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      staffjob.location,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        }
        if (role == "manager") {
          return RefreshIndicator(
            onRefresh: () async => jobController.fetchJobs(),
            child: jobController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : jobController.jobs.isEmpty
                ? const Center(child: Text("No jobs found"))
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "All Jobs",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: jobController.jobs.length,
                            itemBuilder: (context, index) {
                              final job = jobController.jobs[index];

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: InkWell(
                                  onTap: () =>
                                      Get.to(() => JobDetailsUi(job: job)),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
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
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    job.status.capitalize ?? "",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          job.status
                                                                  .toLowerCase() ==
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
                                                  Expanded(
                                                    child: Text(
                                                      job.title,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.location_on,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      job.location,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        }

        return const Center(child: Text("Unknown role"));
      }),
    );
  }
}
