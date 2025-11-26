import 'package:flutter/material.dart';
import 'package:williamharri/src/core/constants/app_colors.dart';
import 'package:williamharri/src/module/home/ui/screen/home_screen_ui.dart';
import 'package:williamharri/src/module/profile/ui/view/profile_view.dart';

class AppGround extends StatefulWidget {
  const AppGround({super.key});

  @override
  State<AppGround> createState() => _AppGroundState();
}

class _AppGroundState extends State<AppGround> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreenView(),
    const Scaffold(body: Center(child: Text('My Jobs Page'))),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        height: 100,
        // margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1B2A),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(3, (index) {
            final icons = [
              Icons.home_outlined,
              Icons.work_outline,
              Icons.person_outline,
            ];

            final labels = ['Home', 'My Jobs', 'Profile'];

            final isSelected = _currentIndex == index;

            return GestureDetector(
              onTap: () => setState(() => _currentIndex = index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icons[index],
                    size: 28,
                    color: isSelected
                        ? AppColors.context(context).primaryColor
                        : Colors.grey,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    labels[index],
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.context(context).primaryColor
                          : Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
