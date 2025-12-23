import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:williamharri/src/core/constants/api_endpoints.dart';
import 'package:williamharri/src/core/services/app_pigeon/app_pigeon.dart';
import 'package:williamharri/src/module/home/controller/job_controller.dart';
import 'package:williamharri/src/module/home/model/job_cart_model.dart';
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

  /// ✅ REQUIRED FORMAT: clientName-(email)
  String get display => '$clientName-($clientEmail)';
}

class EditJobScreen extends StatefulWidget {
  final JobModel job;

  const EditJobScreen({super.key, required this.job});

  @override
  State<EditJobScreen> createState() => _EditJobScreenState();
}

class _EditJobScreenState extends State<EditJobScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _priceCtrl;

  // ✅ Clients (search + auto select)
  bool _clientsLoading = false;
  final List<ClientItem> _clients = [];
  ClientItem? _selectedClient;

  String? _initialClientId;
  String? _initialClientName;
  String? _initialClientEmail;

  // ✅ Staff (search + auto select)
  final StaffController staffController = Get.find<StaffController>();
  Worker? _staffLoadingWorker;

  final ImagePicker _picker = ImagePicker();

  File? _thumbnailFile;
  final List<File> _newPhotos = [];

  File? _methodStatementFile;
  File? _riskAssessmentFile;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _titleCtrl = TextEditingController(text: widget.job.title);
    _locationCtrl = TextEditingController(text: widget.job.location);
    _descriptionCtrl = TextEditingController(text: widget.job.description);
    _priceCtrl = TextEditingController(text: widget.job.price.toString());


    // ✅ read client info for auto-select
    _readInitialClientFromJob(widget.job);

    // ✅ auto-select staff after list loads
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
    _staffLoadingWorker?.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // ✅ Read initial client info from job
  // ---------------------------------------------------------------------------
  void _readInitialClientFromJob(JobModel job) {
    try {
      final dynamic j = job;

      final dynamic cid = j.clientId;
      if (cid != null && cid.toString().trim().isNotEmpty) {
        _initialClientId = cid.toString().trim();
      }

      final dynamic client = j.client;

      if (_initialClientId == null) {
        if (client is String && client.trim().isNotEmpty) _initialClientId = client.trim();
      }

      if (client is Map) {
        final dynamic id = client['id'] ?? client['_id'];
        final dynamic name = client['clientName'] ?? client['name'];
        final dynamic email = client['clientEmail'] ?? client['email'];

        if (_initialClientId == null && id != null) _initialClientId = id.toString();
        if (name != null && name.toString().trim().isNotEmpty) _initialClientName = name.toString().trim();
        if (email != null && email.toString().trim().isNotEmpty) _initialClientEmail = email.toString().trim();
      } else {
        try {
          final dynamic id = client?.id ?? client?._id ?? client?.sId;
          final dynamic name = client?.clientName ?? client?.name;
          final dynamic email = client?.clientEmail ?? client?.email;

          if (_initialClientId == null && id != null) _initialClientId = id.toString();
          if (name != null && name.toString().trim().isNotEmpty) _initialClientName = name.toString().trim();
          if (email != null && email.toString().trim().isNotEmpty) _initialClientEmail = email.toString().trim();
        } catch (_) {}
      }

      // old backend stores clientName in companyName
      final dynamic companyName = j.companyName;
      if (companyName != null && companyName.toString().trim().isNotEmpty) {
        _initialClientName ??= companyName.toString().trim();
      }

      try {
        final dynamic ce = j.clientEmail;
        if (ce != null && ce.toString().trim().isNotEmpty) {
          _initialClientEmail ??= ce.toString().trim();
        }
      } catch (_) {}
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // ✅ Auto select staff from job
  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  // ✅ Fetch Clients + auto select
  // ---------------------------------------------------------------------------
  Future<void> _fetchClients() async {
    setState(() => _clientsLoading = true);

    try {
      final appPigeon = Get.find<AppPigeon>();
      final res = await appPigeon.get(ApiEndpoints.clients);

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

      _applyClientPreselect();

      setState(() {});
    } catch (e) {
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

      if (pick != null) {
        _selectedClient = pick;
        return;
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Pickers
  // ---------------------------------------------------------------------------
  Future<void> _pickThumbnail() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _thumbnailFile = File(picked.path));
  }




  // ---------------------------------------------------------------------------
  // ✅ SAVE
  // ---------------------------------------------------------------------------
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

    setState(() => _isSaving = true);

    final appPigeon = Get.find<AppPigeon>();
    final jobsController = Get.find<JobController>();
    final cleanedPrice = _priceCtrl.text.trim().replaceAll('\$', '').trim();

    final Map<String, dynamic> dataMap = {
      'clientId': clientId,
      'client': clientId,
      'title': title,
      'location': location,
      'description': _descriptionCtrl.text.trim(),
      'price': cleanedPrice,
      'assigneTo': staff.id!,
      'assignedTo': [staff.id],
    };

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
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ---------------------------------------------------------------------------
  // UI helpers
  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  // Client (searchable)
  // ---------------------------------------------------------------------------
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
                  Container(height: 4, width: 44, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8))),
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

  // ---------------------------------------------------------------------------
  // Staff (searchable)
  // ---------------------------------------------------------------------------
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
                  Container(height: 4, width: 44, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8))),
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
                        filtered = q.trim().isEmpty ? List<ProfileModel>.from(controller.staffList) : controller.staffList.where((s) => matches(s, q)).toList();
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

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    const labelSpacing = SizedBox(height: 6.0);

    ImageProvider avatarImage;
    if (_thumbnailFile != null) {
      avatarImage = FileImage(_thumbnailFile!);
    } else if (widget.job.thumbnail != null && widget.job.thumbnail!.isNotEmpty) {
      avatarImage = NetworkImage(widget.job.thumbnail!);
    } else {
      avatarImage = const NetworkImage('https://images.unsplash.com/photo-1600585154340-be6161a56a0c');
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
}

extension _FirstWhereOrNullExt<E> on Iterable<E> {
}