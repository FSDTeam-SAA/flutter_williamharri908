import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/assets.dart';
import '../widgets/widgets.dart';
import 'edit_profile_view.dart';

class PersonalInfoView extends StatelessWidget {
  const PersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Personal Info"),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Get.to(() => EditProfileView());
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Image.asset(Assets.edit, height: 24, width: 24),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage(Assets.profile),
              radius: 45,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 10),
            const Text(
              "Sarvesh Shrestha",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const Text(
              "nepal@gmail.com",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),

            personalInfoShow(type: "Name: ", data: "Sarvesh"),
            personalInfoShow(type: "Email ", data: "Shrestha"),
            personalInfoShow(type: "Mobile ", data: "9860091606"),
            personalInfoShow(type: "Address ", data: "Kathmandu"),
            personalInfoShow(type: "Nationality ", data: "Male"),
          ],
        ),
      ),
    );
  }
}
