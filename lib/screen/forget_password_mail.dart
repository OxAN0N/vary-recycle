import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:vary_recycle/screen/otp_screen.dart';
import 'package:vary_recycle/src/form_header_widget.dart';

class ForgetPassswordMailScreen extends StatelessWidget {
  const ForgetPassswordMailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(children: [
              const SizedBox(
                height: 30,
              ),
              const FormHeaderWidget(
                rivAni: RiveAnimation.asset(
                  "assets/RiveAssets/natural.div",
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                ),
                subTitle: "Why did you forget password?",
                title: "Forget Password",
                crossAxisAlignment: CrossAxisAlignment.center,
                heightBetween: 30.0,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                  child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        label: Text("Email"),
                        hintText: ("Email"),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.mail_outline_outlined)),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => const OTPscreen());
                          },
                          child: const Text("Next"))),
                ],
              ))
            ]),
          ),
        ),
      ),
    );
  }
}
