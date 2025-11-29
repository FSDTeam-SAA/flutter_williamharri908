import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/module/assignment/controller/my_scaffold_job_controller.dart';
import 'package:williamharri/src/module/assignment/model/get_my_scaffold_model.dart';
import 'package:williamharri/src/module/assignment/repo/submit_repo.dart';
import 'package:williamharri/src/module/home/ui/screen/staff_scaffold_job_details.dart';

class StaffMyJobs extends StatelessWidget {
  const StaffMyJobs({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      MyScaffoldJobController(submitRepo: Get.find<SubmitRepo>()),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Job Finder",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            Text(
              "Welcome to Scaffolding app",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.jobs.isEmpty) {
          return const Center(child: Text("No jobs found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.jobs.length,
          itemBuilder: (context, index) {
            final GetMyScaffoldModel job = controller.jobs[index];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                      Column(
                        children: const [
                          Icon(Icons.image, size: 70),
                          Text("data"),
                        ],
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
                            Text(
                              job.job.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 4),
                            Text(
                              job.job.location,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
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
      }),
    );
  }
}
