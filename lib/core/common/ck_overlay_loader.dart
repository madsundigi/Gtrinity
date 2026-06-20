import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CKOverlayLoader extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const CKOverlayLoader({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.2),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.white,
              ),
            ),
          ),
      ],
    );
  }
}
