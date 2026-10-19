import 'package:flutter/material.dart';

/// Katalog kategorisi. Simge ve renk, JSON'daki kısa adlardan çözülür.
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorHex,
  });

  final String id;
  final String name;
  final String iconName;
  final String colorHex;

  IconData get icon {
    switch (iconName) {
      case 'headphones':
        return Icons.headphones_rounded;
      case 'phone':
        return Icons.smartphone_rounded;
      case 'laptop':
        return Icons.laptop_mac_rounded;
      case 'tablet':
        return Icons.tablet_mac_rounded;
      case 'watch':
        return Icons.watch_rounded;
      case 'vision':
        return Icons.view_in_ar_rounded;
      case 'home':
        return Icons.chair_rounded;
      case 'book':
        return Icons.menu_book_rounded;
      case 'sport':
        return Icons.fitness_center_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  Color get color {
    final hex = colorHex.replaceFirst('#', '');
    return Color(0xFF000000 | int.parse(hex, radix: 16));
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      iconName: json['icon'] as String,
      colorHex: json['color'] as String,
    );
  }
}
