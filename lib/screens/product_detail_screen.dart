import 'package:flutter/material.dart';
import 'package:mini_katalog/routes/route_args.dart';
import 'package:mini_katalog/screens/invalid_route_screen.dart';
import 'package:mini_katalog/state/catalog_scope.dart';
import 'package:mini_katalog/theme/app_theme.dart';
import 'package:mini_katalog/utils/price_format.dart';
import 'package:mini_katalog/widgets/favorite_button.dart';
import 'package:mini_katalog/widgets/product_image.dart';
import 'package:mini_katalog/widgets/quantity_stepper.dart';

/// Ürün ayrıntısı.
///
/// Adet bu State sınıfında durur. Artı ve eksi, setState ile
/// ara toplamı yeniden çizer. Favori ise katalog kapsamına yazılır.
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  void _setQuantity(int value) {
    setState(() => _quantity = value);
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs is! ProductDetailArgs) {
      return const InvalidRouteScreen(
        message: 'Ürün detayı ProductDetailArgs ile açılmalıdır.',
      );
    }

    final scope = CatalogScope.of(context);
    final product = scope.store.find(routeArgs.productId);
    if (product == null) {
      return const InvalidRouteScreen(message: 'Ürün katalogda bulunamadı.');
    }

    final theme = Theme.of(context);
    final categoryName = scope.store.categoryOf(product)?.name;
    final total = product.price * _quantity;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        leading: IconButton(
          tooltip: 'Geri',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          FavoriteButton(
            isFavorite: product.isFavorite,
            onPressed: () => scope.toggleFavorite(product.id),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: ProductImage(path: product.image),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (categoryName != null)
                  Text(
                    categoryName,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                const SizedBox(height: 6),
                Text(product.name, style: theme.textTheme.headlineSmall),
                if (product.tagline.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    product.tagline,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.muted,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (product.rating > 0) ...[
                      const Icon(
                        Icons.star_rounded,
                        size: 18,
                        color: AppTheme.star,
                      ),
                      const SizedBox(width: 4),
                      Text(product.ratingLabel, style: theme.textTheme.bodyMedium),
                    ],
                    const Spacer(),
                    Text(
                      product.priceLabel,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  product.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.45,
                    color: const Color(0xFF3E4A55),
                  ),
                ),
                if (product.specs.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(product.specs, style: theme.textTheme.bodySmall),
                ],
                const Divider(height: 36),
                Text('Adet', style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                Row(
                  children: [
                    QuantityStepper(
                      quantity: _quantity,
                      onChanged: _setQuantity,
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Ara toplam',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.muted,
                          ),
                        ),
                        Text(
                          formatMoney(total, product.currency),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      scope.addToCart(product.id, _quantity);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$_quantity adet sepete eklendi'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_bag_outlined),
                    label: const Text('Sepete ekle'),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sepete eklemek adedi günceller. Sipariş gönderilmez.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
