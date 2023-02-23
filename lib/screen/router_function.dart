import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';
import 'package:vary_recycle/screen/home_screen.dart';
import 'package:vary_recycle/screen/login_screen.dart';

class RouterFunction extends StatefulWidget {
  const RouterFunction({super.key});

  @override
  _RouterState createState() => _RouterState();
}

// StreamBuilder(
//   stream: FirebaseAuth.instance.authStateChanges(),
//   builder: (BuildContext _, AsyncSnapshot<User?> user) {
//     if (user.hasData) {
//       return const HomeScreen();
//     } else {
//       return const LoginScreen();
//           SplashScreen.navigate(
//         name: 'assets/RiveAssets/fristers_logo_animation.riv',
//         next: (context) => const LoginScreen(),
//         until: () => Future.delayed(const Duration(seconds: 3)),
//         backgroundColor: Colors.white,
//       );
//     }
//   },
// ),

class _RouterState extends State<RouterFunction> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Splash();
        } else {
          if (snapshot.hasData) {
            return const HomeScreen();
          }
          return const LoginScreen();
        }
      },
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SplashScreen.navigate(
      name: 'assets/RiveAssets/fristers_logo_animation.riv',
      next: (context) => const LoginScreen(),
      until: () => Future.delayed(const Duration(seconds: 3)),
      backgroundColor: Colors.white,
    ));
  }
}
