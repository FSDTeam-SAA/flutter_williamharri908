import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
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
    this.job, // existing job data to prefill (optional)
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

  // NEW: PDF files
  File? _methodStatementFile;
  File? _riskAssessmentFile;

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
    _priceController = TextEditingController(text: widget.job?.price ?? '');
    _descriptionController =
        TextEditingController(text: widget.job?.description ?? '');

    if (_isEditing && widget.job != null) {
      final job = widget.job!;
      String? staffId = job.staffId;

      if (staffId == null && job.assignedTo.isNotEmpty) {
        staffId = job.assignedTo.first;
      }

      if (staffId != null) {
        for (final s in staffController.staffList) {
          if (s.id == staffId) {
            staffController.selectStaff(s);
            break;
          }
        }
      }

      // NOTE: if your CreateJobModel has methodStatement / riskAssessment URLs,
      // you could show their names here, but it's optional since picking PDFs is manual.
    }
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

  // NEW: pick Method Statement PDF
  Future<void> _pickMethodStatementPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _methodStatementFile = File(result.files.single.path!);
      });
    }
  }

  // NEW: pick Risk Assessment PDF
  Future<void> _pickRiskAssessmentPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _riskAssessmentFile = File(result.files.single.path!);
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
      if (_isEditing) {
        await _updateJob(
          jobId: widget.jobId!,
          company: company,
          designation: designation,
          location: location,
          price: price,
          description: description,
          assigneeId: staff.id!,
          thumbnail: _thumbnailFile,
          photos: _photos,
          methodStatement: _methodStatementFile,
          riskAssessment: _riskAssessmentFile,
        );
      } else {
        await _createJob(
          company: company,
          designation: designation,
          location: location,
          price: price,
          description: description,
          assigneeId: staff.id!,
          thumbnail: _thumbnailFile,
          photos: _photos,
          methodStatement: _methodStatementFile,
          riskAssessment: _riskAssessmentFile,
        );
      }

      Get.snackbar(
        'Success',
        _isEditing ? 'Job updated successfully' : 'Job created successfully',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
      );

      //  IMPORTANT: return `true` so HomeScreen knows to refresh
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

  Future<String> _createJob({
    required String company,
    required String designation,
    required String location,
    required String price,
    required String description,
    required String assigneeId,
    File? thumbnail,
    List<File> photos = const [],
    File? methodStatement,
    File? riskAssessment,
  }) async {
    final cleanedPrice = price.replaceAll('\$', '').trim();

    final formDataMap = <String, dynamic>{
      'companyName': company,
      'title': designation,
      'location': location,
      'price': cleanedPrice,
      'description': description,
      'assigneTo': assigneeId,
      'assignedTo': [assigneeId],
    };

    if (thumbnail != null) {
      formDataMap['thumbnail'] =
          dio.MultipartFile.fromFileSync(thumbnail.path);
    }

    if (photos.isNotEmpty) {
      formDataMap['photos'] =
          photos.map((f) => dio.MultipartFile.fromFileSync(f.path)).toList();
    }

    // NEW: add PDFs
    if (methodStatement != null) {
      formDataMap['methodStatement'] =
          dio.MultipartFile.fromFileSync(methodStatement.path);
    }

    if (riskAssessment != null) {
      formDataMap['riskAssessment'] =
          dio.MultipartFile.fromFileSync(riskAssessment.path);
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

  Future<void> _updateJob({
    required String jobId,
    required String company,
    required String designation,
    required String location,
    required String price,
    required String description,
    required String assigneeId,
    File? thumbnail,
    List<File> photos = const [],
    File? methodStatement,
    File? riskAssessment,
  }) async {
    final cleanedPrice = price.replaceAll('\$', '').trim();

    final formDataMap = <String, dynamic>{
      'companyName': company,
      'title': designation,
      'location': location,
      'price': cleanedPrice,
      'description': description,
      'assigneTo': assigneeId,
      'assignedTo': [assigneeId],
    };

    if (thumbnail != null) {
      formDataMap['thumbnail'] =
          dio.MultipartFile.fromFileSync(thumbnail.path);
    }

    if (photos.isNotEmpty) {
      formDataMap['photos'] =
          photos.map((f) => dio.MultipartFile.fromFileSync(f.path)).toList();
    }

    // NEW: add PDFs only if user picked them
    if (methodStatement != null) {
      formDataMap['methodStatement'] =
          dio.MultipartFile.fromFileSync(methodStatement.path);
    }

    if (riskAssessment != null) {
      formDataMap['riskAssessment'] =
          dio.MultipartFile.fromFileSync(riskAssessment.path);
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
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: _thumbnailFile != null
                          ? FileImage(_thumbnailFile!)
                          : const AssetImage('assets/icons/istockphoto.jpg')
                      as ImageProvider,
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
                  hintText: 'Write Something...',
                  hintStyle:
                  const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                validator: _requiredValidator,
              ),

              // NEW: PDF fields
              const SizedBox(height: 20),
              _label('Method Statement'),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickMethodStatementPdf,
                    child: const Text('Choose file'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _methodStatementFile != null
                          ? _methodStatementFile!.path.split('/').last
                          : 'No file selected',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _label('Risk Assessment (PDF)'),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickRiskAssessmentPdf,
                    child: const Text('Choose file'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _riskAssessmentFile != null
                          ? _riskAssessmentFile!.path.split('/').last
                          : 'No file selected',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              _label('Photos'),
              const SizedBox(height: 8),
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (int i = 0; i < _photos.length; i++)
                      _removablePhotoItem(
                        image: FileImage(_photos[i]),
                        onRemove: () {
                          setState(() {
                            _photos.removeAt(i);
                          });
                        },
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

/// Thumbnail with close button for photos list
Widget _removablePhotoItem({
  required ImageProvider image,
  required VoidCallback onRemove,
}) {
  return Padding(
    padding: const EdgeInsets.only(right: 10),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image(
            image: image,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
