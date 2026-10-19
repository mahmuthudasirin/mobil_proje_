import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mini_katalog/models/category.dart';
import 'package:mini_katalog/models/product.dart';

/// JSON dosyasından veya wantapi yanıtından okunan katalog.
class CatalogData {
  const CatalogData({required this.categories, required this.products});

  final List<Category> categories;
  final List<Product> products;
}

/// Ürünleri önce wantapi adresinden, olmazsa yerel JSON dosyasından okur.
///
/// `HttpClient` ve `rootBundle` Flutter / Dart SDK içindedir. Ek paket yoktur.
class CatalogRepository {
  const CatalogRepository();

  static const productsUrl = 'https://wantapi.com/products.php';
  static const bannerUrl = 'https://wantapi.com/assets/banner.png';
  static const assetPath = 'assets/data/products.json';

  Future<CatalogData> load() async {
    try {
      final raw = await _readRemote(productsUrl);
      return parseRemoteCatalog(raw);
    } catch (_) {
      return loadAsset();
    }
  }

  Future<CatalogData> loadAsset() async {
    final raw = await rootBundle.loadString(assetPath);
    return parseLocalCatalog(raw);
  }

  Future<String> _readRemote(String url) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close().timeout(const Duration(seconds: 20));
      if (response.statusCode != 200) {
        throw HttpException('HTTP ${response.statusCode}', uri: Uri.parse(url));
      }
      return await response.transform(utf8.decoder).join();
    } finally {
      client.close();
    }
  }
}

CatalogData parseLocalCatalog(String raw) {
  final decoded = jsonDecode(raw);
  if (decoded is! Map) {
    throw const FormatException('Katalog JSON bir nesne olmalıdır.');
  }
  final catalog = Map<String, dynamic>.from(decoded);
  final categoriesJson = catalog['categories'];
  final productsJson = catalog['products'];
  if (categoriesJson is! List || productsJson is! List) {
    throw const FormatException('categories ve products alanları liste olmalıdır.');
  }

  return CatalogData(
    categories: [
      for (final item in categoriesJson)
        Category.fromJson(Map<String, dynamic>.from(item as Map)),
    ],
    products: [
      for (final item in productsJson)
        Product.fromJson(Map<String, dynamic>.from(item as Map)),
    ],
  );
}

CatalogData parseRemoteCatalog(String raw) {
  final decoded = jsonDecode(raw);
  if (decoded is! Map) {
    throw const FormatException('wantapi yanıtı nesne olmalıdır.');
  }
  final data = decoded['data'];
  if (data is! List) {
    throw const FormatException('wantapi data alanı liste olmalıdır.');
  }

  final products = <Product>[
    for (var index = 0; index < data.length; index++)
      Product.fromJson(Map<String, dynamic>.from(data[index] as Map)).copyWith(
        featured: index < 4,
      ),
  ];

  final used = products.map((product) => product.categoryId).toSet();
  return CatalogData(
    categories: [
      for (final category in _remoteCategories)
        if (used.contains(category.id)) category,
    ],
    products: products,
  );
}

const _remoteCategories = [
  Category(id: 'telefon', name: 'iPhone', iconName: 'phone', colorHex: '#1F5A82'),
  Category(id: 'bilgisayar', name: 'Mac', iconName: 'laptop', colorHex: '#3D4C5C'),
  Category(id: 'tablet', name: 'iPad', iconName: 'tablet', colorHex: '#6E3A4A'),
  Category(id: 'saat', name: 'Watch', iconName: 'watch', colorHex: '#2F6B4A'),
  Category(id: 'vision', name: 'Vision', iconName: 'vision', colorHex: '#5C4B8A'),
  Category(id: 'ses', name: 'Ses', iconName: 'headphones', colorHex: '#B87A2A'),
];
