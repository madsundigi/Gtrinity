import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:chef_king/core/constants/app_colors.dart';
import 'package:chef_king/core/common/ck_image.dart';
import 'package:chef_king/core/common/ck_snackbar.dart';
import 'package:chef_king/core/constants/app_assets.dart';
import 'package:chef_king/core/di/injection.dart';
import 'package:chef_king/data/local/app_cache/app_cache.dart';
import 'package:chef_king/data/models/auth/LoginResponse.dart';
import 'package:chef_king/domain/usecases/auth/AuthUseCase.dart';

/// Lets a guard view all of their details and edit only the fields they are
/// allowed to change. Admin-controlled fields (email, guard id/type, pay,
/// join date, account status) are shown read-only.
class EditProfileScreen extends StatefulWidget {
  final User user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _language;
  late final TextEditingController _height;
  late final TextEditingController _weight;
  late final TextEditingController _city;
  late final TextEditingController _state;
  late final TextEditingController _country;
  late final TextEditingController _zip;
  late final TextEditingController _address;

  String? _gender;
  DateTime? _dob;
  File? _pickedImage;
  bool _saving = false;

  static const _genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    final u = widget.user;
    final g = u.guards;
    _name = TextEditingController(text: u.name ?? '');
    _phone = TextEditingController(text: u.phoneNumber ?? '');
    _language = TextEditingController(text: g?.language ?? '');
    _height = TextEditingController(text: g?.height ?? '');
    _weight = TextEditingController(text: g?.weight ?? '');
    _city = TextEditingController(text: g?.city ?? '');
    _state = TextEditingController(text: g?.state ?? '');
    _country = TextEditingController(text: g?.country ?? '');
    _zip = TextEditingController(text: g?.zipCode ?? '');
    _address = TextEditingController(text: g?.address ?? '');
    _gender = _genders.contains(g?.gender) ? g?.gender : null;
    _dob = _tryParseDate(g?.dob);
  }

  @override
  void dispose() {
    for (final c in [
      _name, _phone, _language, _height, _weight,
      _city, _state, _country, _zip, _address,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  DateTime? _tryParseDate(String? s) {
    if (s == null || s.isEmpty) return null;
    try {
      return DateTime.parse(s);
    } catch (_) {
      return null;
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 25),
      firstDate: DateTime(1940),
      lastDate: now,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);

    final fields = <String, String>{
      'name': _name.text.trim(),
      'phone_number': _phone.text.trim(),
      'gender': _gender ?? '',
      'language': _language.text.trim(),
      'height': _height.text.trim(),
      'weight': _weight.text.trim(),
      'city': _city.text.trim(),
      'state': _state.text.trim(),
      'country': _country.text.trim(),
      'zip_code': _zip.text.trim(),
      'address': _address.text.trim(),
    };
    if (_dob != null) {
      fields['dob'] = DateFormat('yyyy-MM-dd').format(_dob!);
    }
    final files = <String, File>{};
    if (_pickedImage != null) files['profile_image'] = _pickedImage!;

    try {
      final updated = await sl<AuthUseCase>()
          .updateProfile(fields: fields, files: files);
      await _persist(updated);
      if (!mounted) return;
      CKSnackBar.showSuccess(context, 'Profile updated successfully');
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      CKSnackBar.showError(context, e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Writes the refreshed user back into the cached login response so the
  /// rest of the app (Profile/Home) reflects the change immediately.
  Future<void> _persist(User updated) async {
    final existing = AppCache.getLoginResponse();
    final merged = LoginResponse(
      success: existing?.success ?? true,
      message: existing?.message,
      data: LoginData(token: existing?.data?.token, user: updated),
    );
    await AppCache.saveLoginResponse(merged);
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.user;
    final g = u.guards;
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Edit Profile',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            _avatar(u),
            const SizedBox(height: 28),
            _sectionTitle('Account'),
            _field('Full Name', _name, required: true),
            _field('Phone Number', _phone,
                keyboard: TextInputType.phone),
            const SizedBox(height: 8),
            _sectionTitle('Personal Details'),
            _genderDropdown(),
            _dobField(),
            _field('Language', _language),
            Row(children: [
              Expanded(
                  child: _field('Height (cm)', _height,
                      keyboard: TextInputType.number)),
              const SizedBox(width: 12),
              Expanded(
                  child: _field('Weight (kg)', _weight,
                      keyboard: TextInputType.number)),
            ]),
            const SizedBox(height: 8),
            _sectionTitle('Address'),
            _field('Address', _address, maxLines: 2),
            Row(children: [
              Expanded(child: _field('City', _city)),
              const SizedBox(width: 12),
              Expanded(child: _field('State', _state)),
            ]),
            Row(children: [
              Expanded(child: _field('Country', _country)),
              const SizedBox(width: 12),
              Expanded(
                  child: _field('Zip Code', _zip,
                      keyboard: TextInputType.number)),
            ]),
            const SizedBox(height: 12),
            _sectionTitle('Managed by Admin (read-only)'),
            _readonly('Email', u.email),
            _readonly('Guard ID', g?.guardId?.toString()),
            _readonly('Guard Type', g?.guardType?.toString()),
            _readonly('Pay / Hour',
                g?.payPerHour == null ? null : '₹ ${g?.payPerHour}'),
            _readonly('Join Date', g?.joinDate),
            _readonly(
                'Account Status', u.isActive == 1 ? 'Active' : 'Disabled'),
            const SizedBox(height: 28),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: _saving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Save Changes',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatar(User u) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryBlue, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(55),
              child: _pickedImage != null
                  ? Image.file(_pickedImage!, fit: BoxFit.cover)
                  : CKImage(
                      imagePath: u.profile ?? AppAssets.profileIcon,
                      fit: BoxFit.cover,
                      placeholder: AppAssets.profileIcon,
                    ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt,
                    size: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 10),
        child: Text(text.toUpperCase(),
            style: const TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8)),
      );

  Widget _field(
    String label,
    TextEditingController c, {
    bool required = false,
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        keyboardType: keyboard,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        validator: required
            ? (v) => (v == null || v.trim().isEmpty) ? '$label is required' : null
            : null,
        decoration: _inputDecoration(label),
      ),
    );
  }

  Widget _genderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: _gender,
        dropdownColor: AppColors.buttonColor,
        style: const TextStyle(color: Colors.white),
        iconEnabledColor: AppColors.subTitleTextColor,
        decoration: _inputDecoration('Gender'),
        items: _genders
            .map((g) => DropdownMenuItem(value: g, child: Text(g)))
            .toList(),
        onChanged: (v) => setState(() => _gender = v),
      ),
    );
  }

  Widget _dobField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: _pickDob,
        child: InputDecorator(
          decoration: _inputDecoration('Date of Birth'),
          child: Text(
            _dob == null
                ? 'Select date'
                : DateFormat('dd MMM yyyy').format(_dob!),
            style: TextStyle(
                color: _dob == null
                    ? AppColors.hintTextColor
                    : Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _readonly(String label, String? value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.buttonColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.subTitleTextColor, fontSize: 13)),
          ),
          Flexible(
            child: Text(
              (value == null || value.isEmpty) ? '—' : value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.lock_outline,
              size: 14, color: AppColors.hintTextColor),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: c),
        );
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.hintTextColor),
      filled: true,
      fillColor: AppColors.buttonColor.withOpacity(0.4),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: border(AppColors.buttonColor),
      focusedBorder: border(AppColors.primaryBlue),
      errorBorder: border(Colors.redAccent),
      focusedErrorBorder: border(Colors.redAccent),
    );
  }
}
