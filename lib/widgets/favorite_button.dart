import 'package:flutter/material.dart';
import 'package:mini_katalog/theme/app_theme.dart';

/// Favori kalbi. Kartta küçük, app bar'da normal boy kullanılır.
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
    this.compact = false,
  });

  final bool isFavorite;
  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: isFavorite ? 'Favorilerden çıkar' : 'Favorilere ekle',
      onPressed: onPressed,
      style: IconButton.styleFrom(
        padding: compact ? EdgeInsets.zero : null,
        minimumSize: compact ? const Size(36, 36) : const Size(48, 48),
        tapTargetSize: compact
            ? MaterialTapTargetSize.shrinkWrap
            : MaterialTapTargetSize.padded,
      ),
      icon: Icon(
        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        color: isFavorite ? AppTheme.favorite : AppTheme.muted,
      ),
    );
  }
}
