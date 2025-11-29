import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:williamharri/src/module/assignment/model/get_my_scaffold_model.dart';

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

  final List<File> newlyAddedPhotos = [];
  File? newSignatureFile;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    descController = TextEditingController(text: widget.job.description);
  }

  @override
  void dispose() {
    descController.dispose();
    super.dispose();
  }

  bool _isNetworkUrl(String path) =>
      path.startsWith('http://') || path.startsWith('https://');

  bool _isValidLocalFile(String path) => File(path).existsSync();

  /// Pick MULTIPLE photos
  Future<void> pickMultiplePhotos() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage(
      imageQuality: 85,
    );

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        newlyAddedPhotos.addAll(pickedFiles.map((e) => File(e.path)));
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${pickedFiles.length} photo(s) added"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  /// Pick signature (single)
  Future<void> pickSignature() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      setState(() => newSignatureFile = File(image.path));
    }
  }

  void removeNewPhoto(int index) =>
      setState(() => newlyAddedPhotos.removeAt(index));

  void clearNewSignature() => setState(() => newSignatureFile = null);

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
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() => isEdit = !isEdit),
            icon: Icon(
              isEdit ? Icons.close : Icons.edit_note,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Company
            Text(
              widget.job.job.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.job.job.companyName,
              style: const TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 20),

            // Description
            const Text(
              "Description",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            isEdit
                ? TextField(
                    controller: descController,
                    maxLines: 6,
                    style: const TextStyle(color: Colors.white70),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white12,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                : Text(
                    descController.text.isEmpty
                        ? "No description"
                        : descController.text,
                    style: const TextStyle(color: Colors.white70),
                  ),

            const SizedBox(height: 30),

            // PHOTOS
            const Text(
              "Photos",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 190,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.job.photos.length + newlyAddedPhotos.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  // Existing photos from server
                  if (index < widget.job.photos.length) {
                    final String path = widget.job.photos[index];
                    return _buildImageItem(
                      url: _isNetworkUrl(path) ? path : null,
                      localFile: _isNetworkUrl(path)
                          ? null
                          : (_isValidLocalFile(path) ? File(path) : null),
                      onRemove: isEdit
                          ? () => setState(
                              () => widget.job.photos.removeAt(index),
                            )
                          : null,
                    );
                  }

                  // Newly added photos
                  final int newIndex = index - widget.job.photos.length;
                  return _buildImageItem(
                    localFile: newlyAddedPhotos[newIndex],
                    onRemove: isEdit ? () => removeNewPhoto(newIndex) : null,
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // SIGNATURE
            const Text(
              "Signature",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Center(child: _buildSignatureWidget()),

            const SizedBox(height: 40),

            // ACTION BUTTONS (only in edit mode)
            if (isEdit)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: pickMultiplePhotos,
                      icon: const Icon(
                        Icons.photo_library_outlined,
                        color: Color(0xFFF99B07),
                      ),
                      label: const Text(
                        "Add Photos",
                        style: TextStyle(
                          color: Color(0xFFF99B07),
                          fontSize: 16,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        side: const BorderSide(
                          color: Color(0xFFF99B07),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: pickSignature,
                      icon: const Icon(Icons.draw, color: Color(0xFFF99B07)),
                      label: const Text(
                        "Signature",
                        style: TextStyle(
                          color: Color(0xFFF99B07),
                          fontSize: 16,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        side: const BorderSide(
                          color: Color(0xFFF99B07),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            if (isEdit) const SizedBox(height: 20),

            // SAVE BUTTON
            if (isEdit)
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Upload images here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Saved successfully!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    setState(() => isEdit = false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF99B07),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildImageItem({
    String? url,
    File? localFile,
    VoidCallback? onRemove,
  }) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 160,
            height: 160,
            child: localFile != null
                ? Image.file(localFile, fit: BoxFit.cover)
                : (url != null
                      ? Image.network(
                          url,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, progress) =>
                              progress == null
                              ? child
                              : const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFF99B07),
                                  ),
                                ),
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.red[900],
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey[800],
                          child: const Icon(Icons.image, color: Colors.white54),
                        )),
          ),
        ),
        if (onRemove != null)
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSignatureWidget() {
    if (newSignatureFile != null) {
      return _buildImageItem(
        localFile: newSignatureFile,
        onRemove: isEdit ? clearNewSignature : null,
      );
    }

    if (widget.job.signatureUrl.isNotEmpty) {
      final String path = widget.job.signatureUrl;
      return _buildImageItem(
        url: _isNetworkUrl(path) ? path : null,
        localFile: _isNetworkUrl(path)
            ? null
            : (_isValidLocalFile(path) ? File(path) : null),
        onRemove: isEdit ? () => setState(() => widget.job.signatureUrl) : null,
      );
    }

    return Container(
      width: 240,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.draw_outlined, color: Colors.white54, size: 50),
          SizedBox(height: 8),
          Text("No signature", style: TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }
}
