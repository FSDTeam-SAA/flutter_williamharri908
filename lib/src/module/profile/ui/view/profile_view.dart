import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

import '../../../../core/constants/assets.dart';
import '../../../account/ui/terms_condition_view.dart';
import '../../../auth/ui/view/change_password_view.dart';
import '../../../auth/ui/view/reset_password_view.dart';
import '../widgets/widgets.dart';
import 'personal_info_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage(Assets.profile),
                  radius: 35,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sarvesh Shrestha",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Nepal",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),
            profileBottom(
              name: "Personal Information",
              image: Assets.profileInfo,
              onTap: () {
                Get.to(() => const PersonalInfoView());
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: profileBottom(
                name: "Change Password",
                image: Assets.lock,
                onTap: () {
                  Get.to(() => const ChangePasswordView());
                },
              ),
            ),
            profileBottom(
              name: "Terms & Conditions",
              image: Assets.term,
              onTap: () {
                Get.to(() => const TermsConditionView());
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: InkWell(
                onTap: () {
                  //Get.snackbar("Logout", "Successfully Logout")
                  showLogoutDialog();
                },
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
                        Image.asset(
                          Assets.logOut,
                          height: 20,
                          width: 20,
                          color: Colors.red,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Log Out',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.red,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
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
void showLogoutDialog() {
  Get.defaultDialog(
    backgroundColor: Colors.white,
    title: "Logout",
    middleText: "Are you sure you want to logout?",
    titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black),
    middleTextStyle: TextStyle(fontSize: 16,color: Colors.black),
    barrierDismissible: true,
    radius: 10,
    contentPadding: EdgeInsets.all(20),
    cancel: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // Cancel button background color
        foregroundColor: Colors.black, // Cancel button text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey), // Optional border
        ),
      ),
      onPressed: () {
        Get.back(); // close dialog
      },
      child: Text("Cancel"),
    ),
    confirm: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange, // Logout button background color
        foregroundColor: Colors.white, // Logout button text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        Get.back(); // close dialog
        print("User logged out");
        // এখানে তোমার logout logic call করো
      },
      child: Text("Logout"),
    ),
  );
}

