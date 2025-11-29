import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/module/home/model/job_cart_model.dart';
import 'package:williamharri/src/module/home/ui/screen/rams_documents.dart';
import 'package:williamharri/src/module/home/ui/widget/image_view_screen.dart';
import 'package:williamharri/src/module/profile/controller/get_profile_controller.dart';

class JobDetailsUi extends StatelessWidget {
  final JobModel job;

  const JobDetailsUi({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    // final jobController = Get.find<JobController>();
    // final staffJobController = Get.find<StaffJobController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Details"),
        backgroundColor: Colors.transparent,
        actions: [
          if (controller.profile.value?.role == "manager")
            IconButton(
              onPressed: () {
                Get.to(() => Scaffold());
              },
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          if (controller.profile.value?.role == "manager")
            IconButton(
              icon: Icon(Icons.delete_forever_outlined, color: Colors.red),
              onPressed: () {},
            ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // HEADER INFO
            Row(
              children: [
                const CircleAvatar(radius: 35),
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
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
                          Text(job.companyName),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Location
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined),
                          const SizedBox(width: 8),
                          Text(job.location),
                        ],
                      ),

                      const SizedBox(height: 8),
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

                        return InkWell(
                          onTap: () {
                            Get.to(
                              () => FullImageViewScreen(imageUrl: photoUrl),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade300,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  photoUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 20),

            // add heignt
            if (controller.profile.value?.role == "staff")
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF99B07),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Get.to(() => RamsDocumentScreen());
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
    );
  }
}
