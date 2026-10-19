import 'package:flutter/material.dart';

/// Ürün görseli. Adres http ile başlıyorsa ağdan, değilse asset'ten okunur.
class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final remote = path.startsWith('http');
    return ColoredBox(
      color: remote ? Colors.white : const Color(0xFFE4DDD2),
      child: remote ? _network() : _asset(),
    );
  }

  Widget _network() {
    return Image.network(
      path,
      fit: BoxFit.contain,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => _fallback(),
    );
  }

  Widget _asset() {
    return Image.asset(
      path,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) => _fallback(),
    );
  }

  Widget _fallback() {
    return const Center(
      child: Icon(Icons.image_outlined, color: Color(0xFF8A8175), size: 36),
    );
  }
}
