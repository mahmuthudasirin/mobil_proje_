import 'package:flutter/material.dart';

/// Rota argümanı eksikse veya adres tanımsızsa gösterilir.
class InvalidRouteScreen extends StatelessWidget {
  const InvalidRouteScreen({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sayfa açılamadı'),
        leading: IconButton(
          tooltip: 'Geri',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(message, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
