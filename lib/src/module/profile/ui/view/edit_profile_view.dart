import 'package:flutter/material.dart';
import 'package:williamharri/src/core/constants/app_colors.dart';

import '../../../../core/constants/assets.dart';
import '../widgets/widgets.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Edit Profile"),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Done',
              style: TextStyle(color: AppColors.context(context).primaryColor),
            ),
          ),
        ],
      ),

      body: Padding(
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
            profileEditInfoShow(type: "Name", data: "Sarvesh Shrestha"),
            profileEditInfoShow(type: "Mobile", data: "9800000000"),
            profileEditInfoShow(type: "Email", data: "5Bd4@example.com"),
            profileEditInfoShow(type: "Address", data: "s5Bd4@example"),
            profileEditInfoShow(type: "Nationality", data: "aragar"),
          ],
        ),
      ),
    );
  }
}
