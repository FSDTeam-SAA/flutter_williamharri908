import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';

class SmoothPageTransition { 
  static Route rightToLeft({
    required Widget secondScreen,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
  }) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: reverseTransitionDuration ?? Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => secondScreen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInSine;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
        //.animate(delay: const Duration(seconds: 1));
      },
    );
  }

  Route leftToRight({
    required Widget secondScreen,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
  }) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: reverseTransitionDuration ?? Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => secondScreen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
        //.animate(delay: const Duration(seconds: 1));
      },
    );
  }

  Route bottomToUp({
    required Widget secondScreen,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
  }) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: reverseTransitionDuration ?? Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => secondScreen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
        //.animate(delay: const Duration(seconds: 2));
      },
    );
  }
}