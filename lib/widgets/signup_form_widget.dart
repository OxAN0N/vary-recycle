import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vary_recycle/src/controllers/signup_controller.dart';
import 'package:vary_recycle/widgets/google_login_widget.dart';

class SignupFormWidget extends StatelessWidget {
  const SignupFormWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    final formKey = GlobalKey<FormState>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  const GoogleLogin().signInWithGoogle(context);
                },
                label: const Text(
                  " Sign up with Google",
                  style: TextStyle(color: Colors.black),
                ),
                icon: const Image(
                    image: AssetImage('assets/google.png'), width: 20.0),
              ),
            ),
            // TextFormField(
            //   controller: controller.fullName,
            //   decoration: const InputDecoration(
            //     label: Text("Full Name"),
            //     border: OutlineInputBorder(),
            //     prefixIcon: Icon(
            //       Icons.person_outline_rounded,
            //       color: Colors.green,
            //     ),
            //     labelStyle: TextStyle(color: Colors.green),
            //     focusedBorder: OutlineInputBorder(
            //       borderSide: BorderSide(width: 2.0, color: Colors.green),
            //     ),
            //   ),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            // TextFormField(
            //   controller: controller.email,
            //   decoration: const InputDecoration(
            //     label: Text("Email"),
            //     border: OutlineInputBorder(),
            //     prefixIcon: Icon(
            //       Icons.email_outlined,
            //       color: Colors.green,
            //     ),
            //     labelStyle: TextStyle(color: Colors.green),
            //     focusedBorder: OutlineInputBorder(
            //       borderSide: BorderSide(width: 2.0, color: Colors.green),
            //     ),
            //   ),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            // TextFormField(
            //   controller: controller.password,
            //   decoration: const InputDecoration(
            //     label: Text("Password"),
            //     border: OutlineInputBorder(),
            //     prefixIcon: Icon(
            //       Icons.fingerprint,
            //       color: Colors.green,
            //     ),
            //     labelStyle: TextStyle(color: Colors.green),
            //     focusedBorder: OutlineInputBorder(
            //       borderSide: BorderSide(width: 2.0, color: Colors.green),
            //     ),
            //   ),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     style:
            //         ElevatedButton.styleFrom(backgroundColor: Colors.green),
            //     onPressed: () {
            //       if (formKey.currentState!.validate()) {
            //         SignUpController.instance.registerUser(
            //             controller.email.text.trim(),
            //             controller.password.text.trim());
            //       }
            //     },
            //     child: Text("Signup".toUpperCase()),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
