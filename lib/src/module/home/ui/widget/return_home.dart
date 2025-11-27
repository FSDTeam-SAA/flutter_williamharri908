import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/module/nabber_screen.dart';

class ScaffoldInstalledScreen extends StatelessWidget {
  const ScaffoldInstalledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Success message
            const Text(
              "The scaffolding has\nbeen fully installed\nat the site.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.orange,
                fontSize: 28,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),

            const Spacer(),

            // Return Home button
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                      Get.offAll(() => AppGround());
                                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF99B07),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Return Home",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17, 
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}