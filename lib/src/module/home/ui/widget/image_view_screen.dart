import 'package:flutter/material.dart';

class FullImageViewScreen extends StatelessWidget {
  final String imageUrl;

  const FullImageViewScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          maxScale: 5,
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
