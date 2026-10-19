import 'package:mini_katalog/utils/price_format.dart';

/// Katalog ürünü.
///
/// [isFavorite] JSON'da yoktur. Uygulama çalışırken oluşur ve
/// [copyWith] ile yeni bir nesneye taşınır; gelen kayıt değiştirilmez.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.description,
    required this.image,
    this.rating = 0,
    this.currency = 'TRY',
    this.tagline = '',
    this.specs = '',
    this.featured = false,
    this.isFavorite = false,
  });

  final String id;
  final String name;
  final String categoryId;
  final double price;
  final String currency;
  final String description;
  final String tagline;
  final String specs;
  final String image;
  final double rating;
  final bool featured;
  final bool isFavorite;

  String get priceLabel => formatMoney(price, currency);

  String get ratingLabel => rating.toStringAsFixed(1).replaceAll('.', ',');

  Product copyWith({bool? isFavorite, bool? featured}) {
    return Product(
      id: id,
      name: name,
      categoryId: categoryId,
      price: price,
      currency: currency,
      description: description,
      tagline: tagline,
      specs: specs,
      image: image,
      rating: rating,
      featured: featured ?? this.featured,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  /// Yerel katalog ve wantapi kaydını aynı modele çevirir.
  factory Product.fromJson(Map<String, dynamic> json) {
    final remote = json['price'] is String || json.containsKey('tagline');
    if (remote) {
      final name = json['name'] as String;
      return Product(
        id: '${json['id']}',
        name: name,
        categoryId: categoryIdForName(name),
        price: parseAmount(json['price']),
        currency: (json['currency'] as String?) ?? 'USD',
        description: json['description'] as String? ?? '',
        tagline: json['tagline'] as String? ?? '',
        specs: _specsText(json['specs']),
        image: json['image'] as String? ?? '',
      );
    }

    return Product(
      id: '${json['id']}',
      name: json['name'] as String,
      categoryId: json['categoryId'] as String,
      price: parseAmount(json['price']),
      currency: json['currency'] as String? ?? 'TRY',
      description: json['description'] as String,
      tagline: json['tagline'] as String? ?? '',
      specs: json['specs'] as String? ?? '',
      image: json['image'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      featured: json['featured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'price': price,
      'currency': currency,
      'description': description,
      'tagline': tagline,
      'specs': specs,
      'image': image,
      'rating': rating,
      'featured': featured,
    };
  }
}

/// Ürün adından eğitim kataloğundaki kategori kimliğini seçer.
String categoryIdForName(String name) {
  final value = name.toLowerCase();
  if (value.startsWith('iphone')) return 'telefon';
  if (value.contains('mac')) return 'bilgisayar';
  if (value.startsWith('ipad')) return 'tablet';
  if (value.contains('watch')) return 'saat';
  if (value.contains('vision')) return 'vision';
  if (value.contains('airpod') || value.contains('homepod')) return 'ses';
  return 'diger';
}

String _specsText(Object? raw) {
  if (raw is! Map) return '';
  final specs = Map<String, dynamic>.from(raw);
  return [
    for (final entry in specs.entries) '${entry.key}: ${entry.value}',
  ].join('\n');
}
