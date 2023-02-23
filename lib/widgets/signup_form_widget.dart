import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vary_recycle/screen/otp_screen.dart';
import 'package:vary_recycle/src/controllers/signup_controller.dart';
import 'package:vary_recycle/widgets/google_login_widget.dart';

import 'google_login_widget.dart';

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: controller.fullName,
                decoration: const InputDecoration(
                  label: Text("Full Name"),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                    color: Colors.green,
                  ),
                  labelStyle: TextStyle(color: Colors.green),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0, color: Colors.green),
                  ),
                ),
                icon: const Image(
                    image: AssetImage('assets/google.png'), width: 20.0),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: controller.email,
                decoration: const InputDecoration(
                  label: Text("Email"),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Colors.green,
                  ),
                  labelStyle: TextStyle(color: Colors.green),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0, color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: controller.phoneNo,
                decoration: const InputDecoration(
                  label: Text("Phone No."),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.phone_android_rounded,
                    color: Colors.green,
                  ),
                  labelStyle: TextStyle(color: Colors.green),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0, color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: controller.password,
                decoration: const InputDecoration(
                  label: Text("Password"),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.fingerprint,
                    color: Colors.green,
                  ),
                  labelStyle: TextStyle(color: Colors.green),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0, color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // final user = UserModel(
                      //   email: controller.email.text.trim(),
                      //   password: controller.password.text.trim(),
                      //   fullName: controller.fullName.text.trim(),
                      // );
                      SignUpController.instance
                          .phoneAuthentication(controller.phoneNo.text.trim());
                      // SignUpController.instance.registerUser(
                      //     controller.email.text.trim(),
                      //     controller.password.text.trim());
                      Get.to(() => const OTPscreen());
                    }
                  },
                  child: Text("Signup".toUpperCase()),
                ),
              ),
              Column(
                children: const [
                  SizedBox(
                    height: 10,
                  ),
                  Text("OR"),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              const GoogleLogin(),
            ],
          )),
    );
  }
}
