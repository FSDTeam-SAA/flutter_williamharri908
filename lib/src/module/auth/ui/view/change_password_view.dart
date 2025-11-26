// import 'package:flutter/material.dart';
// import 'package:williamharri/src/core/common/textfields/s_textfield.dart';
// import '../../../../core/base/reactive_ui/save_button.dart';
// import '../../controller/signup_controller.dart';

// class ChangePasswordView extends StatelessWidget {
//   const ChangePasswordView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = TextEditingController();
//     final SignupController signupController = SignupController();
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         title: const Text("Change Password"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           spacing: 16,
//           children: [
//             CustomTextField(
//               controller: controller,
//               hintText: "Current Password",
//             ),
//             CustomTextField(
//               controller: controller,
//               hintText: "New Password",
//             ),
//             CustomTextField(
//               controller: controller,
//               hintText: "Confirm Password",
//             ),
//             RSaveButton(
//               height: 52,
//               key: UniqueKey(),
//               buttonStatusNotifier: signupController.processNotifier,
//               saveText: "Save",
//               doneText: "Successful",
//               loadingText: "Signing Up...",
//               onSave: (processNotifier) async {
//                 signupController.signup();
//               },
//               onDone: () {},
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/core/common/textfields/s_textfield.dart';
import 'package:williamharri/src/core/base/reactive_ui/save_button.dart';
import '../../controller/change_password_controller.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  late final TextEditingController _currentController;
  late final TextEditingController _newController;
  late final TextEditingController _confirmController;
  late final ChangePasswordController _ctrl;

  @override
  void initState() {
    super.initState();

    // Get or create controller
    _ctrl = Get.put(ChangePasswordController(Get.find()));

    // create controllers
    _currentController = TextEditingController();
    _newController = TextEditingController();
    _confirmController = TextEditingController();

    // forward text changes to your controller setters
    _currentController.addListener(() {
      _ctrl.currentPassword = _currentController.text;
    });
    _newController.addListener(() {
      _ctrl.newPassword = _newController.text;
    });
    _confirmController.addListener(() {
      _ctrl.confirmPassword = _confirmController.text;
    });
  }

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text("Change Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: _currentController,
              hintText: "Current Password",
              isPassword: true,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _newController,
              hintText: "New Password",
              isPassword: true,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _confirmController,
              hintText: "Confirm Password",
              isPassword: true,
            ),
            const SizedBox(height: 24),

            // Save button wired to controller's process notifier and action
            RSaveButton(
              height: 52,
              key: UniqueKey(),
              buttonStatusNotifier: _ctrl.processNotifier,
              saveText: "Save",
              doneText: "Successful",
              loadingText: "Saving...",
              onSave: (processNotifier) async {
                await _ctrl.changePassword();
              },
              onDone: () {},
            ),
          ],
        ),
      ),
    );
  }
}
