import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../widgets/signup_form_widget.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 400,
                  height: 200,
                  child: RiveAnimation.asset(
                    "assets/RiveAssets/natural.div",
                    fit: BoxFit.fill,
                    alignment: Alignment.center,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  ("Get on Recyling!"),
                  style: Theme.of(context).textTheme.headline3,
                ),
                Text(("Create your profile to start your Journey."),
                    style: Theme.of(context).textTheme.bodyText1),
                const SizedBox(
                  height: 15,
                ),
                const SignupFormWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
