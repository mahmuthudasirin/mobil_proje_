import 'package:flutter/material.dart';
import 'package:mini_katalog/state/catalog_scope.dart';
import 'package:mini_katalog/state/catalog_store.dart';
import 'package:mini_katalog/theme/app_theme.dart';
import 'package:mini_katalog/utils/price_format.dart';
import 'package:mini_katalog/widgets/product_image.dart';
import 'package:mini_katalog/widgets/quantity_stepper.dart';

/// Sepet simülasyonu. Satırlar [ListView.builder] ile çizilir.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = CatalogScope.of(context);
    final lines = scope.store.cartLines;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sepet'),
        leading: IconButton(
          tooltip: 'Geri',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: lines.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Sepet boş. Ürün detayından sepete ekleyebilirsiniz.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: lines.length,
                    itemBuilder: (context, index) {
                      final line = lines[index];
                      return _CartRow(
                        line: line,
                        onQuantity: (quantity) => scope.setCartQuantity(
                          line.product.id,
                          quantity,
                        ),
                        onRemove: () => scope.setCartQuantity(line.product.id, 0),
                      );
                    },
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: Row(
                      children: [
                        Text(
                          'Toplam',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        Text(
                          formatMoney(
                            scope.store.cartTotal,
                            scope.store.cartCurrency,
                          ),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _CartRow extends StatelessWidget {
  const _CartRow({
    required this.line,
    required this.onQuantity,
    required this.onRemove,
  });

  final CartLine line;
  final ValueChanged<int> onQuantity;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.line),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: ProductImage(path: line.product.image),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      line.product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatMoney(line.lineTotal, line.product.currency),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    QuantityStepper(
                      quantity: line.quantity,
                      min: 1,
                      onChanged: onQuantity,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Sepetten çıkar',
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
