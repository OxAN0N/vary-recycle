import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/forget_password_mail.dart';
import 'forget_password_btn_widget.dart';

class ForgetPasswordScreen {
  static Future<dynamic> buildShowModelBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (context) => Container(
        height: 250,
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email Authentication",
                style: Theme.of(context).textTheme.headline4),
            Text(
              "Choose option given below to reset your password.",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(height: 30.0),
            ForgetPasswordBtnWidget(
              btnIcon: Icons.mail_outline_outlined,
              title: "E-mail",
              subTitle: "Reset via Mail Verification",
              onTap: () {
                Navigator.pop(context);
                Get.to(() => const ForgetPassswordMailScreen());
              },
            )
          ],
        ),
      ),
    );
  }
}
