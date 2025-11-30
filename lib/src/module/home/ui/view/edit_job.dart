import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:williamharri/src/core/constants/api_endpoints.dart';
import 'package:williamharri/src/core/services/app_pigeon/app_pigeon.dart';
import 'package:williamharri/src/module/home/controller/job_controller.dart';
import 'package:williamharri/src/module/home/model/job_cart_model.dart';
import 'package:williamharri/src/module/profile/controller/staff_list_controller.dart';
import 'package:williamharri/src/module/profile/model/profile_model.dart';

class EditJobScreen extends StatefulWidget {
  final JobModel job;

  const EditJobScreen({super.key, required this.job});

  @override
  State<EditJobScreen> createState() => _EditJobScreenState();
}

class _EditJobScreenState extends State<EditJobScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _companyCtrl;
  late final TextEditingController _titleCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _priceCtrl;

  final ImagePicker _picker = ImagePicker();

  File? _thumbnailFile;

  /// new photos user adds while editing
  final List<File> _newPhotos = [];

  /// existing photo URLs from backend
  late List<String> _existingPhotos;

  /// NEW: PDFs
  File? _methodStatementFile;          // new picked file (if any)
  File? _riskAssessmentFile;           // new picked file (if any)

  String? _existingMethodStatementUrl; // existing pdf url from backend
  String? _existingRiskAssessmentUrl;  // existing pdf url from backend

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _companyCtrl = TextEditingController(text: widget.job.companyName);
    _titleCtrl = TextEditingController(text: widget.job.title);
    _locationCtrl = TextEditingController(text: widget.job.location);
    _descriptionCtrl = TextEditingController(text: widget.job.description);
    _priceCtrl = TextEditingController(text: widget.job.price.toString());

    _existingPhotos = List<String>.from(widget.job.photos ?? []);

    // ✅ Get existing PDF URLs from JobModel
    _existingMethodStatementUrl = widget.job.methodStatement;   // <--- make sure JobModel has this
    _existingRiskAssessmentUrl = widget.job.riskAssessment;     // <--- and this
  }

  @override
  void dispose() {
    _companyCtrl.dispose();
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    _descriptionCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Image pickers
  // ---------------------------------------------------------------------------

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
        _newPhotos.add(File(picked.path));
      });
    }
  }

  // ---------------------------------------------------------------------------
  // NEW: PDF pickers
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // SAVE: PATCH /jobs/{id} with multipart/form-data
  // ---------------------------------------------------------------------------

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final staffController = Get.find<StaffController>();
    final staff = staffController.selectedStaff.value;

    if (staff == null || staff.id == null) {
      Get.snackbar(
        'Assign staff',
        'Please select a staff to assign this job.',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isSaving = true);

    final appPigeon = Get.find<AppPigeon>();
    final jobsController = Get.find<JobController>();

    final Map<String, dynamic> dataMap = {
      'companyName': _companyCtrl.text.trim(),
      'title': _titleCtrl.text.trim(),
      'location': _locationCtrl.text.trim(),
      'description': _descriptionCtrl.text.trim(),
      'price': _priceCtrl.text.trim(),
      'assigneTo': staff.id!,
      'assignedTo': [staff.id], // if your backend expects this as well
    };

    if (_thumbnailFile != null) {
      dataMap['thumbnail'] =
          dio.MultipartFile.fromFileSync(_thumbnailFile!.path);
    }

    // new photos only (existing ones are already stored on server)
    if (_newPhotos.isNotEmpty) {
      dataMap['photos'] = _newPhotos
          .map((f) => dio.MultipartFile.fromFileSync(f.path))
          .toList();
    }

    // ✅ PDFs: only send if user picked a new one
    if (_methodStatementFile != null) {
      dataMap['methodStatement'] =
          dio.MultipartFile.fromFileSync(_methodStatementFile!.path);
    }

    if (_riskAssessmentFile != null) {
      dataMap['riskAssessment'] =
          dio.MultipartFile.fromFileSync(_riskAssessmentFile!.path);
    }

    // If backend needs to know which existing photos were removed,
    // you can send list of remaining `_existingPhotos` or removed URLs here.

    final formData = dio.FormData.fromMap(dataMap);

    try {
      await appPigeon.patch(
        ApiEndpoints.updateJob(widget.job.id),
        data: formData,
      );

      await jobsController.fetchJobs();
      Get.back(result: true);
    } on dio.DioException catch (e) {
      final data = e.response?.data;
      String msg;
      if (data is Map && data['message'] != null) {
        msg = data['message'].toString();
      } else {
        msg =
        'Failed to update job (status: ${e.response?.statusCode ?? 'unknown'})';
      }
      Get.snackbar(
        'Error',
        msg,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // --------------------------- UI helpers ---------------------------

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

  static Widget _photoItem({
    required ImageProvider image,
    required VoidCallback onRemove,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Stack(
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
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Colors.black54,
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

  String _fileNameFromUrl(String url) {
    try {
      return Uri.parse(url).pathSegments.last;
    } catch (_) {
      return url.split('/').last;
    }
  }

  @override
  Widget build(BuildContext context) {
    final staffController = Get.find<StaffController>();
    const labelSpacing = SizedBox(height: 6.0);

    // choose avatar image: picked file or existing thumbnail or fallback
    ImageProvider avatarImage;
    if (_thumbnailFile != null) {
      avatarImage = FileImage(_thumbnailFile!);
    } else if (widget.job.thumbnail != null &&
        widget.job.thumbnail!.isNotEmpty) {
      avatarImage = NetworkImage(widget.job.thumbnail!);
    } else {
      avatarImage = const NetworkImage(
        'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Job',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
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
                      backgroundImage: avatarImage,
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
                controller: _companyCtrl,
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
                controller: _titleCtrl,
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
                controller: _locationCtrl,
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
                controller: _priceCtrl,
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
              const SizedBox(height: 18),

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
                controller: _descriptionCtrl,
                maxLines: 8,
                minLines: 5,
                style: _fieldTextStyle,
                keyboardType: TextInputType.multiline,
                decoration: _inputDecoration(isBig: true).copyWith(
                  hintText: 'Write something...',
                  hintStyle:
                  const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                validator: _requiredValidator,
              ),

              // -------------------- PDFs (like create screen) --------------------
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
                          : (_existingMethodStatementUrl != null
                          ? _fileNameFromUrl(_existingMethodStatementUrl!)
                          : 'No file selected'),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _label('Risk Assessment'),
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
                          : (_existingRiskAssessmentUrl != null
                          ? _fileNameFromUrl(_existingRiskAssessmentUrl!)
                          : 'No file selected'),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              _label('Photos'),
              const SizedBox(height: 8),
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // existing photos (URLs)
                    ..._existingPhotos.asMap().entries.map((entry) {
                      final index = entry.key;
                      final url = entry.value;
                      return _photoItem(
                        image: NetworkImage(url),
                        onRemove: () {
                          setState(() {
                            _existingPhotos.removeAt(index);
                          });
                        },
                      );
                    }),

                    // new photos (files)
                    ..._newPhotos.asMap().entries.map((entry) {
                      final index = entry.key;
                      final file = entry.value;
                      return _photoItem(
                        image: FileImage(file),
                        onRemove: () {
                          setState(() {
                            _newPhotos.removeAt(index);
                          });
                        },
                      );
                    }),

                    // add-photo button
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
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'Save',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
