import 'package:flutter/material.dart';
import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/routes/app_routes.dart';
import 'package:mini_katalog/routes/route_args.dart';
import 'package:mini_katalog/screens/invalid_route_screen.dart';
import 'package:mini_katalog/state/catalog_scope.dart';
import 'package:mini_katalog/theme/app_theme.dart';
import 'package:mini_katalog/widgets/product_card.dart';

/// Kart ızgarası. Arama kutusu bu ekranın yerel durumudur.
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    setState(() => _query = value);
  }

  void _clearQuery() {
    _searchController.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs is! ProductListArgs) {
      return const InvalidRouteScreen(
        message: 'Ürün listesi ProductListArgs ile açılmalıdır.',
      );
    }

    final scope = CatalogScope.of(context);
    final matched = _matching(
      scope.store.productsFor(
        categoryId: routeArgs.categoryId,
        favoritesOnly: routeArgs.favoritesOnly,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(routeArgs.title),
        leading: IconButton(
          tooltip: 'Geri',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onChanged: _onQueryChanged,
              decoration: InputDecoration(
                hintText: 'Ürün adı yazın',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Aramayı temizle',
                        onPressed: _clearQuery,
                        icon: const Icon(Icons.close),
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${matched.length} ürün',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.muted,
                    ),
              ),
            ),
          ),
          Expanded(
            child: matched.isEmpty
                ? _EmptyProducts(message: _emptyMessage(routeArgs))
                : GridView.builder(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.sizeOf(context).width >= 700 ? 3 : 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.58,
                    ),
                    itemCount: matched.length,
                    itemBuilder: (context, index) {
                      final product = matched[index];
                      return ProductCard(
                        product: product,
                        onTap: () => openProductDetail(context, product),
                        onFavorite: () => scope.toggleFavorite(product.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<Product> _matching(List<Product> products) {
    final query = _normalize(_query);
    if (query.isEmpty) {
      return products;
    }
    return [
      for (final product in products)
        if (_normalize(product.name).contains(query)) product,
    ];
  }

  String _emptyMessage(ProductListArgs args) {
    if (_query.trim().isNotEmpty) {
      return 'Bu aramayla eşleşen ürün yok.';
    }
    if (args.favoritesOnly) {
      return 'Henüz favori ürün seçilmedi.';
    }
    return 'Bu kategoride ürün yok.';
  }
}

String _normalize(String value) {
  return value
      .replaceAll('İ', 'i')
      .replaceAll('I', 'ı')
      .replaceAll('Ş', 'ş')
      .replaceAll('Ğ', 'ğ')
      .replaceAll('Ü', 'ü')
      .replaceAll('Ö', 'ö')
      .replaceAll('Ç', 'ç')
      .trim()
      .toLowerCase();
}

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 40, color: AppTheme.muted),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
