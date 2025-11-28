import 'package:flutter/material.dart';
import 'package:williamharri/src/core/constants/app_colors.dart';

import '../../../../core/constants/assets.dart';
import '../widgets/widgets.dart';
class EditProfileView extends StatelessWidget {
  EditProfileView({super.key});

  // Controllers
  final nameCtrl = TextEditingController(text: "Sarvesh Shrestha");
  final mobileCtrl = TextEditingController(text: "9800000000");
  final emailCtrl = TextEditingController(text: "5Bd4@example.com"); // non-editable
  final addressCtrl = TextEditingController(text: "s5Bd4@example");
  final nationalityCtrl = TextEditingController(text: "aragar");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Edit Profile"),
        actions: [
          TextButton(
            onPressed: () {
              print("Name: ${nameCtrl.text}");
              print("Mobile: ${mobileCtrl.text}");
              print("Email: ${emailCtrl.text}");
              print("Address: ${addressCtrl.text}");
              print("Nationality: ${nationalityCtrl.text}");
            },
            child: Text(
              'Done',
              style: TextStyle(color: AppColors.context(context).primaryColor),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                const CircleAvatar(radius: 45, backgroundColor: Colors.black54),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(Assets.edit, height: 20, width: 20),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            const Text(
              "Sarvesh Shrestha",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),

            const Text(
              "Nepal",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),

            // Editable Fields
            profileEditInfoShow(
              type: "Name",
              data: nameCtrl.text,
              controller: nameCtrl,
            ),

            profileEditInfoShow(
              type: "Mobile",
              data: mobileCtrl.text,
              controller: mobileCtrl,
            ),

            // Non-editable email
            profileEditInfoShow(
              type: "Email",
              data: emailCtrl.text,
              controller: emailCtrl,
              isEditable: false,
            ),

            profileEditInfoShow(
              type: "Address",
              data: addressCtrl.text,
              controller: addressCtrl,
            ),

            profileEditInfoShow(
              type: "Nationality",
              data: nationalityCtrl.text,
              controller: nationalityCtrl,
            ),
          ],
        ),
      ),
    );
  }
}
