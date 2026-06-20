import 'package:chef_king/core/imports/app_imports.dart';
import 'package:chef_king/data/models/auth/LoginResponse.dart';
import 'package:chef_king/presentation/documents/cubit/document_cubit.dart';
import 'package:chef_king/presentation/documents/upload_document_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

/// One mandatory/driving document slot the guard can view and replace.
class _DocSlot {
  final String title;
  final String fileField;   // updateProfile file key, e.g. 'security_license'
  final String expireField; // updateProfile date key, e.g. 'security_license_expire'
  final String? fileName;   // stored file on server (null = not uploaded)
  final String? expire;     // expiry date string (yyyy-MM-dd)
  const _DocSlot(this.title, this.fileField, this.expireField, this.fileName, this.expire);
}

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  Guard? _guard;
  bool _changed = false;

  @override
  void initState() {
    super.initState();
    _guard = AppCache.getLoginResponse()?.data?.user?.guards;
  }

  List<_DocSlot> get _slots {
    final g = _guard;
    return [
      _DocSlot('Security License', 'security_license', 'security_license_expire',
          g?.securityLicense, g?.securityLicenseExpire),
      _DocSlot('First Aid Certificate', 'first_aid', 'first_aid_expire',
          g?.firstAid, g?.firstAidExpire),
      _DocSlot('RSA', 'rsa', 'rsa_expire', g?.rsa, g?.rsaExpire),
      _DocSlot('Driving License', 'driving_license', 'dl_expire_date',
          g?.drivingLicense, g?.dlExpireDate),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DocumentCubit>()..fetchDocuments(),
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, _changed);
          return false;
        },
        child: Scaffold(
          backgroundColor: AppColors.darkBackground,
          appBar: AppBar(
            backgroundColor: AppColors.darkBackground,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const CKText('My Documents',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              _sectionHeader('Mandatory Documents'),
              const SizedBox(height: 12),
              ..._slots.map(_mandatoryCard),
              const SizedBox(height: 24),
              _sectionHeader('Other Documents'),
              const SizedBox(height: 12),
              _additionalDocs(),
            ],
          ),
          floatingActionButton: Builder(
            builder: (innerContext) => FloatingActionButton.extended(
              onPressed: () async {
                final result = await Navigator.push(
                  innerContext,
                  MaterialPageRoute(
                      builder: (_) => const UploadDocumentScreen()),
                );
                if (result == true) {
                  innerContext.read<DocumentCubit>().fetchDocuments();
                }
              },
              backgroundColor: AppColors.primaryBlue,
              label: const CKText('ADD OTHER',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              icon: const Icon(Icons.upload_file, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String text) => CKText(
        text.toUpperCase(),
        style: const TextStyle(
            color: AppColors.primaryBlue,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8),
      );

  // ---- Mandatory document card ----
  Widget _mandatoryCard(_DocSlot slot) {
    final status = _expiryStatus(slot.fileName, slot.expire);
    final hasFile = slot.fileName != null && slot.fileName!.isNotEmpty;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.buttonColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: status.color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: status.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  hasFile
                      ? (slot.fileName!.toLowerCase().endsWith('.pdf')
                          ? Icons.picture_as_pdf
                          : Icons.description)
                      : Icons.upload_file_outlined,
                  color: status.color,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CKText(slot.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                    const SizedBox(height: 4),
                    CKText(
                      slot.expire == null || slot.expire!.isEmpty
                          ? (hasFile ? 'No expiry date set' : 'Not uploaded')
                          : 'Expires: ${_fmt(slot.expire!)}',
                      style: const TextStyle(
                          color: AppColors.subTitleTextColor, fontSize: 11),
                    ),
                  ],
                ),
              ),
              _statusBadge(status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (hasFile)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewDocument(slot),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryBlue,
                      side: const BorderSide(color: AppColors.primaryBlue),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.visibility_outlined, size: 18),
                    label: const Text('View'),
                  ),
                ),
              if (hasFile) const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _replaceDocument(slot),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: Icon(hasFile ? Icons.refresh : Icons.add, size: 18),
                  label: Text(hasFile ? 'Replace' : 'Upload'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---- Additional documents list (source: DocumentCubit) ----
  Widget _additionalDocs() {
    return BlocBuilder<DocumentCubit, DocumentState>(
      builder: (context, state) {
        if (state is DocumentLoading) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
                child: CircularProgressIndicator(color: AppColors.primaryBlue)),
          );
        } else if (state is DocumentsLoaded) {
          if (state.documents.isEmpty) {
            return _emptyHint('No additional documents uploaded.');
          }
          return Column(
            children: state.documents.map((doc) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.buttonColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        doc.filePath?.endsWith('.pdf') == true
                            ? Icons.picture_as_pdf
                            : Icons.image,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CKText(doc.name ?? 'Untitled Document',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                          const SizedBox(height: 4),
                          CKText(
                            doc.uploadDate == null
                                ? ''
                                : 'Uploaded: ${_fmt(doc.uploadDate!)}',
                            style: const TextStyle(
                                color: AppColors.subTitleTextColor,
                                fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    _simpleBadge(doc.status),
                  ],
                ),
              );
            }).toList(),
          );
        } else if (state is DocumentError) {
          return _emptyHint('Error: ${state.message}');
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _emptyHint(String text) => Container(
        padding: const EdgeInsets.symmetric(vertical: 28),
        alignment: Alignment.center,
        child: Column(
          children: [
            Icon(Icons.folder_open_outlined,
                size: 48, color: AppColors.subTitleTextColor.withOpacity(0.5)),
            const SizedBox(height: 10),
            CKText(text,
                style: const TextStyle(color: AppColors.subTitleTextColor)),
          ],
        ),
      );

  // ---- View a stored document ----
  void _viewDocument(_DocSlot slot) {
    final url = ApiConstants.documentUrl(slot.fileName!);
    final isPdf = slot.fileName!.toLowerCase().endsWith('.pdf');
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColors.darkSurface,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CKText(slot.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              const SizedBox(height: 14),
              if (isPdf)
                Column(
                  children: [
                    const Icon(Icons.picture_as_pdf,
                        size: 64, color: AppColors.primaryBlue),
                    const SizedBox(height: 12),
                    CKText(slot.fileName!,
                        style: const TextStyle(
                            color: AppColors.subTitleTextColor, fontSize: 12)),
                    const SizedBox(height: 6),
                    const CKText('Open in a browser to view the PDF.',
                        style: TextStyle(
                            color: AppColors.subTitleTextColor, fontSize: 11)),
                  ],
                )
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 360),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      url,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Padding(
                        padding: EdgeInsets.all(24),
                        child: Icon(Icons.broken_image,
                            color: Colors.grey, size: 48),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              SelectableText(url,
                  style: const TextStyle(
                      color: AppColors.hintTextColor, fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Replace / upload a mandatory document ----
  Future<void> _replaceDocument(_DocSlot slot) async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    final path = picked?.files.single.path;
    if (path == null) return;
    if (!mounted) return;

    DateTime? expiry = _tryDate(slot.expire);
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.darkSurface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (sheetCtx, setSheet) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                  20, 20, 20, MediaQuery.of(sheetCtx).viewInsets.bottom + 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CKText('Upload ${slot.title}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  CKText(path.split('/').last,
                      style: const TextStyle(
                          color: AppColors.primaryBlue, fontSize: 12)),
                  const SizedBox(height: 18),
                  InkWell(
                    onTap: () async {
                      final now = DateTime.now();
                      final d = await showDatePicker(
                        context: sheetCtx,
                        initialDate: expiry ?? now,
                        firstDate: DateTime(now.year - 1),
                        lastDate: DateTime(now.year + 20),
                      );
                      if (d != null) setSheet(() => expiry = d);
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Expiry Date',
                        labelStyle:
                            const TextStyle(color: AppColors.hintTextColor),
                        filled: true,
                        fillColor: AppColors.buttonColor,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                      ),
                      child: Text(
                        expiry == null
                            ? 'Select expiry date'
                            : DateFormat('dd MMM yyyy').format(expiry!),
                        style: TextStyle(
                            color: expiry == null
                                ? AppColors.hintTextColor
                                : Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(sheetCtx, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Save Document',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (confirmed != true || !mounted) return;
    await _submitDoc(slot, File(path), expiry);
  }

  Future<void> _submitDoc(_DocSlot slot, File file, DateTime? expiry) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryBlue)),
    );
    try {
      final fields = <String, String>{};
      if (expiry != null) {
        fields[slot.expireField] = DateFormat('yyyy-MM-dd').format(expiry);
      }
      await sl<AuthUseCase>()
          .updateProfile(fields: fields, files: {slot.fileField: file});
      // Pull fresh profile so the new file name + expiry are reflected.
      final fresh = await sl<AuthUseCase>().getProfile();
      final existing = AppCache.getLoginResponse();
      await AppCache.saveLoginResponse(LoginResponse(
        success: existing?.success ?? true,
        message: existing?.message,
        data: LoginData(token: existing?.data?.token, user: fresh),
      ));
      if (!mounted) return;
      Navigator.pop(context); // close loader
      setState(() {
        _guard = fresh.guards;
        _changed = true;
      });
      CKSnackBar.showSuccess(context, '${slot.title} uploaded successfully');
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // close loader
      CKSnackBar.showError(context, e.toString());
    }
  }

  // ---- helpers ----
  DateTime? _tryDate(String? s) {
    if (s == null || s.isEmpty) return null;
    try {
      return DateTime.parse(s);
    } catch (_) {
      return null;
    }
  }

  String _fmt(String raw) {
    final d = _tryDate(raw);
    return d == null ? raw : DateFormat('dd MMM yyyy').format(d);
  }

  _Status _expiryStatus(String? fileName, String? expire) {
    if (fileName == null || fileName.isEmpty) {
      return const _Status('MISSING', AppColors.hintTextColor);
    }
    final d = _tryDate(expire);
    if (d == null) {
      return const _Status('NO EXPIRY', Colors.orangeAccent);
    }
    final days = d.difference(DateTime.now()).inDays;
    if (days < 0) return const _Status('EXPIRED', Colors.redAccent);
    if (days <= 30) return const _Status('EXPIRING', Colors.orangeAccent);
    return const _Status('VALID', AppColors.greenColor);
  }

  Widget _statusBadge(_Status s) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: s.color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: s.color.withOpacity(0.5)),
        ),
        child: CKText(s.label,
            style: TextStyle(
                color: s.color, fontSize: 9, fontWeight: FontWeight.bold)),
      );

  Widget _simpleBadge(String? status) {
    Color color;
    switch (status?.toLowerCase()) {
      case 'verified':
        color = AppColors.greenColor;
        break;
      case 'pending':
        color = Colors.orangeAccent;
        break;
      case 'rejected':
        color = Colors.redAccent;
        break;
      default:
        color = AppColors.primaryBlue;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: CKText(status?.toUpperCase() ?? 'PENDING',
          style: TextStyle(
              color: color, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }
}

class _Status {
  final String label;
  final Color color;
  const _Status(this.label, this.color);
}
