import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/module/home/ui/screen/job_application.dart';

class RamsDocumentScreen extends StatefulWidget {
  const RamsDocumentScreen({super.key});

  @override
  State<RamsDocumentScreen> createState() => _RamsDocumentScreenState();
}

class _RamsDocumentScreenState extends State<RamsDocumentScreen> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "RAMS Document",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(
              "hgdsfjgsdjf",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.6,
                letterSpacing: 0.3,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.black,
                border: Border(
                  top: BorderSide(color: Colors.white10, width: 1),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _isAgreed,
                        activeColor: Colors.green,
                        checkColor: Colors.black,
                        side: const BorderSide(color: Colors.white70, width: 2),
                        onChanged: (value) {
                          setState(() {
                            _isAgreed = value ?? false;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          "I agree to the terms & conditions",
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Green Submit FAB
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FloatingActionButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: _isAgreed ? Colors.green : Colors.grey,
                      elevation: 0,
                      onPressed: () {
                        if (_isAgreed) {
                          Get.to(
                            () => JobApplicationScreen(),
                          ); // Navigate to the next screen
                        }
                      },
                      child: const Text(
                        "S",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
