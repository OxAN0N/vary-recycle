import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vary_recycle/screen/signup_screen.dart';
import 'package:vary_recycle/widgets/google_login_widget.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              const GoogleLogin().signInWithGoogle(context);
            },
            label: const Text(
              " Sign in with Google",
              style: TextStyle(color: Colors.black),
            ),
            icon: const Image(
                image: AssetImage('assets/google.png'), width: 20.0),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextButton(
          onPressed: () => Get.to(() => const SignupScreen()),
          child: Text.rich(
            TextSpan(
              text: "Don't have an Account?",
              style: Theme.of(context).textTheme.bodyLarge,
              children: const [
                TextSpan(
                  text: " Sign up",
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
