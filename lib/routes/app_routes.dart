import 'package:flutter/material.dart';
import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/routes/route_args.dart';

/// İsimli rotalar. MaterialApp.routes tablosu bu sabitleri kullanır.
class AppRoutes {
  static const home = '/';
  static const products = '/products';
  static const detail = '/product-detail';
  static const cart = '/cart';
}

void openProductList(
  BuildContext context, {
  required String title,
  String? categoryId,
  bool favoritesOnly = false,
}) {
  Navigator.pushNamed(
    context,
    AppRoutes.products,
    arguments: ProductListArgs(
      title: title,
      categoryId: categoryId,
      favoritesOnly: favoritesOnly,
    ),
  );
}

void openCart(BuildContext context) {
  Navigator.pushNamed(context, AppRoutes.cart);
}

void openProductDetail(BuildContext context, Product product) {
  Navigator.pushNamed(
    context,
    AppRoutes.detail,
    arguments: ProductDetailArgs(productId: product.id),
  );
}
