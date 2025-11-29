import 'dart:io';
import 'package:flutter/material.dart';

class FullImageViewScreen extends StatelessWidget {
  final String imageUrl;

  const FullImageViewScreen({super.key, required this.imageUrl});

  bool get isNetworkImage => imageUrl.startsWith('http') || imageUrl.startsWith('https');

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imageUrl.isEmpty) {
      imageWidget = const Center(
        child: Text('No image available', style: TextStyle(color: Colors.white)),
      );
    } else if (isNetworkImage) {
      imageWidget = Image.network(
        imageUrl,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Text('Failed to load image', style: TextStyle(color: Colors.white)),
          );
        },
      );
    } else {
      imageWidget = Image.file(File(imageUrl));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          maxScale: 5,
          child: imageWidget,
        ),
      ),
    );
  }
}
