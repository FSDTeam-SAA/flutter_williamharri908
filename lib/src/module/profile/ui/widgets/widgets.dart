import 'package:flutter/material.dart';

/// Bottom profile menu button
Widget profileBottom({
  required String name,
  required String image,
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.asset(image, height: 20, width: 20, color: Colors.black),
            const SizedBox(width: 8),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      color: Colors.black, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Show profile info (NOT editable)
Widget personalInfoShow({required String type, required String data}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          children: [
            Text(
              type,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const Spacer(),
            Text(
              data,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
      Container(height: 1, color: Colors.white),
    ],
  );
}

/// Editable profile field (Except Email)
Widget profileEditInfoShow({
  required String type,
  required String data,
  bool isEditable = true,
  TextEditingController? controller,
}) {
  final TextEditingController textController =
      controller ?? TextEditingController(text: data);

  return Padding(
    padding: const EdgeInsets.only(top: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          type,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),

        const SizedBox(height: 4),

        TextField(
          controller: textController,
          enabled: isEditable,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          // decoration: InputDecorahhh
        ),

        Container(height: 1, color: Colors.white),
      ],
    ),
  );
}
