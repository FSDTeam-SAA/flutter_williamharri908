import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'package:williamharri/src/core/constants/api_endpoints.dart';
import 'package:williamharri/src/core/services/app_pigeon/app_pigeon.dart';
import 'package:williamharri/src/module/home/controller/job_controller.dart';
import 'package:williamharri/src/module/home/model/job_cart_model.dart';
import 'package:williamharri/src/module/profile/controller/staff_list_controller.dart';
import 'package:williamharri/src/module/profile/model/profile_model.dart';

// ============================================================================
// ✅ UpdateJobModel (same idea like CreateJobModel: quotation + coordinates)
// ============================================================================
class UpdateJobModel {
  final String? clientId;
  final String? title;
  final String? location;
  final String? description;
  final String? price;

  final String? assigneeId;
  final List<String> assignedTo;

  final String? quotationNo;
  final double? lat;
  final double? lang;

  UpdateJobModel({
    this.clientId,
    this.title,
    this.location,
    this.description,
    this.price,
    this.assigneeId,
    this.assignedTo = const [],
    this.quotationNo,
    this.lat,
    this.lang,
  });

  Map<String, dynamic> toJson({bool includeBracketCoordinates = true}) {
    final map = <String, dynamic>{};

    if (clientId != null) {
      map['clientId'] = clientId;
      map['client'] = clientId; // backend fallback
    }

    if (title != null) map['title'] = title;
    if (location != null) map['location'] = location;
    if (description != null) map['description'] = description;
    if (price != null) map['price'] = price;

    if (quotationNo != null) map['quotationNo'] = quotationNo;

    // staff
    if (assigneeId != null) {
      map['assigneTo'] = assigneeId;
      map['assignedTo'] = [assigneeId];
    } else if (assignedTo.isNotEmpty) {
      map['assignedTo'] = assignedTo;
    }

    // coordinates JSON
    if (lat != null || lang != null) {
      map['coordinates'] = {'lat': lat, 'lang': lang};
    }

    // coordinates multipart safe formats
    if (includeBracketCoordinates) {
      if (lat != null) map['coordinates[lat]'] = lat;
      if (lang != null) map['coordinates[lang]'] = lang;

      if (lat != null) map['coordinates.lat'] = lat;
      if (lang != null) map['coordinates.lang'] = lang;
    }

    return map;
  }
}

// ============================================================================
// ✅ Client item
// ============================================================================
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
      id: (json['id'] ?? json['_id'] ?? '').toString().trim(),
      clientName: (json['clientName'] ?? json['name'] ?? '').toString().trim(),
      clientEmail: (json['clientEmail'] ?? json['email'] ?? '').toString().trim(),
    );
  }

  /// ✅ REQUIRED FORMAT: clientName-(email)  (NO spaces)
  String get display => '${clientName.trim()}-(${clientEmail.trim()})';
}

// ============================================================================
// ✅ Edit Job Screen (UPDATE)
// ============================================================================
class EditJobScreen extends StatefulWidget {
  final JobModel job;
  const EditJobScreen({super.key, required this.job});

  @override
  State<EditJobScreen> createState() => _EditJobScreenState();
}

class _EditJobScreenState extends State<EditJobScreen> {
  final _formKey = GlobalKey<FormState>();

  // controllers
  late final TextEditingController _titleCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _priceCtrl;

  // ✅ NEW UI fields (like create)
  late final TextEditingController _quotationCtrl;
  late final TextEditingController _latCtrl;
  late final TextEditingController _langCtrl;

  // clients
  bool _clientsLoading = false;
  final List<ClientItem> _clients = [];
  ClientItem? _selectedClient;

  String? _initialClientId;
  String? _initialClientName;
  String? _initialClientEmail;

  // staff
  final StaffController staffController = Get.find<StaffController>();
  Worker? _staffLoadingWorker;

  // files
  final ImagePicker _picker = ImagePicker();
  File? _thumbnailFile;
  final List<File> _newPhotos = [];

  File? _methodStatementFile;
  File? _riskAssessmentFile;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _titleCtrl = TextEditingController(text: (widget.job.title).toString());
    _locationCtrl = TextEditingController(text: (widget.job.location).toString());
    _descriptionCtrl = TextEditingController(text: (widget.job.description).toString());
    _priceCtrl = TextEditingController(text: (widget.job.price).toString());

    // ✅ NEW: prefill quotation + coords if exist
    _quotationCtrl = TextEditingController(text: _readQuotationNo(widget.job) ?? '');
    final coords = _readCoords(widget.job);
    _latCtrl = TextEditingController(text: coords.$1?.toString() ?? '');
    _langCtrl = TextEditingController(text: coords.$2?.toString() ?? '');

    _readInitialClientFromJob(widget.job);

    // auto-select staff after list loads
    _staffLoadingWorker = ever<bool>(staffController.isLoading, (loading) {
      if (loading == false) _preselectAssignedStaff();
    });
    if (staffController.isLoading.value == false) {
      _preselectAssignedStaff();
    }

    _fetchClients();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    _descriptionCtrl.dispose();
    _priceCtrl.dispose();

    _quotationCtrl.dispose();
    _latCtrl.dispose();
    _langCtrl.dispose();

    _staffLoadingWorker?.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------------------
  // ✅ Read quotation + coords (safe dynamic)
  // ----------------------------------------------------------------------------
  String? _readQuotationNo(JobModel job) {
    try {
      final dynamic j = job;
      final q = j.quotationNo;
      if (q != null && q.toString().trim().isNotEmpty) return q.toString().trim();
    } catch (_) {}
    return null;
  }

  (double?, double?) _readCoords(JobModel job) {
    double? toDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    try {
      final dynamic j = job;
      final dynamic c = j.coordinates;
      if (c is Map) {
        return (toDouble(c['lat']), toDouble(c['lang']));
      }
      // sometimes flat keys:
      final dynamic lat = j.lat;
      final dynamic lang = j.lang;
      return (toDouble(lat), toDouble(lang));
    } catch (_) {}

    return (null, null);
  }

  // ----------------------------------------------------------------------------
  // ✅ Read initial client info from job (same as your code, kept + safer)
  // ----------------------------------------------------------------------------
  // ----------------------------------------------------------------------------
// ✅ Only change this: read initial client info from JobModel
// ----------------------------------------------------------------------------
  void _readInitialClientFromJob(JobModel job) {
    final dynamic j = job;

    // client id
    try {
      final dynamic cid = j.clientId;
      if (cid != null && cid.toString().trim().isNotEmpty) {
        _initialClientId = cid.toString().trim();
      }
    } catch (_) {}

    // client name: prefer companyName (what you show in UI)
    try {
      final dynamic name = j.companyName; // or j.clientName if your model has it
      if (name != null && name.toString().trim().isNotEmpty) {
        _initialClientName = name.toString().trim();
      }
    } catch (_) {}

    // client email
    try {
      final dynamic email = j.clientEmail;
      if (email != null && email.toString().trim().isNotEmpty) {
        _initialClientEmail = email.toString().trim();
      }
    } catch (_) {}
  }


  // ----------------------------------------------------------------------------
  // ✅ Auto select staff from job
  // ----------------------------------------------------------------------------
  void _preselectAssignedStaff() {
    try {
      final dynamic j = widget.job;
      String? staffId;

      final dynamic assignedTo = j.assignedTo;
      if (assignedTo is List && assignedTo.isNotEmpty) {
        final first = assignedTo.first;

        if (first is String) {
          staffId = first;
        } else if (first is Map) {
          staffId = (first['id'] ?? first['_id'])?.toString();
        } else {
          try {
            staffId = (first?.id ?? first?._id ?? first?.sId)?.toString();
          } catch (_) {}
        }
      }

      try {
        staffId ??= (j.staffId as String?);
      } catch (_) {}

      if (staffId == null || staffId.trim().isEmpty) return;

      for (final s in staffController.staffList) {
        if (s.id == staffId) {
          staffController.selectStaff(s);
          break;
        }
      }
      setState(() {});
    } catch (_) {}
  }

  // ----------------------------------------------------------------------------
  // ✅ Fetch Clients (FIXED: endpoint + parsing + fallback)
  // ----------------------------------------------------------------------------
  Future<void> _fetchClients() async {
    setState(() => _clientsLoading = true);

    final appPigeon = Get.find<AppPigeon>();

    try {
      dio.Response res;

      // ✅ Try same endpoint as Create first (fix your error)
      try {
        res = await appPigeon.get(ApiEndpoints.allClient);
      } catch (_) {
        // fallback
        res = await appPigeon.get(ApiEndpoints.allClient);
      }

      final data = res.data;

      List results = const [];

      if (data is Map<String, dynamic>) {
        // common shapes
        final a = data['data'];
        if (a is Map<String, dynamic>) {
          final r1 = a['results'];
          if (r1 is List) results = r1;

          // sometimes: data -> data -> results
          final d2 = a['data'];
          if (results.isEmpty && d2 is Map<String, dynamic>) {
            final r2 = d2['results'];
            if (r2 is List) results = r2;
          }

          // sometimes: data -> results directly
          final r3 = data['results'];
          if (results.isEmpty && r3 is List) results = r3;
        } else {
          // sometimes data itself is list
          final r = data['results'];
          if (r is List) results = r;
        }
      }

      final parsed = results
          .whereType<Map>()
          .map((e) => ClientItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      _clients
        ..clear()
        ..addAll(parsed);

      _applyClientPreselect();
      setState(() {});
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

  void _applyClientPreselect() {
    if (_clients.isEmpty) return;

    ClientItem? pick;

    if (_initialClientId != null && _initialClientId!.trim().isNotEmpty) {
      final id = _initialClientId!.trim();
      pick = _clients.firstWhereOrNull((c) => c.id == id);
      if (pick != null) {
        _selectedClient = pick;
        return;
      }
    }

    if (_initialClientEmail != null && _initialClientEmail!.trim().isNotEmpty) {
      final email = _initialClientEmail!.trim().toLowerCase();
      pick = _clients.firstWhereOrNull((c) => c.clientEmail.trim().toLowerCase() == email);
      if (pick != null) {
        _selectedClient = pick;
        return;
      }
    }

    if (_initialClientName != null && _initialClientName!.trim().isNotEmpty) {
      final name = _initialClientName!.trim().toLowerCase();

      pick = _clients.firstWhereOrNull((c) => c.clientName.trim().toLowerCase() == name);
      if (pick != null) {
        _selectedClient = pick;
        return;
      }

      pick = _clients.firstWhereOrNull((c) {
        final n = c.clientName.trim().toLowerCase();
        return n.contains(name) || name.contains(n) || n.startsWith(name) || name.startsWith(n);
      });

      if (pick != null) _selectedClient = pick;
    }
  }

  // ----------------------------------------------------------------------------
  // Pickers
  // ----------------------------------------------------------------------------
  Future<void> _pickThumbnail() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _thumbnailFile = File(picked.path));
  }

  Future<void> _addPhoto() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _newPhotos.add(File(picked.path)));
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

  // ----------------------------------------------------------------------------
  // ✅ SAVE (PATCH multipart like Create Job + quotation + coords)
  // ----------------------------------------------------------------------------
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final staff = staffController.selectedStaff.value;
    if (staff == null || staff.id == null) {
      Get.snackbar(
        'Assign to Staff',
        'Please select a staff.',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    final clientId = _selectedClient?.id.trim() ?? '';
    if (clientId.isEmpty) {
      Get.snackbar(
        'Client Name',
        'Please select a client.',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    final title = _titleCtrl.text.trim().isNotEmpty ? _titleCtrl.text.trim() : 'Job';
    final location = _locationCtrl.text.trim();
    if (title.isEmpty || location.isEmpty) {
      Get.snackbar(
        'Error',
        'clientId, title, location are required',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    final cleanedPrice = _priceCtrl.text.trim().replaceAll('\$', '').trim();

    double? lat = double.tryParse(_latCtrl.text.trim());
    double? lang = double.tryParse(_langCtrl.text.trim());

    setState(() => _isSaving = true);

    final appPigeon = Get.find<AppPigeon>();
    final jobsController = Get.find<JobController>();

    final model = UpdateJobModel(
      clientId: clientId,
      title: title,
      location: location,
      description: _descriptionCtrl.text.trim(),
      price: cleanedPrice,
      assigneeId: staff.id!,
      quotationNo: _quotationCtrl.text.trim().isEmpty ? null : _quotationCtrl.text.trim(),
      lat: lat,
      lang: lang,
    );

    final Map<String, dynamic> dataMap = model.toJson(includeBracketCoordinates: true);

    // files
    if (_thumbnailFile != null) {
      dataMap['thumbnail'] = dio.MultipartFile.fromFileSync(_thumbnailFile!.path);
    }
    if (_newPhotos.isNotEmpty) {
      dataMap['photos'] = _newPhotos.map((f) => dio.MultipartFile.fromFileSync(f.path)).toList();
    }
    if (_methodStatementFile != null) {
      dataMap['methodStatement'] = dio.MultipartFile.fromFileSync(_methodStatementFile!.path);
    }
    if (_riskAssessmentFile != null) {
      dataMap['riskAssessment'] = dio.MultipartFile.fromFileSync(_riskAssessmentFile!.path);
    }

    final formData = dio.FormData.fromMap(dataMap);

    try {
      await appPigeon.patch(
        ApiEndpoints.updateJob(widget.job.id),
        data: formData,
      );

      await jobsController.fetchJobs();
      Get.back(result: true);
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

  // ----------------------------------------------------------------------------
  // UI helpers
  // ----------------------------------------------------------------------------
  static const TextStyle _fieldTextStyle = TextStyle(color: Colors.white, fontSize: 14);

  static String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    return null;
  }

  static Widget _label(String text) => Text(
    text,
    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
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

  // ----------------------------------------------------------------------------
  // Client (searchable)
  // ----------------------------------------------------------------------------
  Widget _clientField() {
    final text = _selectedClient?.display ?? (_clientsLoading ? 'Loading...' : 'Select from here');

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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        final searchCtrl = TextEditingController();
        List<ClientItem> filtered = List<ClientItem>.from(_clients);

        bool matches(ClientItem c, String q) {
          final query = q.toLowerCase().trim();
          return c.clientName.toLowerCase().contains(query) || c.clientEmail.toLowerCase().contains(query);
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
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
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
                        filtered = q.trim().isEmpty ? List<ClientItem>.from(_clients) : _clients.where((c) => matches(c, q)).toList();
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

  // ----------------------------------------------------------------------------
  // Staff (searchable)
  // ----------------------------------------------------------------------------
  Widget _staffField() {
    final selected = staffController.selectedStaff.value;
    final selectedText = selected?.name ?? selected?.username ?? 'Select a staff';

    return InkWell(
      onTap: staffController.isLoading.value ? null : () => _openStaffSearchSheet(staffController),
      child: InputDecorator(
        decoration: _inputDecoration().copyWith(
          hintText: staffController.isLoading.value ? 'Loading...' : 'Select a staff',
          hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
          suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
        ),
        child: Text(selectedText, style: _fieldTextStyle, overflow: TextOverflow.ellipsis),
      ),
    );
  }

  void _openStaffSearchSheet(StaffController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
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
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
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
                            setState(() {});
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

  // ----------------------------------------------------------------------------
  // UI
  // ----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    const labelSpacing = SizedBox(height: 6.0);

    ImageProvider avatarImage;
    if (_thumbnailFile != null) {
      avatarImage = FileImage(_thumbnailFile!);
    } else if (widget.job.thumbnail != null && widget.job.thumbnail!.isNotEmpty) {
      avatarImage = NetworkImage(widget.job.thumbnail!);
    } else {
      avatarImage = const AssetImage('assets/icons/istockphoto.jpg');
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
        title: const Text('Edit Job', style: TextStyle(color: Colors.white, fontSize: 18)),
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
                    CircleAvatar(radius: 45, backgroundImage: avatarImage),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: _pickThumbnail,
                      child: const Text(
                        'Change thumbnail picture',
                        style: TextStyle(color: Colors.blueAccent, decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              _label('Client Name'),
              labelSpacing,
              _clientField(),

              const SizedBox(height: 16),
              _label('Quotation No'),
              labelSpacing,
              TextFormField(
                controller: _quotationCtrl,
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
                controller: _latCtrl,
                style: _fieldTextStyle,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration().copyWith(
                  hintText: '51.5074',
                  hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null; // optional
                  if (double.tryParse(v.trim()) == null) return 'Enter valid latitude';
                  return null;
                },
              ),

              const SizedBox(height: 16),
              _label('Longitude'),
              labelSpacing,
              TextFormField(
                controller: _langCtrl,
                style: _fieldTextStyle,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration().copyWith(
                  hintText: '-0.1278',
                  hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null; // optional
                  if (double.tryParse(v.trim()) == null) return 'Enter valid longitude';
                  return null;
                },
              ),

              const SizedBox(height: 16),
              _label('Job designation'),
              labelSpacing,
              TextFormField(
                controller: _titleCtrl,
                style: _fieldTextStyle,
                decoration: _inputDecoration().copyWith(
                  hintText: 'Job',
                  hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
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
                  hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
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
                  hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Price is required';
                  final v = value.replaceAll('\$', '').trim();
                  if (double.tryParse(v) == null) return 'Enter a valid number';
                  return null;
                },
              ),

              const SizedBox(height: 18),
              _label('Assign to Staff'),
              labelSpacing,
              Obx(() => _staffField()),

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
                  hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                validator: _requiredValidator,
              ),

              const SizedBox(height: 18),
              _label('Method Statement (PDF)'),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(onPressed: _pickMethodStatementPdf, child: const Text('Choose file')),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _methodStatementFile != null ? _methodStatementFile!.path.split('/').last : 'No file selected',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),

              const SizedBox(height: 16),
              _label('Risk Assessment (PDF)'),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(onPressed: _pickRiskAssessmentPdf, child: const Text('Choose file')),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _riskAssessmentFile != null ? _riskAssessmentFile!.path.split('/').last : 'No file selected',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),

              const SizedBox(height: 16),
              _label('Photos'),
              const SizedBox(height: 8),
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (int i = 0; i < _newPhotos.length; i++)
                      _removablePhotoItem(
                        image: FileImage(_newPhotos[i]),
                        onRemove: () => setState(() => _newPhotos.removeAt(i)),
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
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : const Text('Save', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
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
      child: Text('Add photo +', style: TextStyle(color: Colors.white70, fontSize: 12)),
    ),
  );
}

// ============================================================================
// ✅ Photo item widget
// ============================================================================
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

// ============================================================================
// ✅ firstWhereOrNull (your code had empty extension - fixed)
// ============================================================================
extension FirstWhereOrNullExt<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}
