import 'package:flutter/material.dart';
import 'package:vary_recycle/screen/home_screen.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "REWARD SCREEN",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const HomeScreen()),
                    (route) => false);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                '확인',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            )
          ],
        )
      ]),
    );
  }
}
