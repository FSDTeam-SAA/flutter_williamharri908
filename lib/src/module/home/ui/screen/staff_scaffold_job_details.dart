import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/module/assignment/model/get_my_scaffold_model.dart';
import 'package:williamharri/src/module/home/ui/widget/pdf_view_screen.dart';

class StaffScaffoldJobDetails extends StatefulWidget {
  final GetMyScaffoldModel job;

  const StaffScaffoldJobDetails({super.key, required this.job});

  @override
  State<StaffScaffoldJobDetails> createState() =>
      _StaffScaffoldJobDetailsState();
}

class _StaffScaffoldJobDetailsState extends State<StaffScaffoldJobDetails> {
  bool isEdit = false;

  late TextEditingController descController;
  List<String> photos = [];

  @override
  void initState() {
    super.initState();
    descController = TextEditingController(text: widget.job.description);
    photos = List<String>.from(widget.job.photos);
  }
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf'],
      type: FileType.custom,
    );

    if (result != null) {
      photos.add(result.files.single.path!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "Job Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isEdit = !isEdit;
              });
            },
            icon: Icon(
              isEdit ? Icons.close : Icons.edit_note,
              color: Colors.white,
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete_forever_outlined, color: Colors.red),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.job.job.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Description",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            isEdit
                ? TextField(
                    controller: descController,
                    maxLines: 8,
                    style: const TextStyle(color: Colors.white70),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white12,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                : Text(
                    descController.text,
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, height: 1.4),
                  ),

            const SizedBox(height: 25),

            const Text(
              "Photos",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: photos.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, index) {
                  final filePath = photos[index];

                  final isPDF = filePath.toLowerCase().endsWith(".pdf");

                  if (isPDF) {
                    return InkWell(
                      onTap: () =>
                          Get.to(() => PdfViewerScreen(filePath: filePath)),
                      child: Container(
                        width: 160,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white38),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ),
                    );
                  }

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(filePath),
                      width: 160,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 160,
                        height: 150,
                        color: Colors.grey,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            if (isEdit)
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: pickFile,
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text("Add Photo +"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: Color(0xFFF99B07),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),

            SizedBox(height: 20),
            if (isEdit)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF99B07),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  onPressed: () {
                    // TODO: API call to update job details
                    setState(() {
                      isEdit = false;
                    });
                  },

                  child: const Text(
                    "Done",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
