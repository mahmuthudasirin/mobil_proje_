import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/data/catalog_repository.dart';
import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/state/catalog_store.dart';
import 'package:mini_katalog/utils/price_format.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('JSON alanlarından ürün modeli oluşur', () {
    final product = Product.fromJson(const {
      'id': 'kupa',
      'name': 'Seramik Kupa',
      'categoryId': 'ev',
      'price': 189,
      'description': 'Mat sırlı kupa',
      'image': 'assets/images/kupa.png',
      'rating': 4.4,
      'featured': false,
    });

    expect(product.id, 'kupa');
    expect(product.price, 189);
    expect(product.isFavorite, isFalse);
    expect(product.ratingLabel, '4,4');
  });

  test('favori kopyası kaynak ürünü değiştirmez', () {
    const product = Product(
      id: 'saat',
      name: 'Akıllı Saat',
      categoryId: 'elektronik',
      price: 2499,
      description: 'Bildirimler',
      image: 'assets/images/saat.png',
      rating: 4.5,
    );

    final favorite = product.copyWith(isFavorite: true);

    expect(product.isFavorite, isFalse);
    expect(favorite.isFavorite, isTrue);
    expect(favorite.name, product.name);
  });

  test('fiyat Türk lirası biçiminde yazılır', () {
    expect(formatTry(189), '189 TL');
    expect(formatTry(1299), '1.299 TL');
    expect(formatTry(189.5), '189,50 TL');
    expect(formatTry(1000000), '1.000.000 TL');
  });

  test('favori durumu ve kategori süzgeci katalogda tutulur', () {
    final store = CatalogStore(
      categories: const [],
      products: const [
        Product(
          id: 'kupa',
          name: 'Seramik Kupa',
          categoryId: 'ev',
          price: 189,
          description: 'Kupa',
          image: 'assets/images/kupa.png',
          rating: 4.4,
        ),
        Product(
          id: 'mat',
          name: 'Yoga Matı',
          categoryId: 'spor',
          price: 499,
          description: 'Mat',
          image: 'assets/images/mat.png',
          rating: 4.6,
          featured: true,
        ),
      ],
    );

    expect(store.productsFor(categoryId: 'ev'), hasLength(1));
    expect(store.favoriteCount, 0);

    store.toggleFavorite('kupa');

    expect(store.find('kupa')?.isFavorite, isTrue);
    expect(store.productsFor(favoritesOnly: true).single.id, 'kupa');
    expect(store.featured.single.id, 'mat');
  });

  test('wantapi kaydı modele ve yeniden JSON yazımına döner', () {
    final product = Product.fromJson(const {
      'id': 6,
      'name': 'MacBook Pro 16"',
      'tagline': 'Mind-blowing.',
      'description': 'Güçlü dizüstü',
      'price': r'$2,499',
      'currency': 'USD',
      'image': 'https://wantapi.com/assets/images/macbook.png',
      'specs': {'chip': 'M3 Max'},
    });

    expect(product.id, '6');
    expect(product.categoryId, 'bilgisayar');
    expect(product.price, 2499);
    expect(product.priceLabel, r'$2,499');
    expect(product.specs, 'chip: M3 Max');

    final encoded = product.toJson();
    expect(encoded['name'], 'MacBook Pro 16"');
    expect(encoded['price'], 2499);
    expect(encoded.containsKey('isFavorite'), isFalse);
  });

  test('sepete eklenen adet toplanır ve satır tutarı değişir', () {
    final store = CatalogStore(
      categories: const [],
      products: const [
        Product(
          id: '1',
          name: 'iPhone 15',
          categoryId: 'telefon',
          price: 799,
          currency: 'USD',
          description: 'Telefon',
          image: 'https://wantapi.com/assets/images/iphone.png',
          rating: 0,
        ),
      ],
    );

    store.addToCart('1', 2);
    store.addToCart('1', 1);

    expect(store.cartCount, 3);
    expect(store.cartLines.single.lineTotal, 2397);
    store.setCartQuantity('1', 0);
    expect(store.cartCount, 0);
  });

  test('asset kataloğu kategori ve ürün görsellerini bağlar', () async {
    final data = await const CatalogRepository().loadAsset();
    final categoryIds = data.categories.map((category) => category.id).toSet();

    expect(data.categories, hasLength(4));
    expect(data.products, hasLength(8));

    for (final product in data.products) {
      expect(categoryIds, contains(product.categoryId));
      expect(product.image, startsWith('assets/images/'));
    }
  });
}
