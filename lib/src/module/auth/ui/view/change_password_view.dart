import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:williamharri/src/core/common/textfields/s_textfield.dart';
import 'package:williamharri/src/core/component/reactive_ui/widget/save_button.dart';
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

    _ctrl = Get.put(ChangePasswordController(Get.find()));
    _currentController = TextEditingController();
    _newController = TextEditingController();
    _confirmController = TextEditingController();
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
