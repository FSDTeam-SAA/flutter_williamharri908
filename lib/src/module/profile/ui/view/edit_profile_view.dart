/* import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:williamharri/src/core/constants/app_colors.dart';
import 'package:williamharri/src/core/constants/assets.dart';
import 'package:williamharri/src/module/profile/controller/profile_edit_controller.dart';
import 'package:williamharri/src/module/profile/model/profile_model.dart';

class EditProfileView extends StatefulWidget {
  final ProfileModel? profile;
  const EditProfileView({super.key, required this.profile});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late TextEditingController nameCtrl;
  late TextEditingController mobileCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController addressCtrl;
  late TextEditingController nationalityCtrl;

  File? selectedImage;

  final controller = Get.put(ProfileEditController(appPigeon: Get.find()));
  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.profile?.name ?? "");
    mobileCtrl = TextEditingController(text: widget.profile?.phone ?? "");
    emailCtrl = TextEditingController(text: widget.profile?.email ?? "");
    addressCtrl = TextEditingController(text: widget.profile?.address ?? "");
    nationalityCtrl = TextEditingController(
      text: widget.profile?.nationality ?? "",
    );
    selectedImage = null;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    mobileCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    nationalityCtrl.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  void saveProfile() {
    if (widget.profile != null) {
      widget.profile!.name = nameCtrl.text;
      widget.profile!.phone = mobileCtrl.text;
      widget.profile!.address = addressCtrl.text;
      widget.profile!.nationality = nationalityCtrl.text;

      if (selectedImage != null) {
        widget.profile!.avatarUrl = null;
      }

      print("Name: ${widget.profile!.name}");
      print("Mobile: ${widget.profile!.phone}");
      print("Email: ${widget.profile!.email}");
      print("Address: ${widget.profile!.address}");
      print("Nationality: ${widget.profile!.nationality}");
      print("Avatar: ${selectedImage?.path ?? widget.profile!.avatarUrl}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Edit Profile"),
        actions: [
          /*   TextButton(
            onPressed: () {
              profileEditcontrollre.updateProfile;
            },
            child: Text(
              'Done',
              style: TextStyle(color: AppColors.context(context).primaryColor),
            ),
          ), */
          /* TextButton(
            onPressed: () {
              profileEditcontrollre.updateProfile();
              print("edit botttom ========");
            },
            child: Text(
              'Done',
              style: TextStyle(color: AppColors.context(context).primaryColor),
            ),
          ), */
          /*      TextButton(
            onPressed: () {
              final controller = Get.find<ProfileEditController>();

              controller.updateProfile(
                name: nameCtrl.text,
                phone: mobileCtrl.text,
                address: addressCtrl.text,
                nationality: nationalityCtrl.text,
              );

              print("edit botttom ========");
            },
            child: Text(
              'Done',
              style: TextStyle(color: AppColors.context(context).primaryColor),
            ),
          ), */
          TextButton(
            onPressed: () {
              controller.updateProfile(
                name: nameCtrl.text,
                phone: mobileCtrl.text,
                address: addressCtrl.text,
                nationality: nationalityCtrl.text,
              );
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
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.black54,
                  backgroundImage: selectedImage != null
                      ? FileImage(selectedImage!)
                      : (widget.profile?.avatarUrl != null
                                ? NetworkImage(widget.profile!.avatarUrl!)
                                : null)
                            as ImageProvider<Object>?,
                  child:
                      selectedImage == null && widget.profile?.avatarUrl == null
                      ? const Icon(Icons.person, size: 45, color: Colors.white)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: pickImage,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset(Assets.edit, height: 20, width: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.profile?.name ?? "No Name",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const Text(
              "Nepal",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),

            // Underline-only TextFields
            underlineTextField("Name", nameCtrl),
            underlineTextField("Mobile", mobileCtrl),
            underlineTextField("Email", emailCtrl, isEditable: false),
            underlineTextField("Address", addressCtrl),
            underlineTextField("Nationality", nationalityCtrl),
          ],
        ),
      ),
    );
  }

  /* 
  Widget underlineTextField(
    String label,
    // String fieldName,
    TextEditingController controller, {
    bool isEditable = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label',
            style: const TextStyle(color: Color(0xFFFC3C3C3), fontSize: 16),
          ),
          TextField(
            style: const TextStyle(color: Colors.white),
            controller: controller,
            enabled: isEditable,
            decoration: InputDecoration(
              hintStyle: TextStyle(
                color: Color(0xFFFC3C3C3),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              labelText: label,

              labelStyle: TextStyle(
                color: Color(0xFFFC3C3C3),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              enabledBorder: const UnderlineInputBorder(
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
  } */
  Widget underlineTextField(
    String fieldName,
    TextEditingController controller, {
    bool isEditable = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldName,
            style: const TextStyle(color: Color(0xFFFC3C3C3), fontSize: 16),
          ),
          TextField(
            style: const TextStyle(color: Colors.white),
            controller: controller,
            enabled: isEditable,
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
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:williamharri/src/core/constants/app_colors.dart';
import 'package:williamharri/src/core/constants/assets.dart';
import 'package:williamharri/src/module/profile/controller/profile_edit_controller.dart';
import 'package:williamharri/src/module/profile/model/profile_model.dart';

class EditProfileView extends StatelessWidget {
  final ProfileModel profile;
  const EditProfileView({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    // Controller initialize & set profile
    final controller = Get.put(ProfileEditController(appPigeon: Get.find()));
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
                      );
                    },
              child: Text(
                'Done',
                style: TextStyle(
                  color: AppColors.context(context).primaryColor,
                ),
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
