import 'package:mini_katalog/models/category.dart';
import 'package:mini_katalog/models/product.dart';

/// Uygulama açıkken bellekte duran katalog.
///
/// Favori bilgisi burada tutulur. Ekranlar listeyi kendileri kopyalamaz.
class CatalogStore {
  CatalogStore({
    required this.categories,
    required List<Product> products,
  }) : _products = List<Product>.of(products);

  final List<Category> categories;
  List<Product> _products;

  List<Product> get products => List<Product>.unmodifiable(_products);

  int get favoriteCount => _products.where((product) => product.isFavorite).length;

  List<Product> get featured => [
        for (final product in _products)
          if (product.featured) product,
      ];

  Product? find(String id) {
    for (final product in _products) {
      if (product.id == id) {
        return product;
      }
    }
    return null;
  }

  Category? categoryOf(Product product) {
    for (final category in categories) {
      if (category.id == product.categoryId) {
        return category;
      }
    }
    return null;
  }

  int countIn(String categoryId) {
    return _products.where((product) => product.categoryId == categoryId).length;
  }

  List<Product> productsFor({
    String? categoryId,
    bool favoritesOnly = false,
  }) {
    return [
      for (final product in _products)
        if ((categoryId == null || product.categoryId == categoryId) &&
            (!favoritesOnly || product.isFavorite))
          product,
    ];
  }

  void toggleFavorite(String productId) {
    _products = [
      for (final product in _products)
        if (product.id == productId)
          product.copyWith(isFavorite: !product.isFavorite)
        else
          product,
    ];
  }

  final Map<String, int> _cart = {};

  int quantityInCart(String productId) => _cart[productId] ?? 0;

  int get cartCount => _cart.values.fold(0, (sum, quantity) => sum + quantity);

  List<CartLine> get cartLines => [
        for (final entry in _cart.entries)
          if (find(entry.key) case final product?)
            CartLine(product: product, quantity: entry.value),
      ];

  double get cartTotal => cartLines.fold(
        0,
        (sum, line) => sum + line.product.price * line.quantity,
      );

  String get cartCurrency =>
      cartLines.isEmpty ? 'USD' : cartLines.first.product.currency;

  /// Sepet simülasyonu. Sipariş gitmez; adet bellekte toplanır.
  void addToCart(String productId, int quantity) {
    if (quantity <= 0) return;
    _cart[productId] = quantityInCart(productId) + quantity;
  }

  void setCartQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      _cart.remove(productId);
      return;
    }
    _cart[productId] = quantity;
  }
}

class CartLine {
  const CartLine({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  double get lineTotal => product.price * quantity;
}
