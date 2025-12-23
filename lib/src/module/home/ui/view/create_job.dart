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

class ClientItem {
  final String id;
  final String clientName;
  final String clientEmail;

  const ClientItem({
    required this.id,
    required this.clientName,
    required this.clientEmail,
  });

  factory ClientItem.fromJson(Map<String, dynamic> json) {
    return ClientItem(
      id: (json['id'] ?? '').toString(),
      clientName: (json['clientName'] ?? '').toString(),
      clientEmail: (json['clientEmail'] ?? '').toString(),
    );
  }

  String get display => '$clientName - $clientEmail';
}

class EditJobScreen extends StatefulWidget {
  const EditJobScreen({
    super.key,
    this.jobId,
    this.job,
  });

  final String? jobId;
  final CreateJobModel? job;

  @override
  State<EditJobScreen> createState() => _EditJobScreenState();
}

class _EditJobScreenState extends State<EditJobScreen> {
  final StaffController staffController = Get.find<StaffController>();
  final AppPigeon appPigeon = Get.find<AppPigeon>();

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _designationController; // hidden (title)
  late final TextEditingController _locationController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;

  // ✅ NEW
  late final TextEditingController _quotationNoController;
  late final TextEditingController _latController;
  late final TextEditingController _langController;

  bool _clientsLoading = false;
  final List<ClientItem> _clients = [];
  ClientItem? _selectedClient;
  String? _initialClientId;

  File? _thumbnailFile;
  final List<File> _photos = [];

  File? _methodStatementFile;
  File? _riskAssessmentFile;

  bool _isSaving = false;

  final ImagePicker _picker = ImagePicker();

  bool get _isEditing => widget.jobId != null;

  @override
  void initState() {
    super.initState();

    _designationController = TextEditingController(text: widget.job?.title ?? '');
    _locationController = TextEditingController(text: widget.job?.location ?? '');
    _priceController = TextEditingController(text: widget.job?.price ?? '');
    _descriptionController = TextEditingController(text: widget.job?.description ?? '');

    // ✅ NEW prefill
    _quotationNoController = TextEditingController(text: widget.job?.quotationNo ?? '');
    _latController = TextEditingController(text: widget.job?.lat?.toString() ?? '');
    _langController = TextEditingController(text: widget.job?.lang?.toString() ?? '');

    if (_isEditing && widget.job != null) {
      final job = widget.job!;

      // staff preselect
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

      // clientId (dynamic if present)
      try {
        final dynamic anyJob = job;
        _initialClientId = anyJob.clientId as String?;
      } catch (_) {
        _initialClientId = null;
      }
    }

    _fetchClients();
  }

  @override
  void dispose() {
    _designationController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();

    _quotationNoController.dispose();
    _latController.dispose();
    _langController.dispose();

    super.dispose();
  }

  double? _parseDouble(String v) {
    final t = v.trim();
    if (t.isEmpty) return null;
    return double.tryParse(t);
  }

  Future<void> _fetchClients() async {
    setState(() => _clientsLoading = true);

    try {
      final res = await appPigeon.get(ApiEndpoints.allClient);

      final data = res.data;
      final List results = (data is Map<String, dynamic>)
          ? ((data['data']?['results'] as List?) ?? const [])
          : const [];

      final parsed = results
          .whereType<Map>()
          .map((e) => ClientItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      _clients
        ..clear()
        ..addAll(parsed);

      if (_initialClientId != null) {
        for (final c in _clients) {
          if (c.id == _initialClientId) {
            _selectedClient = c;
            break;
          }
        }
      }
    } catch (e) {
      debugPrint('clients fetch error: $e');
      Get.snackbar(
        'Error',
        'Failed to load clients',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      if (mounted) setState(() => _clientsLoading = false);
    }
  }

  Future<void> _pickThumbnail() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _thumbnailFile = File(picked.path));
  }

  Future<void> _addPhoto() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _photos.add(File(picked.path)));
  }

  Future<void> _pickMethodStatementPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() => _methodStatementFile = File(result.files.single.path!));
    }
  }

  Future<void> _pickRiskAssessmentPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() => _riskAssessmentFile = File(result.files.single.path!));
    }
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final clientId = _selectedClient?.id.trim() ?? '';

    final title = _designationController.text.trim().isNotEmpty
        ? _designationController.text.trim()
        : 'Job';

    final location = _locationController.text.trim();

    if (clientId.isEmpty || title.isEmpty || location.isEmpty) {
      Get.snackbar(
        'Error',
        'clientId, title, location are required',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

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

    // ✅ NEW values
    final quotationNo = _quotationNoController.text.trim();
    final lat = _parseDouble(_latController.text);
    final lang = _parseDouble(_langController.text); // backend uses "lang"

    try {
      if (_isEditing) {
        await _updateJob(
          jobId: widget.jobId!,
          clientId: clientId,
          title: title,
          location: location,
          description: _descriptionController.text.trim(),
          price: _priceController.text.trim(),
          assigneeId: staff.id!,
          thumbnail: _thumbnailFile,
          photos: _photos,
          methodStatement: _methodStatementFile,
          riskAssessment: _riskAssessmentFile,

          quotationNo: quotationNo,
          lat: lat,
          lang: lang,
        );
      } else {
        await _createJob(
          clientId: clientId,
          title: title,
          location: location,
          description: _descriptionController.text.trim(),
          price: _priceController.text.trim(),
          assigneeId: staff.id!,
          thumbnail: _thumbnailFile,
          photos: _photos,
          methodStatement: _methodStatementFile,
          riskAssessment: _riskAssessmentFile,

          quotationNo: quotationNo,
          lat: lat,
          lang: lang,
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
      debugPrint('save error: $e\n$st');
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

  Future<String> _createJob({
    required String clientId,
    required String title,
    required String location,
    String? description,
    String? price,
    required String assigneeId,
    File? thumbnail,
    List<File> photos = const [],
    File? methodStatement,
    File? riskAssessment,

    // ✅ NEW
    String? quotationNo,
    double? lat,
    double? lang,
  }) async {
    final cleanedPrice = price?.replaceAll('\$', '').trim();

    final formDataMap = <String, dynamic>{
      'clientId': clientId,
      'client': clientId,
      'title': title,
      'location': location,
      'description': description,
      'price': cleanedPrice,
      'assigneTo': assigneeId,
      'assignedTo': [assigneeId],

      // ✅ NEW
      'quotationNo': quotationNo,
    };

    // ✅ NEW coordinates (multipart-safe)
    if (lat != null) {
      formDataMap['coordinates[lat]'] = lat;
      formDataMap['coordinates.lat'] = lat; // fallback
    }
    if (lang != null) {
      formDataMap['coordinates[lang]'] = lang;
      formDataMap['coordinates.lang'] = lang; // fallback
    }

    if (thumbnail != null) {
      formDataMap['thumbnail'] = dio.MultipartFile.fromFileSync(thumbnail.path);
    }
    if (photos.isNotEmpty) {
      formDataMap['photos'] = photos.map((f) => dio.MultipartFile.fromFileSync(f.path)).toList();
    }
    if (methodStatement != null) {
      formDataMap['methodStatement'] = dio.MultipartFile.fromFileSync(methodStatement.path);
    }
    if (riskAssessment != null) {
      formDataMap['riskAssessment'] = dio.MultipartFile.fromFileSync(riskAssessment.path);
    }

    final formData = dio.FormData.fromMap(formDataMap);

    final response = await appPigeon.post(
      ApiEndpoints.createJob,
      data: formData,
    );

    final body = response.data as Map<String, dynamic>;
    final id = body['data']?['id'] ?? body['id'];
    if (id == null) throw Exception('Create job successful but no id returned');
    return id.toString();
  }

  Future<void> _updateJob({
    required String jobId,
    required String clientId,
    required String title,
    required String location,
    String? description,
    String? price,
    required String assigneeId,
    File? thumbnail,
    List<File> photos = const [],
    File? methodStatement,
    File? riskAssessment,

    // ✅ NEW
    String? quotationNo,
    double? lat,
    double? lang,
  }) async {
    final cleanedPrice = price?.replaceAll('\$', '').trim();

    final formDataMap = <String, dynamic>{
      'clientId': clientId,
      'client': clientId,
      'title': title,
      'location': location,
      'description': description,
      'price': cleanedPrice,
      'assigneTo': assigneeId,
      'assignedTo': [assigneeId],

      // ✅ NEW
      'quotationNo': quotationNo,
    };

    // ✅ NEW coordinates (multipart-safe)
    if (lat != null) {
      formDataMap['coordinates[lat]'] = lat;
      formDataMap['coordinates.lat'] = lat;
    }
    if (lang != null) {
      formDataMap['coordinates[lang]'] = lang;
      formDataMap['coordinates.lang'] = lang;
    }

    if (thumbnail != null) {
      formDataMap['thumbnail'] = dio.MultipartFile.fromFileSync(thumbnail.path);
    }
    if (photos.isNotEmpty) {
      formDataMap['photos'] = photos.map((f) => dio.MultipartFile.fromFileSync(f.path)).toList();
    }
    if (methodStatement != null) {
      formDataMap['methodStatement'] = dio.MultipartFile.fromFileSync(methodStatement.path);
    }
    if (riskAssessment != null) {
      formDataMap['riskAssessment'] = dio.MultipartFile.fromFileSync(riskAssessment.path);
    }

    final formData = dio.FormData.fromMap(formDataMap);

    await appPigeon.patch(
      ApiEndpoints.updateJob(jobId),
      data: formData,
    );
  }

  // ==========================
  // UI
  // ==========================

  Widget _clientField() {
    final text = _selectedClient?.display ?? 'Select from here';

    return InkWell(
      onTap: _clientsLoading ? null : _openClientSearchSheet,
      child: InputDecorator(
        decoration: _inputDecoration().copyWith(
          hintText: _clientsLoading ? 'Loading...' : 'Select from here',
          hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
          suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
        ),
        child: Text(text, style: _fieldTextStyle, overflow: TextOverflow.ellipsis),
      ),
    );
  }

  void _openClientSearchSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final searchCtrl = TextEditingController();
        List<ClientItem> filtered = List<ClientItem>.from(_clients);

        bool matches(ClientItem c, String q) {
          final query = q.toLowerCase().trim();
          return c.clientName.toLowerCase().contains(query) ||
              c.clientEmail.toLowerCase().contains(query);
        }

        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 10,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 4,
                    width: 44,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: searchCtrl,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search client...',
                      hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.white70, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.orange, width: 1.2),
                      ),
                    ),
                    onChanged: (q) {
                      setModalState(() {
                        filtered = q.trim().isEmpty
                            ? List<ClientItem>.from(_clients)
                            : _clients.where((c) => matches(c, q)).toList();
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final c = filtered[i];
                        final isSelected = _selectedClient?.id == c.id;

                        return ListTile(
                          tileColor: isSelected ? Colors.orange.withOpacity(0.22) : null,
                          title: Text(c.display, style: const TextStyle(color: Colors.white)),
                          onTap: () {
                            setState(() => _selectedClient = c);
                            Navigator.pop(ctx);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _staffField() {
    return Obx(() {
      if (staffController.isLoading.value) return _loadingDropdown();

      final selected = staffController.selectedStaff.value;
      final selectedText = selected?.name ?? selected?.username ?? 'Select from here';

      return InkWell(
        onTap: () => _openStaffSearchSheet(staffController),
        child: InputDecorator(
          decoration: _inputDecoration().copyWith(
            hintText: 'Select from here',
            hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
            suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
          ),
          child: Text(selectedText, style: _fieldTextStyle, overflow: TextOverflow.ellipsis),
        ),
      );
    });
  }

  void _openStaffSearchSheet(StaffController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final searchCtrl = TextEditingController();
        List<ProfileModel> filtered = List<ProfileModel>.from(controller.staffList);

        bool matches(ProfileModel s, String q) {
          final query = q.toLowerCase().trim();
          final name = (s.name ?? '').toLowerCase();
          final username = (s.username ?? '').toLowerCase();
          final email = (s.email ?? '').toLowerCase();
          return name.contains(query) || username.contains(query) || email.contains(query);
        }

        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 10,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 4,
                    width: 44,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: searchCtrl,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search staff...',
                      hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.white70, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.orange, width: 1.2),
                      ),
                    ),
                    onChanged: (q) {
                      setModalState(() {
                        filtered = q.trim().isEmpty
                            ? List<ProfileModel>.from(controller.staffList)
                            : controller.staffList.where((s) => matches(s, q)).toList();
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final s = filtered[i];
                        final title = s.name ?? s.username ?? 'Unknown Staff';
                        final isSelected = controller.selectedStaff.value?.id == s.id;

                        return ListTile(
                          tileColor: isSelected ? Colors.orange.withOpacity(0.22) : null,
                          title: Text(title, style: const TextStyle(color: Colors.white)),
                          onTap: () {
                            controller.selectStaff(s);
                            Navigator.pop(ctx);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
                          : const AssetImage('assets/icons/istockphoto.jpg') as ImageProvider,
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

              _label('Client Name'),
              labelSpacing,
              _clientsLoading ? _loadingLikeField('Loading...') : _clientField(),

              const SizedBox(height: 16),
              _label('Quotation No'),
              labelSpacing,
              TextFormField(
                controller: _quotationNoController,
                style: _fieldTextStyle,
                decoration: _inputDecoration().copyWith(
                  hintText: 'QTN-12345',
                  hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),

              const SizedBox(height: 16),
              _label('Latitude'),
              labelSpacing,
              TextFormField(
                controller: _latController,
                style: _fieldTextStyle,
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                decoration: _inputDecoration().copyWith(
                  hintText: '51.5074',
                  hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return null;
                  if (double.tryParse(t) == null) return 'Enter valid latitude';
                  return null;
                },
              ),

              const SizedBox(height: 16),
              _label('Longitude'),
              labelSpacing,
              TextFormField(
                controller: _langController,
                style: _fieldTextStyle,
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                decoration: _inputDecoration().copyWith(
                  hintText: '-0.1278',
                  hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return null;
                  if (double.tryParse(t) == null) return 'Enter valid longitude';
                  return null;
                },
              ),

              const SizedBox(height: 16),
              _label('Location'),
              labelSpacing,
              TextFormField(
                controller: _locationController,
                style: _fieldTextStyle,
                decoration: _inputDecoration().copyWith(
                  hintText: '789 Park Lane, Birmingham, B',
                  hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                validator: _requiredValidator,
              ),

              const SizedBox(height: 16),
              _label('Assign to Staff'),
              labelSpacing,
              _staffField(),

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
                  hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                validator: _requiredValidator,
              ),

              const SizedBox(height: 20),
              _label('Method Statement (PDF)'),
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
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
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
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
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
                        onRemove: () => setState(() => _photos.removeAt(i)),
                      ),
                    GestureDetector(onTap: _addPhoto, child: _addPhotoButton()),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  onPressed: _isSaving ? null : _onSave,
                  child: _isSaving
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : Text(
                    _isEditing ? 'Save' : 'Create',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const TextStyle _fieldTextStyle = TextStyle(color: Colors.white, fontSize: 14);

  static String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
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
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: isBig ? 10 : 12),
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

  Widget _loadingLikeField(String text) {
    return InputDecorator(
      decoration: _inputDecoration().copyWith(
        hintText: text,
        hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14)),
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
}

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
          child: Image(image: image, width: 80, height: 80, fit: BoxFit.cover),
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
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}
