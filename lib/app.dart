import 'package:flutter/material.dart';
import 'package:mini_katalog/data/catalog_repository.dart';
import 'package:mini_katalog/routes/app_routes.dart';
import 'package:mini_katalog/screens/cart_screen.dart';
import 'package:mini_katalog/screens/home_screen.dart';
import 'package:mini_katalog/screens/invalid_route_screen.dart';
import 'package:mini_katalog/screens/product_detail_screen.dart';
import 'package:mini_katalog/screens/product_list_screen.dart';
import 'package:mini_katalog/state/catalog_scope.dart';
import 'package:mini_katalog/state/catalog_store.dart';
import 'package:mini_katalog/theme/app_theme.dart';

/// JSON yüklenince katalog kapsamını ve isimli rotaları kurar.
class MiniKatalogApp extends StatefulWidget {
  const MiniKatalogApp({super.key});

  @override
  State<MiniKatalogApp> createState() => _MiniKatalogAppState();
}

class _MiniKatalogAppState extends State<MiniKatalogApp> {
  final CatalogRepository _repository = const CatalogRepository();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  CatalogStore? _store;
  Object? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _repository.load();
      if (!mounted) {
        return;
      }
      setState(() {
        _store = CatalogStore(
          categories: data.categories,
          products: data.products,
        );
        _error = null;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  Future<void> _retry() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    await _load();
  }

  void _onCatalogChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final store = _store;
    if (store == null) {
      return MaterialApp(
        title: 'Mini Katalog',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: _BootScreen(
          loading: _loading,
          error: _error,
          onRetry: _retry,
        ),
      );
    }

    return CatalogScope(
      store: store,
      onChanged: _onCatalogChanged,
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'Mini Katalog',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        initialRoute: AppRoutes.home,
        routes: {
          AppRoutes.home: (_) => const HomeScreen(),
          AppRoutes.products: (_) => const ProductListScreen(),
          AppRoutes.detail: (_) => const ProductDetailScreen(),
          AppRoutes.cart: (_) => const CartScreen(),
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => InvalidRouteScreen(
              message: 'Tanımsız rota: ${settings.name}',
            ),
          );
        },
      ),
    );
  }
}

class _BootScreen extends StatelessWidget {
  const _BootScreen({
    required this.loading,
    this.error,
    this.onRetry,
  });

  final bool loading;
  final Object? error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Mini Katalog', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              if (loading) const CircularProgressIndicator(),
              if (error != null) ...[
                Text(
                  'Katalog yüklenemedi.\n$error',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: onRetry,
                  child: const Text('Yeniden dene'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
