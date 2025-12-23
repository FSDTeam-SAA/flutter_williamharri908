import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/module/profile/controller/profile_data_controller.dart';
import '../../../../core/constants/assets.dart';
import '../widgets/widgets.dart';
import 'edit_profile_view.dart';

class PersonalInfoView extends StatelessWidget {
  const PersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileDataController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Personal Info"),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () => Get.to(
              () => EditProfileView(profile: controller.profile.value!),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Image.asset(Assets.edit, height: 24, width: 24),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = controller.profile.value;

        if (profile == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No profile data found."),
                // ElevatedButton(
                //   onPressed: controller.refreshProfile,
                //   child: const Text("Retry"),
                // ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                    ? NetworkImage(profile.avatarUrl!)
                    : const AssetImage(Assets.profile) as ImageProvider,
              ),
              const SizedBox(height: 16),
              Text(
                profile.name ?? "No Name",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                profile.email ?? "",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              personalInfoShow(type: "Name", data: profile.name ?? "N/A"),
              personalInfoShow(type: "Email", data: profile.email ?? "N/A"),
              personalInfoShow(type: "Mobile", data: profile.phone ?? "N/A"),
              personalInfoShow(type: "Address", data: profile.address ?? "N/A"),
              personalInfoShow(
                type: "Nationality",
                data: profile.nationality ?? "N/A",
              ),
            ],
          ),
        );
      }),
    );
  }
}
