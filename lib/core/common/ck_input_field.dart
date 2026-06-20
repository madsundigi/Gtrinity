import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CKInputField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText; // 👈 optional error
  final void Function(String)? onChanged;

  const CKInputField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.onChanged,
  });

  @override
  State<CKInputField> createState() => _CKInputFieldState();
}

class _CKInputFieldState extends State<CKInputField>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          cursorColor: AppColors.white,
          style: const TextStyle(color: Color(0xFFF5F5F5)),
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            hintText: widget.hintText,
            labelText: widget.labelText,
            labelStyle:
            const TextStyle(color: AppColors.hintTextColor),
            hintStyle:
            const TextStyle(color: AppColors.hintTextColor),
            filled: true,
            fillColor: const Color(0xFF14181E),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
              const BorderSide(color: Color(0x80172A45)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
              const BorderSide(color: Color(0x80172A45)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
              const BorderSide(color: Color(0x80172A45), width: 1),
            ),
          ),
        ),

        /// 🔥 Animated Error Message
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: widget.errorText == null
              ? const SizedBox(height: 0)
              : Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
