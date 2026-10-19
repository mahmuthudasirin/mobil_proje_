# Mini Katalog Uygulaması

Flutter **3.47.7** ile yazılmış küçük bir vitrin. Üçüncü parti paket yoktur. Arayüz `material.dart`, uzak okuma `dart:io` içindeki `HttpClient`, yerel JSON `rootBundle` ve `dart:convert` ile kuruludur.

Öğrencinin elinde çalışan bir uygulama kalır: ana sayfa, ürün listesi, ürün detayı, sepet simülasyonu, isimli sayfa geçişleri, route argümanları, `GridView` kartları, `ListView.builder`, yerel `setState` ve JSON ile görsel asset’leri.

## Ekranlar

| Rota | Ekran | Ne öğretir |
| --- | --- | --- |
| `/` | Ana sayfa | Banner, kategori ızgarası, yatay seçki, sepet rozeti |
| `/products` | Ürün listesi | `GridView`, arama kutusunda `setState` |
| `/product-detail` | Ürün detayı | Route argümanı, adet, Sepete ekle |
| `/cart` | Sepet | `ListView.builder`, adet ve toplam |

Geçişler `Navigator.pushNamed` ile yapılır. Listeye `ProductListArgs`, detaya `ProductDetailArgs` gider. Detay sayfası ürünün kendisini değil kimliğini alır ve güncel kaydı katalogdan okur.

Geri dönüş `Navigator.pop` ile yazılmıştır; yığından üstteki sayfa kalkar.

## Klasörler

```
lib/
  main.dart                 uygulamayı başlatır
  app.dart                  tema, rotalar, JSON yükleme
  models/                   Product ve Category
  data/catalog_repository.dart
  state/                    favori ve sepet belleği
  routes/                   rota adları ve argüman sınıfları
  screens/                  ana sayfa, liste, detay, sepet
  widgets/                  kart, adet seçici, görsel
  theme/app_theme.dart
  utils/price_format.dart
assets/
  data/products.json
  images/                   ürün görselleri
test/catalog_test.dart
```

Dosya ve sınıf adları İngilizce, ekran metinleri Türkçedir.

## Durum

İki ayrı örnek vardır:

- **Yerel durum.** Ürün detayındaki adet `_quantity` alanındadır. Eksi ve artı `setState` çağırır; ara toplam aynı karede değişir. Liste ekranındaki arama kutusu da kendi `State` sınıfındadır.
- **Paylaşılan durum.** Favori kalbi ve sepet adetleri `CatalogStore` içine yazılır. `CatalogScope`, kök widget’ta `setState` tetikler. Ana sayfadaki rozet, karttaki kalp ve sepet aynı kaydı gösterir. Sepete eklemek sipariş göndermez.

## Veri

Ürünler `https://wantapi.com/products.php` adresinden okunur. Banner `https://wantapi.com/assets/banner.png` adresindedir. Ağ yanıtı gelmezse `assets/data/products.json` ve `assets/images/` kullanılır. `Product.fromJson` her iki kaydı da modele çevirir; `toJson` modeli yeniden JSON yazar.

`pubspec.yaml` içinde `assets/data/products.json` ve `assets/images/` bildirilmiştir.

## Ekran görüntüleri

`screenshots/` klasöründe ana sayfa, ürün listesi, ürün detayı ve sepet vardır.

## Çalıştırma

Araçlar bu bilgisayarda kurulu: Flutter `C:\src\flutter`, Git, Android Studio ve Android SDK. Emülatör adı `MiniKatalog`.

Yeni bir terminal açıp şunu çalıştır:

```powershell
cd C:\Users\USER\Desktop\mobil
flutter pub get
flutter emulators --launch MiniKatalog
flutter run
```

Emülatör açıldıktan sonra `flutter run` uygulamayı telefona yükler. Android Studio’da bu klasörü açıp cihaz listesinden `MiniKatalog` seçerek de çalıştırabilirsin. VS Code ayarı `.vscode/launch.json` içindedir.

Testler:

```powershell
flutter test
```

## Bilerek kullanılmayanlar

`provider`, `http`, `go_router` ve görsel önbellek paketleri eklenmedi. Uzak katalog `HttpClient` ile okunur. Amaç, SDK ile widget ağacı, `Navigator`, model ve asset akışını görünür tutmaktır.
