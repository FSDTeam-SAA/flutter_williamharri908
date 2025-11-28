import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/module/profile/controller/staff_list_controller.dart';
import 'package:williamharri/src/module/profile/model/profile_model.dart';

class EditJobScreen extends StatelessWidget {
  const EditJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final staffController = Get.find<StaffController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Job",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.delete, color: Colors.red, size: 24),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(
                      "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Change thumbnail picture",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _label("Company/Agency Name"),
            _input("Modern Homes Co."),
            const SizedBox(height: 15),

            _label("Job designation"),
            _input("Real estate agent needed"),
            const SizedBox(height: 15),

            _label("Location"),
            _input("789 Park Lane, Birmingham, B"),
            const SizedBox(height: 15),

            _label("Price"),
            _input("\$ 199"),
            const SizedBox(height: 15),

            _label("Assign to Staff"),

            // STAFF DROPDOWN
            Obx(() {
              if (staffController.isLoading.value) {
                return _loadingDropdown();
              }

              return _staffDropdown(staffController);
            }),

            const SizedBox(height: 20),

            _label("Description"),
            _largeInput(
              "Lorem ipsum dolor sit amet consectetur. Lectus sed in egestas "
              "ultrices a odio eget varius sit. Viverra senectus egestas nisl "
              "vel adipiscing...",
            ),

            const SizedBox(height: 25),

            _label("Photos"),
            const SizedBox(height: 10),

            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _photoItem("https://images.unsplash.com/photo-1600585154340-be6161a56a0c"),
                  _photoItem("https://images.unsplash.com/photo-1464146072230-91cabc968266"),
                  _photoItem("https://images.unsplash.com/photo-1502672260266-1c1ef2d93688"),
                  _addPhotoButton(),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    print("Selected Staff: ${staffController.selectedStaff.value?.id}");
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------
  // REUSABLE WIDGETS
  // -----------------------------

  static Widget _label(String text) => Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      );

  static Widget _input(String text) => Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white70),
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      );

  static Widget _largeInput(String text) => Container(
        height: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white70),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      );

  static Widget _photoItem(String url) => Padding(
        padding: const EdgeInsets.only(right: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(url, width: 80, height: 80, fit: BoxFit.cover),
        ),
      );

  static Widget _addPhotoButton() => Container(
        width: 80,
        height: 80,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white54),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            "Add photo +",
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ),
      );

  // -----------------------------
  // STAFF DROPDOWN WIDGET
  // -----------------------------

  static Widget _loadingDropdown() => Container(
        height: 48,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white70),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          "Loading...",
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      );

  static Widget _staffDropdown(StaffController controller) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: Obx(
          () => DropdownButton<ProfileModel>(
            isExpanded: true,
            dropdownColor: Colors.black,
            value: controller.selectedStaff.value,
            hint: const Text(
              "Select a staff",
              style: TextStyle(color: Colors.white70),
            ),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            items: controller.staffList.map((staff) {
              return DropdownMenuItem(
                value: staff,
                child: Text(
                  staff.name ?? staff.username ?? "Unknown Staff",
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            onChanged: (value) => controller.selectStaff(value),
          ),
        ),
      ),
    );
  }
}
