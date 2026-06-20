import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CKImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final String? placeholder;
  final Alignment alignment;

  const CKImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.placeholder,
    this.alignment = Alignment.center,
  });

  bool get _isSvg => imagePath.toLowerCase().endsWith('.svg');

  bool get _isNetwork => imagePath.startsWith('http');

  @override
  Widget build(BuildContext context) {
    return switch ((_isSvg, _isNetwork)) {
      (true, true) => SvgPicture.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        colorFilter: _colorFilter,
        placeholderBuilder: (_) => _placeholder(),
      ),
      (true, false) => SvgPicture.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        colorFilter: _colorFilter,
        placeholderBuilder: (_) => _placeholder(),
      ),
      (false, true) => Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        color: color,
        loadingBuilder: (_, child, progress) =>
            progress == null ? child : _placeholder(),
        errorBuilder: (_, __, ___) => _errorWidget(),
      ),
      (false, false) => Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        color: color,
        errorBuilder: (_, __, ___) => _errorWidget(),
      ),
    };
  }

  ColorFilter? get _colorFilter =>
      color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null;

  Widget _placeholder() => SizedBox(
    width: width,
    height: height,
    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
  );

  Widget _errorWidget() {
    if (placeholder case final String path) {
      return CKImage(
        imagePath: path,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }
}
