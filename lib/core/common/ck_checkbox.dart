import 'package:flutter/material.dart';

class CKCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String? text;

  const CKCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4), // 👈 radius 4
              ),
              side: const BorderSide(
                color: Color(0xFF6B7280),
              ),
              activeColor: const Color(0xFF60A5FA),
              checkColor: Colors.white,
            ),
          ),
          if (text != null) ...[
            const SizedBox(width: 8),
            Text(
              text!,
              style: const TextStyle(
                color: Color(0xFFF5F5F5),
                fontSize: 14,
              ),
            ),
          ]
        ],
      ),
    );
  }
}