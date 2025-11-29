// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:williamharri/src/module/assignment/controller/my_job_maneger_controller.dart';
// import 'package:williamharri/src/module/assignment/model/my_jobs_manager_model.dart';
// import 'package:williamharri/src/module/assignment/repo/submit_repo.dart';

// class ManagerMyJobsScreen extends StatelessWidget {
//   const ManagerMyJobsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(
//       MyJobManagerController(submitRepo: Get.find<SubmitRepo>()),
//     );

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Posted Jobs"),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (controller.jobs.isEmpty) {
//           return const Center(child: Text("No jobs found"));
//         }

//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: controller.jobs.length,
//           itemBuilder: (context, index) {
//             final JobModelManager job = controller.jobs[index];

//             return Container(
//               margin: const EdgeInsets.only(bottom: 12),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.grey),
//               ),
//               child: Row(
//                 children: [
//                   // Image preview
//                   Container(
//                     width: 60,
//                     height: 60,
//                     color: Colors.grey.shade300,
//                     child: job.photos.isNotEmpty
//                         ? Image.network(job.photos.first, fit: BoxFit.cover)
//                         : const Icon(Icons.image, size: 40),
//                   ),

//                   const SizedBox(width: 12),

//                   // Text details
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           job.companyName,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(job.title),
//                         const SizedBox(height: 4),
//                         Text(job.location),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
