import 'package:flutter/material.dart';
import 'package:mini_katalog/data/catalog_repository.dart';
import 'package:mini_katalog/routes/app_routes.dart';
import 'package:mini_katalog/state/catalog_scope.dart';
import 'package:mini_katalog/theme/app_theme.dart';
import 'package:mini_katalog/widgets/category_card.dart';
import 'package:mini_katalog/widgets/product_card.dart';
import 'package:mini_katalog/widgets/section_header.dart';

/// Karşılama, kategoriler ve öne çıkan ürünler.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = CatalogScope.of(context);
    final store = scope.store;
    final theme = Theme.of(context);
    final favoriteCount = store.favoriteCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Katalog'),
        actions: [
          IconButton(
            tooltip: 'Sepet',
            onPressed: () => openCart(context),
            icon: Badge(
              isLabelVisible: store.cartCount > 0,
              label: Text('${store.cartCount}'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          IconButton(
            tooltip: 'Favoriler',
            onPressed: () => openProductList(
              context,
              title: 'Favoriler',
              favoritesOnly: true,
            ),
            icon: Badge(
              isLabelVisible: favoriteCount > 0,
              label: Text('$favoriteCount'),
              child: Icon(
                favoriteCount > 0
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 28),
          children: [
            _Banner(
              productCount: store.products.length,
              categoryCount: store.categories.length,
              onOpenCatalog: () => openProductList(
                context,
                title: 'Tüm Ürünler',
              ),
            ),
            SectionHeader(
              title: 'Kategoriler',
              actionLabel: 'Tümü',
              onAction: () => openProductList(
                context,
                title: 'Tüm Ürünler',
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              itemCount: store.categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.18,
              ),
              itemBuilder: (context, index) {
                final category = store.categories[index];
                return CategoryCard(
                  category: category,
                  productCount: store.countIn(category.id),
                  onTap: () => openProductList(
                    context,
                    title: category.name,
                    categoryId: category.id,
                  ),
                );
              },
            ),
            const SectionHeader(title: 'Öne çıkanlar'),
            SizedBox(
              height: 258,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: store.featured.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final product = store.featured[index];
                  return SizedBox(
                    width: 176,
                    child: ProductCard(
                      product: product,
                      onTap: () => openProductDetail(context, product),
                      onFavorite: () => scope.toggleFavorite(product.id),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                'Kartlara dokunun. Detayda adet ve sepet tutarı güncellenir.',
                style: theme.textTheme.bodySmall?.copyWith(color: AppTheme.muted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.productCount,
    required this.categoryCount,
    required this.onOpenCatalog,
  });

  final int productCount;
  final int categoryCount;
  final VoidCallback onOpenCatalog;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              CatalogRepository.bannerUrl,
              height: 168,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 168,
                  color: const Color(0xFF1F6F6A),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(22),
                  child: Text(
                    'Mini Katalog',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$productCount ürün · $categoryCount kategori',
            style: theme.textTheme.bodyMedium?.copyWith(color: AppTheme.muted),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: onOpenCatalog,
            child: const Text('Tüm ürünler'),
          ),
        ],
      ),
    );
  }
}
