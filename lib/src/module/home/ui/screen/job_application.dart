import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/module/home/ui/widget/return_home.dart';


class JobApplicationScreen extends StatefulWidget {
  const JobApplicationScreen({super.key});

  @override
  State<JobApplicationScreen> createState() => _JobApplicationScreenState();
}

class _JobApplicationScreenState extends State<JobApplicationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Job Application",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job title
            // const Text(
            //   "Job title",
            //   style: TextStyle(color: Colors.white70, fontSize: 15),
            // ),
            // const SizedBox(height: 8),
            // TextField(
            //   controller: _titleController,
            //   style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            //   decoration: const InputDecoration(
            //     hintText: "Real estate agent",
            //   ),
            // ),
            const SizedBox(height: 24),

            // Job description
            const Text(
              "Job description",
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 8,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: "Write here",
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 32),

            // Upload photo section
            const Text(
              "Upload photo",
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F1F),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    color: Colors.white54,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Browse your files",
                    style: TextStyle(color: Colors.white54, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Choose file",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80), // Space for fixed submit button
          ],
        ),
      ),

      // Fixed orange Submit button at bottom
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: FloatingActionButton.extended(
            onPressed: () {
              Get.to (() => ScaffoldInstalledScreen());
            },
            backgroundColor: Colors.orange,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            label: const Text(
              "Submit",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}