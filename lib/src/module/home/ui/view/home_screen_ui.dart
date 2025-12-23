import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/core/component/image_cache/smart_network_image.dart';
import 'package:williamharri/src/module/home/controller/job_controller.dart';
import 'package:williamharri/src/module/home/controller/staff_all_jobs.controller.dart';
import 'package:williamharri/src/module/home/ui/view/create_job.dart';
import 'package:williamharri/src/module/home/ui/view/job_details_ui.dart';
import 'package:williamharri/src/module/profile/controller/profile_data_controller.dart';
import 'package:williamharri/src/module/profile/controller/staff_list_controller.dart';
import 'package:williamharri/src/module/profile/repo/profile_repo.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView>
    with WidgetsBindingObserver {
  final profileController = Get.find<ProfileDataController>();
  final jobController = Get.find<JobController>();
  final staffJobController = Get.find<StaffJobController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initial load for staff
    if (profileController.profile.value?.role == "staff") {
      staffJobController.fetchJobs();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      final role = profileController.profile.value?.role;
      if (role == "staff") {
        staffJobController.fetchJobs();
      } else if (role == "manager" || role == "admin") {
        jobController.fetchJobs();
      }
    }
  }

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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
          // Manager can create job
          if (profileController.profile.value?.role == "manager" ||
              profileController.profile.value?.role == "admin")
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

        // Shared RefreshIndicator logic
        Widget buildJobList({
          required Future<void> Function() onRefresh,
          required bool isLoading,
          required List<dynamic> jobs,
          required Widget Function(BuildContext, int) itemBuilder,
        }) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : jobs.isEmpty
                ? Center(
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 200),
                        Text("No jobs found", textAlign: TextAlign.center),
                      ],
                    ),
                  )
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
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: jobs.length,
                            itemBuilder: itemBuilder,
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        }

        if (role == "staff") {
          return buildJobList(
            onRefresh: () async => staffJobController.fetchJobs(),
            isLoading: staffJobController.isLoading.value,
            jobs: staffJobController.staffjobs,
            itemBuilder: (context, index) {
              final staffjob = staffJobController.staffjobs[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: InkWell(
                  onTap: () => Get.to(() => JobDetailsUi(job: staffjob)),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildJobThumbnail(
                          thumbnail: staffjob.thumbnail,
                          photos: staffjob.photos,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  Text(
                                    staffjob.status == "assignedToStaffs"
                                        ? "Assigned"
                                        : staffjob.status.capitalize ?? "",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: getStatusColor(staffjob.status),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.business, size: 18),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      staffjob.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 18),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      staffjob.location,
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
                  ),
                ),
              );
            },
          );
        }

        if (role == "manager" || role == "admin") {
          return buildJobList(
            onRefresh: () async => jobController.fetchJobs(),
            isLoading: jobController.isLoading.value,
            jobs: jobController.jobs,
            itemBuilder: (context, index) {
              final job = jobController.jobs[index];
              debugPrint(job.status);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: InkWell(
                  onTap: () => Get.to(() => JobDetailsUi(job: job)),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  // Text(
                                  //   job.status.capitalize ?? "",
                                  //   style: TextStyle(
                                  //     fontSize: 16,
                                  //     fontWeight: FontWeight.w600,
                                  //     color: getStatusColor(job.status),
                                  //   ),
                                  // ),
                                  Text(
                                    job.status == "assignedToStaffs"
                                        ? "Assigned"
                                        : job.status.capitalize ?? "",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: getStatusColor(job.status),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.business, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      job.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 18),
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
                  ),
                ),
              );
            },
          );
        }

        return const Center(child: Text("Unknown role"));
      }),
    );
  }
}

Color getStatusColor(String? status) {
  if (status == null) return Colors.grey;

  switch (status.toLowerCase()) {
    case 'completed':
      return Colors.green;
    case 'accepted':
      return Colors.greenAccent;
    case 'pending':
      return Colors.orange;
    case 'rejected':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
