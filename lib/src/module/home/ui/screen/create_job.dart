import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:williamharri/src/core/constants/api_endpoints.dart';
import 'package:williamharri/src/core/services/app_pigeon/app_pigeon.dart';
import 'package:williamharri/src/module/home/model/create_job_model.dart';
import 'package:williamharri/src/module/profile/controller/staff_list_controller.dart';
import 'package:williamharri/src/module/profile/model/profile_model.dart';

class EditJobScreen extends StatefulWidget {
  const EditJobScreen({
    super.key,
    this.jobId, // null = create mode, not null = edit mode
    this.job,   // existing job data to prefill (optional)
  });

  final String? jobId;
  final CreateJobModel? job;

  @override
  State<EditJobScreen> createState() => _EditJobScreenState();
}

class _EditJobScreenState extends State<EditJobScreen> {
  final staffController = Get.find<StaffController>();
  final AppPigeon appPigeon = Get.find<AppPigeon>();

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _companyController;
  late final TextEditingController _designationController;
  late final TextEditingController _locationController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;

  File? _thumbnailFile;
  final List<File> _photos = [];

  bool _isSaving = false;

  final ImagePicker _picker = ImagePicker();

  bool get _isEditing => widget.jobId != null;

  @override
  void initState() {
    super.initState();

    _companyController =
        TextEditingController(text: widget.job?.companyName ?? '');
    _designationController =
        TextEditingController(text: widget.job?.title ?? '');
    _locationController =
        TextEditingController(text: widget.job?.location ?? '');
    _priceController =
        TextEditingController(text: widget.job?.price.toString() ?? '');
    _descriptionController =
        TextEditingController(text: widget.job?.description ?? '');
  }

  @override
  void dispose() {
    _companyController.dispose();
    _designationController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickThumbnail() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _thumbnailFile = File(picked.path);
      });
    }
  }

  Future<void> _addPhoto() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _photos.add(File(picked.path));
      });
    }
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final company = _companyController.text.trim();
    final designation = _designationController.text.trim();
    final location = _locationController.text.trim();
    final price = _priceController.text.trim();
    final description = _descriptionController.text.trim();
    final staff = staffController.selectedStaff.value;

    //  Backend says "assigneTo is required" -> force user to select a staff
    if (staff == null || staff.id == null) {
      Get.snackbar(
        'Assign staff',
        'Please select a staff to assign this job to.',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      String jobId;

      if (_isEditing) {
        jobId = widget.jobId!;
        await _updateJob(
          jobId: jobId,
          company: company,
          designation: designation,
          location: location,
          price: price,
          description: description,
          assigneeId: staff.id!,   // 👈 send assigneTo for update
          thumbnail: _thumbnailFile,
          photos: _photos,
        );
      } else {
        jobId = await _createJob(
          company: company,
          designation: designation,
          location: location,
          price: price,
          description: description,
          assigneeId: staff.id!,   // 👈 send assigneTo for create
          thumbnail: _thumbnailFile,
          photos: _photos,
        );
      }

      Get.snackbar(
        'Success',
        _isEditing ? 'Job updated successfully' : 'Job created successfully',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
      );

      Navigator.pop(context, true);
    } catch (e, st) {
      debugPrint('Error while saving job: $e\n$st');
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // API CALLS (using AppPigeon + Dio, so auth is reused automatically)
  // ---------------------------------------------------------------------------

  /// POST /jobs/
  Future<String> _createJob({
    required String company,
    required String designation,
    required String location,
    required String price,
    required String description,
    required String assigneeId, // <-- assigneTo required by backend
    File? thumbnail,
    List<File> photos = const [],
  }) async {
    final cleanedPrice = price.replaceAll('\$', '').trim();

    final formDataMap = <String, dynamic>{
      'companyName': company,
      'title': designation,
      'location': location,
      'price': cleanedPrice,
      'description': description,
      //  this matches backend requirement: "assigneTo is required"
      'assigneTo': assigneeId,
    };

    if (thumbnail != null) {
      formDataMap['thumbnail'] =
          dio.MultipartFile.fromFileSync(thumbnail.path);
    }

    if (photos.isNotEmpty) {
      formDataMap['photos'] = photos
          .map((f) => dio.MultipartFile.fromFileSync(f.path))
          .toList();
    }

    final formData = dio.FormData.fromMap(formDataMap);

    try {
      final response = await appPigeon.post(
        ApiEndpoints.createJob,
        data: formData,
      );

      final body = response.data as Map<String, dynamic>;
      final id = body['data']?['id'] ?? body['id'];

      if (id == null) {
        throw Exception('Create job successful but no id returned');
      }

      return id.toString();
    } on dio.DioException catch (e) {
      debugPrint('createJob status: ${e.response?.statusCode}');
      debugPrint('createJob data  : ${e.response?.data}');

      String msg;
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        msg = data['message'].toString();
      } else {
        msg =
        'Failed to create job (status: ${e.response?.statusCode ?? 'unknown'})';
      }
      throw Exception(msg);
    }
  }

  /// PATCH /jobs/{id}
  Future<void> _updateJob({
    required String jobId,
    required String company,
    required String designation,
    required String location,
    required String price,
    required String description,
    required String assigneeId, // <-- also send assigneTo on update
    File? thumbnail,
    List<File> photos = const [],
  }) async {
    final cleanedPrice = price.replaceAll('\$', '').trim();

    final formDataMap = <String, dynamic>{
      'companyName': company,
      'title': designation,
      'location': location,
      'price': cleanedPrice,
      'description': description,
      'assigneTo': assigneeId,
    };

    if (thumbnail != null) {
      formDataMap['thumbnail'] =
          dio.MultipartFile.fromFileSync(thumbnail.path);
    }

    if (photos.isNotEmpty) {
      formDataMap['photos'] = photos
          .map((f) => dio.MultipartFile.fromFileSync(f.path))
          .toList();
    }

    final formData = dio.FormData.fromMap(formDataMap);

    try {
      await appPigeon.patch(
        ApiEndpoints.updateJob(jobId),
        data: formData,
      );
    } on dio.DioException catch (e) {
      debugPrint('updateJob status: ${e.response?.statusCode}');
      debugPrint('updateJob data  : ${e.response?.data}');

      String msg;
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        msg = data['message'].toString();
      } else {
        msg =
        'Failed to update job (status: ${e.response?.statusCode ?? 'unknown'})';
      }
      throw Exception(msg);
    }
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    const labelSpacing = SizedBox(height: 6.0);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditing ? 'Edit Job' : 'Create Job',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          if (_isEditing)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 24),
                onPressed: () {
                  // TODO: implement delete using ApiEndpoints.deleteJob(jobId)
                },
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: _thumbnailFile != null
                          ? FileImage(_thumbnailFile!)
                          : const NetworkImage(
                        'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
                      ) as ImageProvider,
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: _pickThumbnail,
                      child: const Text(
                        'Change thumbnail picture',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              _label('Company/Agency Name'),
              labelSpacing,
              TextFormField(
                controller: _companyController,
                style: _fieldTextStyle,
                decoration: _inputDecoration().copyWith(
                  hintText: 'Modern Homes Co.',
                  hintStyle:
                  const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 16),

              _label('Job designation'),
              labelSpacing,
              TextFormField(
                controller: _designationController,
                style: _fieldTextStyle,
                decoration: _inputDecoration().copyWith(
                  hintText: 'Real estate agent needed',
                  hintStyle:
                  const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 16),

              _label('Location'),
              labelSpacing,
              TextFormField(
                controller: _locationController,
                style: _fieldTextStyle,
                decoration: _inputDecoration().copyWith(
                  hintText: '789 Park Lane, Birmingham, B',
                  hintStyle:
                  const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 16),

              _label('Price'),
              labelSpacing,
              TextFormField(
                controller: _priceController,
                style: _fieldTextStyle,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration().copyWith(
                  hintText: '\$ 199',
                  hintStyle:
                  const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Price is required';
                  }
                  final v = value.replaceAll('\$', '').trim();
                  if (double.tryParse(v) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _label('Assign to Staff'),
              labelSpacing,
              Obx(() {
                if (staffController.isLoading.value) {
                  return _loadingDropdown();
                }
                return _staffDropdown(staffController);
              }),

              const SizedBox(height: 18),

              _label('Description'),
              labelSpacing,
              TextFormField(
                controller: _descriptionController,
                maxLines: 8,
                minLines: 5,
                style: _fieldTextStyle,
                keyboardType: TextInputType.multiline,
                decoration: _inputDecoration(isBig: true).copyWith(
                  hintText:
                  'Lorem ipsum dolor sit amet consectetur. Lectus sed in egestas ultrices a odio eget varius sit. '
                      'Viverra senectus egestas nisl vel adipiscing...',
                  hintStyle:
                  const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                validator: _requiredValidator,
              ),

              const SizedBox(height: 20),

              _label('Photos'),
              const SizedBox(height: 8),

              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ..._photos.map(
                          (file) => _photoItem(FileImage(file)),
                    ),
                    GestureDetector(
                      onTap: _addPhoto,
                      child: _addPhotoButton(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: _isSaving ? null : _onSave,
                  child: _isSaving
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Text(
                    _isEditing ? 'Save' : 'Create',
                    style: const TextStyle(
                        fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UI helpers
  // ---------------------------------------------------------------------------

  static const TextStyle _fieldTextStyle =
  TextStyle(color: Colors.white, fontSize: 14);

  static String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 14,
    ),
  );

  static InputDecoration _inputDecoration({bool isBig = false}) {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: isBig ? 10 : 12,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: const BorderSide(color: Colors.white70, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: const BorderSide(color: Colors.orange, width: 1.2),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: const BorderSide(color: Colors.white70, width: 1),
      ),
    );
  }

  static Widget _photoItem(ImageProvider image) => Padding(
    padding: const EdgeInsets.only(right: 10),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image(
        image: image,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
    ),
  );

  static Widget _addPhotoButton() => Container(
    width: 80,
    height: 80,
    margin: const EdgeInsets.only(right: 10),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.white54),
      borderRadius: BorderRadius.circular(6),
    ),
    child: const Center(
      child: Text(
        'Add photo +',
        style: TextStyle(color: Colors.white70, fontSize: 12),
      ),
    ),
  );

  static Widget _loadingDropdown() => DropdownButtonFormField<String>(
    items: const [],
    onChanged: null,
    decoration: _inputDecoration().copyWith(
      hintText: 'Loading...',
      hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
    ),
    dropdownColor: Colors.black,
  );

  static Widget _staffDropdown(StaffController controller) {
    return DropdownButtonFormField<ProfileModel>(
      value: controller.selectedStaff.value,
      dropdownColor: Colors.black,
      style: _fieldTextStyle,
      decoration: _inputDecoration().copyWith(
        hintText: 'Select a staff',
        hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
      ),
      isExpanded: true,
      items: controller.staffList.map((staff) {
        return DropdownMenuItem(
          value: staff,
          child: Text(
            staff.name ?? staff.username ?? 'Unknown Staff',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        );
      }).toList(),
      onChanged: (value) => controller.selectStaff(value),
    );
  }
}