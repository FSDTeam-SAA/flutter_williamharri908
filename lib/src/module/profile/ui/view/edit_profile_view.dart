import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:williamharri/src/core/component/reactive_ui/widget/r_icon.dart';
import 'package:williamharri/src/core/constants/app_colors.dart';
import 'package:williamharri/src/core/constants/assets.dart';
import 'package:williamharri/src/core/notifiers/snackbar_notifier.dart';
import 'package:williamharri/src/module/profile/controller/profile_edit_controller.dart';
import 'package:williamharri/src/module/profile/model/profile_model.dart';

class EditProfileView extends StatelessWidget {
  final ProfileModel profile;
  const EditProfileView({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    // Controller initialize & set profile
    final controller = Get.put(ProfileEditController());
    controller.setProfile(profile);

    return Obx(() {
      final currentProfile = controller.profile.value;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text("Edit Profile"),
          actions: [
            TextButton(
              onPressed: currentProfile == null
                  ? null
                  : () {
                      controller.updateProfile(
                        name: currentProfile.name,
                        phone: currentProfile.phone,
                        address: currentProfile.address,
                        nationality: currentProfile.nationality,
                        snackbarNotifier: SnackbarNotifier(
                          context: context
                        )
                      );
                    },
              child: Row(
                spacing: 4,
                children: [
                  Text(
                    'Done',
                    style: TextStyle(
                      color: AppColors.context(context).primaryColor,
                    ),
                  ),
                  RIcon(
                    key: UniqueKey(),
                    iconWidget: Container(),
                    loadingStateWidget: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    processStatusNotifier: controller.processStatusNotifier,
                  )
                ],
              ),
            ),
          ],
        ),
        body: currentProfile == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.black54,
                          backgroundImage: controller.pickedImage.value != null
                              ? FileImage(controller.pickedImage.value!)
                              : (currentProfile.avatarUrl != null
                                        ? NetworkImage(
                                            currentProfile.avatarUrl!,
                                          )
                                        : null)
                                    as ImageProvider<Object>?,
                          child:
                              controller.pickedImage.value == null &&
                                  currentProfile.avatarUrl == null
                              ? const Icon(
                                  Icons.person,
                                  size: 45,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () async {
                              final picked = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                              );
                              if (picked != null) {
                                controller.pickImage(File(picked.path));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset(
                                Assets.edit,
                                height: 20,
                                width: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      currentProfile.name ?? "No Name",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      "Nepal",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // TextFields
                    underlineTextField("Name", currentProfile.name ?? "", (
                      val,
                    ) {
                      currentProfile.name = val;
                    }),
                    underlineTextField("Mobile", currentProfile.phone ?? "", (
                      val,
                    ) {
                      currentProfile.phone = val;
                    }),
                    underlineTextField(
                      "Email",
                      currentProfile.email ?? "",
                      (val) {},
                      isEditable: false,
                    ),
                    underlineTextField(
                      "Address",
                      currentProfile.address ?? "",
                      (val) {
                        currentProfile.address = val;
                      },
                    ),
                    underlineTextField(
                      "Nationality",
                      currentProfile.nationality ?? "",
                      (val) {
                        currentProfile.nationality = val;
                      },
                    ),
                  ],
                ),
              ),
      );
    });
  }

  Widget underlineTextField(
    String label,
    String value,
    Function(String) onChanged, {
    bool isEditable = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFFFC3C3C3), fontSize: 16),
          ),
          TextField(
            style: const TextStyle(color: Colors.white),
            controller: TextEditingController(text: value),
            enabled: isEditable,
            onChanged: onChanged,
            cursorColor: Colors.white,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
