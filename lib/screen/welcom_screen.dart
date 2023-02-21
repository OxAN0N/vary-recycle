import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:vary_recycle/screen/login_screen.dart';
import 'package:vary_recycle/screen/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          Column(
            children: const [Text("Welcome Title")],
          ),
          Row(
            children: [
              Expanded(
                  child: OutlinedButton(
                      onPressed: () => Get.to(() => const LoginScreen()),
                      child: const Text("LOGIN"))),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () => Get.to(() => const SignupScreen()),
                      child: const Text("SIGNUP")))
            ],
          )
        ]),
      ),
    );
  }
}
