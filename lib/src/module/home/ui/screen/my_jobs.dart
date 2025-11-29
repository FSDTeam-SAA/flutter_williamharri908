import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/module/assignment/controller/my_job_maneger_controller.dart';
import 'package:williamharri/src/module/assignment/controller/my_scaffold_job_controller.dart';
import 'package:williamharri/src/module/assignment/model/my_jobs_manager_model.dart';
import 'package:williamharri/src/module/assignment/model/get_my_scaffold_model.dart';
import 'package:williamharri/src/module/assignment/repo/application_repo.dart';
import 'package:williamharri/src/module/home/ui/screen/manager_my_job_details.dart';
import 'package:williamharri/src/module/profile/controller/get_profile_controller.dart';
import 'package:williamharri/src/module/home/ui/screen/staff_scaffold_job_details.dart';

class StaffMyJobs extends StatelessWidget {
  const StaffMyJobs({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();

    // Manager Controller
    final managerController = Get.put(
      MyJobManagerController(submitRepo: Get.find<SubmitRepo>()),
    );

    // Staff Controller
    final staffController = Get.put(
      MyScaffoldJobController(submitRepo: Get.find<SubmitRepo>()),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profileController.profile.value?.username ?? "User",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const Text(
              "My Jobs",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),

      body: Obx(() {
        final role = profileController.profile.value?.role;

        if (role == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (role == "staff") {
          if (staffController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (staffController.jobs.isEmpty) {
            return const Center(child: Text("No jobs found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: staffController.jobs.length,
            itemBuilder: (context, index) {
              final GetMyScaffoldModel job = staffController.jobs[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: InkWell(
                  onTap: () {
                    Get.to(() => StaffScaffoldJobDetails(job: job));
                  },

                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Column(
                          children: [Icon(Icons.image, size: 70), Text("data")],
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
                                      job.job.companyName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    job.scaffoldStatus,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.business, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    job.job.title,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    job.job.location,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
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

        // --------------------------------------------------
        if (role == "manager") {
          if (managerController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (managerController.jobs.isEmpty) {
            return const Center(child: Text("No jobs found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: managerController.jobs.length,
            itemBuilder: (context, index) {
              final JobModelManager job = managerController.jobs[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => JobDetailsScreen(job: job),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey.shade300,
                        child: job.photos.isNotEmpty
                            ? Image.network(job.photos.first, fit: BoxFit.cover)
                            : const Icon(Icons.image, size: 40),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  job.companyName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                // Text(
                                //   job.scaffoldStatus ?? "Active",
                                //   style: const TextStyle(
                                //     fontSize: 16,
                                //     fontWeight: FontWeight.w600,
                                //   ),
                                // ),
                                Text(
                                  job.jobStatus,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.business,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(job.title, style: TextStyle(fontSize: 15)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  job.location,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
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
              );
            },
          );
        }

        return const Center(child: Text("Unknown role"));
      }),
    );
  }
}
