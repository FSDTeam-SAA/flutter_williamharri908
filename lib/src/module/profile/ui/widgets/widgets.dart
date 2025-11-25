import 'package:flutter/material.dart';

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
            SizedBox(width: 8),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget personalInfoShow({required String type, required String data}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          children: [
            Text(
              type,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            Spacer(),
            Text(
              data,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
      Container(height: 1, color: Colors.white),
    ],
  );
}

Widget profileEditInfoShow({required String type, required String data}) {
  return Padding(
    padding: const EdgeInsets.only(top: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(type, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),

        Text(data, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        Container(height: 1, color: Colors.white),
      ],
    ),
  );
}
