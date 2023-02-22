import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:vary_recycle/repository/authentication_repository/authentication_repository.dart';
import 'package:vary_recycle/screen/login_screen.dart';
import 'package:vary_recycle/src/controllers/otp_controller.dart';
import 'firebase_options.dart';

// import 'package:camera/camera.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(OTPController());
  await Firebase.initializeApp(
    name: "vary-recycle",
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => Get.put(AuthenticationRepository()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: Duration(milliseconds: 500),
      home: LoginScreen(),
      //   StreamBuilder(
      // stream: FirebaseAuth.instance.authStateChanges(),
      // builder: (BuildContext _, AsyncSnapshot<User?> user) {
      //   if (user.hasData) {
      //     return const HomeScreen();
      //   } else {
      //     return const LoginScreen();
      //   }
      // },
    );
  }
}
