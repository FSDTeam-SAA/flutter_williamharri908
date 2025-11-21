import 'dart:math';

import 'package:flutter/material.dart';

class TextfieldPrefixIcon extends StatelessWidget {
  final String assetName;
  final double? height;
  final double? width;
  const TextfieldPrefixIcon({
    super.key,
    required this.assetName,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        //margin: EdgeInsets.only(left: 10, bottom: 14, top: 14),
        height: min(25, height ?? 25),
        width: min(25, width ?? 25),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Image.asset(
              assetName,
              fit: BoxFit.contain,
              height: min(25, height ?? 25),
              width: min(25, width ?? 25),
            ),
          ),
        ),
      ),
    );
  }
}
