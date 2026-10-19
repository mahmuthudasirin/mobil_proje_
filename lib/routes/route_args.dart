/// Ürün listesine giderken Navigator'a verilen argüman.
///
/// Başlık, kategori ve favori süzgeci bu nesnede toplanır.
/// Ürünlerin kendisi argüman olarak taşınmaz.
class ProductListArgs {
  const ProductListArgs({
    required this.title,
    this.categoryId,
    this.favoritesOnly = false,
  });

  final String title;
  final String? categoryId;
  final bool favoritesOnly;
}

/// Ürün detayına giderken taşınan argüman.
///
/// Yalnızca kimlik gider. Güncel fiyat ve favori durumu katalogdan okunur.
class ProductDetailArgs {
  const ProductDetailArgs({required this.productId});

  final String productId;
}
