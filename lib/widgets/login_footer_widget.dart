import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vary_recycle/screen/signup_screen.dart';

import 'google_login_widget.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("OR"),
        const SizedBox(
          height: 10,
        ),
        const GoogleLogin(),
        const SizedBox(
          height: 10,
        ),
        TextButton(
          onPressed: () => Get.to(() => const SignupScreen()),
          child: Text.rich(
            TextSpan(
              text: "Don't have an Account?",
              style: Theme.of(context).textTheme.bodyText1,
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
