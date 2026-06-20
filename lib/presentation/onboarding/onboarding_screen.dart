import 'dart:io';
import 'package:chef_king/core/common/ck_snackbar.dart';
import 'package:chef_king/core/constants/app_colors.dart';
import 'package:chef_king/core/di/injection.dart';
import 'package:chef_king/core/routes/app_routes.dart';
import 'package:chef_king/data/local/app_cache/app_cache.dart';
import 'package:chef_king/data/models/auth/LoginResponse.dart';
import 'package:chef_king/domain/repositories/auth/auth_repository.dart';
import 'package:chef_king/domain/usecases/auth/AuthUseCase.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// First-login self-onboarding. The guard is locked here until they fill the
/// required identity + address fields and upload the 3 mandatory documents
/// (each with an expiry). On a valid submit the server auto-activates them and
/// the app moves to the dashboard — no admin approval.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _page = PageController();
  int _step = 0;
  bool _submitting = false;

  // Identity + address
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _height = TextEditingController();
  final _weight = TextEditingController();
  final _language = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _country = TextEditingController();
  final _zip = TextEditingController();
  String? _gender;
  DateTime? _dob;

  // Documents (mandatory) + driving licence (optional)
  File? _securityLicense;
  DateTime? _securityLicenseExpire;
  File? _firstAid;
  DateTime? _firstAidExpire;
  File? _rsa;
  DateTime? _rsaExpire;
  File? _drivingLicense;
  final _dlNumber = TextEditingController();
  DateTime? _dlExpire;

  // Existing (admin pre-filled) doc presence
  bool _hasSL = false, _hasFA = false, _hasRSA = false;

  // Admin correction flags + server field errors
  Map<String, String> _flags = const {};
  Map<String, String> _errors = {};

  static const _genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    final g = AppCache.getLoginResponse()?.data?.user;
    final guard = g?.guards;
    _name.text = g?.name ?? '';
    _phone.text = g?.phoneNumber ?? '';
    _language.text = guard?.language ?? '';
    _height.text = guard?.height ?? '';
    _weight.text = guard?.weight ?? '';
    _address.text = guard?.address ?? '';
    _city.text = guard?.city ?? '';
    _state.text = guard?.state ?? '';
    _country.text = guard?.country ?? '';
    _zip.text = guard?.zipCode ?? '';
    _dlNumber.text = guard?.dlNumber ?? '';
    _gender = _genders.contains(guard?.gender) ? guard?.gender : null;
    _dob = _tryDate(guard?.dob);
    _securityLicenseExpire = _tryDate(guard?.securityLicenseExpire);
    _firstAidExpire = _tryDate(guard?.firstAidExpire);
    _rsaExpire = _tryDate(guard?.rsaExpire);
    _dlExpire = _tryDate(guard?.dlExpireDate);
    _hasSL = (guard?.securityLicense ?? '').isNotEmpty;
    _hasFA = (guard?.firstAid ?? '').isNotEmpty;
    _hasRSA = (guard?.rsa ?? '').isNotEmpty;
    _flags = guard?.fieldFlags ?? const {};
  }

  @override
  void dispose() {
    for (final c in [
      _name, _phone, _height, _weight, _language, _address,
      _city, _state, _country, _zip, _dlNumber,
    ]) {
      c.dispose();
    }
    _page.dispose();
    super.dispose();
  }

  DateTime? _tryDate(String? s) {
    if (s == null || s.isEmpty) return null;
    try {
      return DateTime.parse(s);
    } catch (_) {
      return null;
    }
  }

  /// Keeps a date-picker's initialDate inside [first, last]. Pre-filled values
  /// from the server (e.g. an already-expired licence, or an out-of-range DOB)
  /// can otherwise fall outside the picker bounds and break it.
  DateTime _clampInitial(DateTime? value, DateTime first, DateTime last) {
    var d = value ?? (last.isBefore(DateTime.now()) ? last : DateTime.now());
    if (d.isBefore(first)) d = first;
    if (d.isAfter(last)) d = last;
    return d;
  }

  String _fmt(DateTime d) => DateFormat('dd MMM yyyy').format(d);
  String _api(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  // ---------------------------------------------------------------- submit
  Future<void> _submit() async {
    setState(() {
      _errors = {};
      _submitting = true;
    });

    final fields = <String, String>{
      'name': _name.text.trim(),
      'phone_number': _phone.text.trim(),
      'gender': _gender ?? '',
      'language': _language.text.trim(),
      'height': _height.text.trim(),
      'weight': _weight.text.trim(),
      'address': _address.text.trim(),
      'city': _city.text.trim(),
      'state': _state.text.trim(),
      'country': _country.text.trim(),
      'zip_code': _zip.text.trim(),
      'dl_number': _dlNumber.text.trim(),
    };
    if (_dob != null) fields['dob'] = _api(_dob!);
    if (_securityLicenseExpire != null) {
      fields['security_license_expire'] = _api(_securityLicenseExpire!);
    }
    if (_firstAidExpire != null) {
      fields['first_aid_expire'] = _api(_firstAidExpire!);
    }
    if (_rsaExpire != null) fields['rsa_expire'] = _api(_rsaExpire!);
    if (_dlExpire != null) fields['dl_expire_date'] = _api(_dlExpire!);

    final files = <String, File>{};
    if (_securityLicense != null) files['security_license'] = _securityLicense!;
    if (_firstAid != null) files['first_aid'] = _firstAid!;
    if (_rsa != null) files['rsa'] = _rsa!;
    if (_drivingLicense != null) files['driving_license'] = _drivingLicense!;

    try {
      final user =
          await sl<AuthUseCase>().completeOnboarding(fields: fields, files: files);
      // Persist the activated user so the dashboard reflects it immediately.
      final existing = AppCache.getLoginResponse();
      await AppCache.saveLoginResponse(LoginResponse(
        success: existing?.success ?? true,
        message: existing?.message,
        data: LoginData(token: existing?.data?.token, user: user),
      ));
      if (!mounted) return;
      CKSnackBar.showSuccess(context, 'Guard setup profile successfully');
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.main, (route) => false);
    } on OnboardingValidation catch (v) {
      if (!mounted) return;
      setState(() => _errors = v.errors);
      // Jump to the step holding the first error.
      final docKeys = {
        'security_license', 'security_license_expire',
        'first_aid', 'first_aid_expire', 'rsa', 'rsa_expire',
      };
      final firstDocError = _errors.keys.any(docKeys.contains);
      final firstDetailError =
          _errors.keys.any((k) => !docKeys.contains(k));
      _goTo(firstDetailError ? 0 : (firstDocError ? 1 : _step));
      CKSnackBar.showError(context, 'Please fix the highlighted fields.');
    } catch (e) {
      if (!mounted) return;
      CKSnackBar.showError(context, e.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _goTo(int step) {
    setState(() => _step = step);
    _page.animateToPage(step,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  Future<void> _logout() async {
    try {
      await sl<AuthUseCase>().logout();
    } catch (_) {}
    await AppCache.clear();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
  }

  // ---------------------------------------------------------------- build
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // locked: no back-out of onboarding
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          backgroundColor: AppColors.darkBackground,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text('Complete Your Profile',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          actions: [
            TextButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout, size: 18, color: Colors.redAccent),
              label: const Text('Logout',
                  style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        ),
        body: Column(
          children: [
            _progress(),
            // Hide the admin-flag banner once the guard has attempted a submit
            // (server per-field errors take over and the flags may be stale).
            if (_flags.isNotEmpty && _errors.isEmpty) _flagBanner(),
            Expanded(
              child: PageView(
                controller: _page,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _step = i),
                children: [_stepDetails(), _stepDocuments()],
              ),
            ),
            _bottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _progress() {
    Widget dot(int i, String label) {
      final active = _step == i;
      final done = _step > i;
      final color = done || active ? AppColors.primaryBlue : AppColors.buttonColor;
      return Expanded(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Container(
                        height: 3,
                        color: i == 0 ? Colors.transparent : color)),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: color,
                  child: done
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : Text('${i + 1}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                ),
                Expanded(
                    child: Container(
                        height: 3,
                        color: i == 1 ? Colors.transparent : color)),
              ],
            ),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(
                    color: active ? Colors.white : AppColors.subTitleTextColor,
                    fontSize: 12,
                    fontWeight: active ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      child: Row(children: [dot(0, 'Your Details'), dot(1, 'Documents')]),
    );
  }

  Widget _flagBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your admin asked you to fix these:',
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                const SizedBox(height: 4),
                ..._flags.entries.map((e) => Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text('• ${_label(e.key)}: ${e.value}',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12)),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------- step 1: details
  Widget _stepDetails() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      children: [
        _sectionTitle('Identity'),
        _text('Full Name', _name, field: 'name'),
        _text('Phone Number', _phone,
            field: 'phone_number', keyboard: TextInputType.phone),
        _genderField(),
        _dateField('Date of Birth', _dob, 'dob', (d) => setState(() => _dob = d),
            first: DateTime(1940), last: DateTime.now()),
        Row(children: [
          Expanded(
              child: _text('Height (cm)', _height,
                  field: 'height', keyboard: TextInputType.number)),
          const SizedBox(width: 12),
          Expanded(
              child: _text('Weight (kg)', _weight,
                  field: 'weight', keyboard: TextInputType.number)),
        ]),
        _text('Language', _language, field: 'language'),
        const SizedBox(height: 8),
        _sectionTitle('Address'),
        _text('Address', _address, field: 'address', maxLines: 2),
        Row(children: [
          Expanded(child: _text('City', _city, field: 'city')),
          const SizedBox(width: 12),
          Expanded(child: _text('State', _state, field: 'state')),
        ]),
        Row(children: [
          Expanded(child: _text('Country', _country, field: 'country')),
          const SizedBox(width: 12),
          Expanded(
              child: _text('Zip Code', _zip,
                  field: 'zip_code', keyboard: TextInputType.number)),
        ]),
        // Client/site assignment is handled by the admin via rostering, not here.
      ],
    );
  }

  // ------------------------------------------------------ step 2: documents
  Widget _stepDocuments() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      children: [
        _sectionTitle('Mandatory Documents'),
        const Text('Upload each document and set its expiry date.',
            style: TextStyle(color: AppColors.subTitleTextColor, fontSize: 12)),
        const SizedBox(height: 12),
        _docCard('Security License', 'security_license', _securityLicense, _hasSL,
            _securityLicenseExpire, (f) => setState(() => _securityLicense = f),
            (d) => setState(() => _securityLicenseExpire = d)),
        _docCard('First Aid Certificate', 'first_aid', _firstAid, _hasFA,
            _firstAidExpire, (f) => setState(() => _firstAid = f),
            (d) => setState(() => _firstAidExpire = d)),
        _docCard('RSA', 'rsa', _rsa, _hasRSA, _rsaExpire,
            (f) => setState(() => _rsa = f), (d) => setState(() => _rsaExpire = d)),
        const SizedBox(height: 8),
        _sectionTitle('Driving License (optional)'),
        _docCard('Driving License', 'driving_license', _drivingLicense, false,
            _dlExpire, (f) => setState(() => _drivingLicense = f),
            (d) => setState(() => _dlExpire = d)),
        _text('DL Number', _dlNumber, field: 'dl_number'),
      ],
    );
  }

  Widget _docCard(
    String title,
    String field,
    File? picked,
    bool alreadyUploaded,
    DateTime? expire,
    ValueChanged<File> onFile,
    ValueChanged<DateTime> onExpire,
  ) {
    final err = _errors[field] ?? _errors['${field}_expire'];
    final hasFile = picked != null || alreadyUploaded;
    // "Ready" (green) only when both the file AND an expiry are present, so a
    // missing expiry is visible before the guard taps Finish.
    final ready = hasFile && expire != null;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.buttonColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: err != null
                ? Colors.redAccent
                : (ready ? AppColors.greenColor.withOpacity(0.5) : Colors.transparent)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(ready ? Icons.check_circle : Icons.upload_file_outlined,
                  color: ready ? AppColors.greenColor : AppColors.subTitleTextColor,
                  size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final res = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                  );
                  final p = res?.files.single.path;
                  if (p != null) onFile(File(p));
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryBlue,
                  side: const BorderSide(color: AppColors.primaryBlue),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.attach_file, size: 18),
                label: Text(
                    picked != null
                        ? picked.path.split('/').last
                        : (alreadyUploaded ? 'Replace file' : 'Choose file'),
                    overflow: TextOverflow.ellipsis),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              final now = DateTime.now();
              final first = DateTime(now.year - 1);
              final last = DateTime(now.year + 20);
              final d = await showDatePicker(
                context: context,
                initialDate: _clampInitial(expire, first, last),
                firstDate: first,
                lastDate: last,
              );
              if (d != null) onExpire(d);
            },
            child: InputDecorator(
              decoration: _dec('Expiry Date'),
              child: Text(expire == null ? 'Select expiry date' : _fmt(expire),
                  style: TextStyle(
                      color: expire == null
                          ? AppColors.hintTextColor
                          : Colors.white)),
            ),
          ),
          if (err != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(err,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------- bottom
  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(color: AppColors.darkBackground),
      child: Row(
        children: [
          if (_step == 1)
            Expanded(
              child: OutlinedButton(
                onPressed: _submitting ? null : () => _goTo(0),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.buttonColor),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Back'),
              ),
            ),
          if (_step == 1) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _submitting
                  ? null
                  : (_step == 0 ? () => _goTo(1) : _submit),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: _submitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text(_step == 0 ? 'Next' : 'Finish Setup',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------- helpers
  Widget _sectionTitle(String t) => Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Text(t.toUpperCase(),
            style: const TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8)),
      );

  Widget _text(String label, TextEditingController c,
      {required String field,
      TextInputType keyboard = TextInputType.text,
      int maxLines = 1}) {
    final err = _errors[field];
    final flag = _flags[field];
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: c,
            keyboardType: keyboard,
            maxLines: maxLines,
            style: const TextStyle(color: Colors.white),
            decoration: _dec(label, hasError: err != null),
          ),
          if (err != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text(err,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
            )
          else if (flag != null && _errors.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text('Admin: $flag',
                  style: const TextStyle(
                      color: Colors.orangeAccent, fontSize: 12)),
            ),
        ],
      ),
    );
  }

  Widget _genderField() {
    final err = _errors['gender'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: _gender,
        dropdownColor: AppColors.buttonColor,
        style: const TextStyle(color: Colors.white),
        iconEnabledColor: AppColors.subTitleTextColor,
        decoration: _dec('Gender', hasError: err != null),
        items: _genders
            .map((g) => DropdownMenuItem(value: g, child: Text(g)))
            .toList(),
        onChanged: (v) => setState(() => _gender = v),
      ),
    );
  }

  Widget _dateField(String label, DateTime? value, String field,
      ValueChanged<DateTime> onPick,
      {required DateTime first, required DateTime last}) {
    final err = _errors[field];
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              final d = await showDatePicker(
                context: context,
                initialDate: _clampInitial(value ?? DateTime(last.year - 20), first, last),
                firstDate: first,
                lastDate: last,
              );
              if (d != null) onPick(d);
            },
            child: InputDecorator(
              decoration: _dec(label, hasError: err != null),
              child: Text(value == null ? 'Select date' : _fmt(value),
                  style: TextStyle(
                      color: value == null
                          ? AppColors.hintTextColor
                          : Colors.white)),
            ),
          ),
          if (err != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text(err,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
            ),
        ],
      ),
    );
  }

  InputDecoration _dec(String label, {bool hasError = false}) {
    OutlineInputBorder b(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: c));
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.hintTextColor),
      filled: true,
      fillColor: AppColors.buttonColor.withOpacity(0.4),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: b(hasError ? Colors.redAccent : AppColors.buttonColor),
      focusedBorder: b(hasError ? Colors.redAccent : AppColors.primaryBlue),
    );
  }

  String _label(String key) {
    const map = {
      'name': 'Name',
      'phone_number': 'Phone',
      'dob': 'Date of Birth',
      'gender': 'Gender',
      'address': 'Address',
      'city': 'City',
      'state': 'State',
      'country': 'Country',
      'zip_code': 'Zip Code',
      'security_license': 'Security License',
      'first_aid': 'First Aid',
      'rsa': 'RSA',
    };
    return map[key] ?? key;
  }
}
