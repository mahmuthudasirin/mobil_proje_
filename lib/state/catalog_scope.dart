import 'package:flutter/material.dart';
import 'package:mini_katalog/state/catalog_store.dart';

/// Katalog durumunu bütün sayfalara taşır.
///
/// Favori değişince [onChanged] kök widget'ta setState çağırır.
/// Bu sayfayı dinleyen ekranlar yeniden çizilir. Adet gibi yalnızca
/// bir ekrana ait durum burada tutulmaz; o iş için ekranın kendi
/// State sınıfı kullanılır.
class CatalogScope extends InheritedWidget {
  const CatalogScope({
    super.key,
    required this.store,
    required this.onChanged,
    required super.child,
  });

  final CatalogStore store;
  final VoidCallback onChanged;

  static CatalogScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CatalogScope>();
    if (scope == null) {
      throw FlutterError(
        'CatalogScope bulunamadı. Ekranlar MiniKatalogApp içinde açılmalıdır.',
      );
    }
    return scope;
  }

  void toggleFavorite(String productId) {
    store.toggleFavorite(productId);
    onChanged();
  }

  void addToCart(String productId, int quantity) {
    store.addToCart(productId, quantity);
    onChanged();
  }

  void setCartQuantity(String productId, int quantity) {
    store.setCartQuantity(productId, quantity);
    onChanged();
  }

  @override
  bool updateShouldNotify(CatalogScope oldWidget) => true;
}
