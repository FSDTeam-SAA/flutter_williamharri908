import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/core/base/component/image_cache/smart_network_image.dart';
import 'package:williamharri/src/module/home/ui/screen/job_details_maneger_ui.dart';
import 'package:williamharri/src/module/profile/controller/get_profile_controller.dart';
import '../../../../core/constants/assets.dart';

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.profile.value?.username ?? "Unknown",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              "Welcome to Scaffolding app",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          if (controller.profile.value?.role == "manager")
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.add, color: Colors.white),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              child: SmartNetworkImage.circle(
                imageUrl:
                    controller.profile.value?.avatarUrl ??
                    Icon(Icons.person).toString(),
                diameter: 40,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "All Jobs",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: InkWell(
                      onTap: () {
                        Get.to(() => JobDetailsUi());
                        //Get.to(() => StaffJobDetailsUi());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.white),
                        ),

                        // height: 100,
                        // width: 100,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 55),
                                  Text(
                                    "Flutter Developer",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "Active",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white,
                                    backgroundImage: AssetImage(Assets.profile),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                        ),
                                        child: Icon(Icons.credit_card),
                                      ),
                                      Text(
                                        "Real Estate",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      "# 145",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 18,
                                        ),
                                        child: Icon(Icons.location_on_outlined),
                                      ),
                                      Text(
                                        "Remote",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
