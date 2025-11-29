import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/core/base/component/image_cache/smart_network_image.dart';
import 'package:williamharri/src/module/home/controller/job_controller.dart';
import 'package:williamharri/src/module/home/controller/staff_all_jobs.controller.dart';
import 'package:williamharri/src/module/home/ui/screen/create_job.dart';
import 'package:williamharri/src/module/home/ui/screen/job_details_ui.dart';
import 'package:williamharri/src/module/profile/controller/get_profile_controller.dart';

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final jobController = Get.find<JobController>();
    final staffJobController = Get.find<StaffJobController>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.profile.value?.username ?? "Unknown",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const Text(
              "Welcome to Scaffolding app",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          if (controller.profile.value?.role == "manager")
            IconButton(
              onPressed: () {
                Get.to(() => EditJobScreen());
              },
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              child: SmartNetworkImage.circle(
                imageUrl: controller.profile.value?.avatarUrl ?? "",
                diameter: 40,
              ),
            ),
          ),
        ],
      ),

      body: Obx(() {
        final role = controller.profile.value?.role;
        if (role == null) {
          return const Center(child: CircularProgressIndicator());
        }
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
                                  // SmartNetworkImage.circle(
                                  //   imageUrl: "",
                                  //   diameter: 70,
                                  // ),
                                  Column(
                                    children: [
                                      Icon(Icons.image, size: 70),

                                      Text("data"),
                                    ],
                                  ),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                staffjob.title,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              staffjob.status,
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

                                        // COMPANY
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.business,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                staffjob.companyName,
                                                overflow: TextOverflow.ellipsis,
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
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                staffjob.location,
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
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }

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
                                children: [
                                  Column(
                                    children: [
                                      Icon(Icons.image, size: 70),
                                      Text("data"),
                                    ],
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              job.title,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              job.status,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: job.status == "active"
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),

                                        Row(
                                          children: [
                                            const Icon(Icons.business),
                                            const SizedBox(width: 8),
                                            Text(job.companyName),
                                          ],
                                        ),
                                        const SizedBox(height: 4),

                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on_outlined,
                                            ),
                                            Text(job.location),
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
