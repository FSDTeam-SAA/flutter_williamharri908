import 'dart:async';
import 'package:flutter/material.dart';
import '../src/core/constants/assets.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(milliseconds: 1000), () {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => LoginView()),
      // );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset(Assets.appLogo, width: 200, height: 200)),
    );
  }
}



// // BEST & CLEANEST VERSION
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:williamharri/app/app_manager.dart';
// import 'package:williamharri/src/core/constants/assets.dart';

// class SplashView extends StatelessWidget {
//   const SplashView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // This line triggers AppManager → auto routing
//     Get.find<AppManager>();

//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(Assets.appLogo, width: 200, height: 200),
//             const SizedBox(height: 40),
//             const CircularProgressIndicator(color: Colors.white),
//           ],
//         ),
//       ),
//     );
//   }
// }