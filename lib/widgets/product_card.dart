import 'package:flutter/material.dart';
import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/theme/app_theme.dart';
import 'package:mini_katalog/widgets/favorite_button.dart';
import 'package:mini_katalog/widgets/product_image.dart';

/// Grid ve yatay seçkide kullanılan ürün kartı.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onFavorite,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppTheme.line),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ProductImage(path: product.image),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 4, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.priceLabel,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      if (product.rating > 0) ...[
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: AppTheme.star,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          product.ratingLabel,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                      const Spacer(),
                      FavoriteButton(
                        compact: true,
                        isFavorite: product.isFavorite,
                        onPressed: onFavorite,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
