import 'package:chef_king/core/imports/app_imports.dart';

enum SnackBarType { success, error, info, warning }

class CKSnackBar {
  static OverlayEntry? _overlayEntry;
  static Timer? _timer;

  static void showSuccess(BuildContext context, String message) {
    _show(context, message, AppColors.success);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, AppColors.error);
  }

  static void show(
    BuildContext context, {
    required String message,
    required SnackBarType type,
  }) {
    Color color;
    switch (type) {
      case SnackBarType.success:
        color = AppColors.success;
        break;
      case SnackBarType.error:
        color = AppColors.error;
        break;
      case SnackBarType.warning:
        color = Colors.orange;
        break;
      case SnackBarType.info:
        color = AppColors.primaryBlue;
        break;
    }
    _show(context, message, color);
  }

  static void _show(BuildContext context, String message, Color backgroundColor) {
    _timer?.cancel();
    _removeEntry();

    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => _SnackBarWidget(
        message: message,
        backgroundColor: backgroundColor,
        onDismiss: _removeEntry,
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  static void _removeEntry() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class _SnackBarWidget extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final VoidCallback onDismiss;

  const _SnackBarWidget({
    required this.message,
    required this.backgroundColor,
    required this.onDismiss,
  });

  @override
  State<_SnackBarWidget> createState() => _SnackBarWidgetState();
}

class _SnackBarWidgetState extends State<_SnackBarWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _showAndHide();
  }

  Future<void> _showAndHide() async {
    await _controller.forward();
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      await _controller.reverse();
      widget.onDismiss();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topPadding,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.zero,
            ),
            child: Center(
              child: CKText(
                widget.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
