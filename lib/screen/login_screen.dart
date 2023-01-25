import 'package:flutter/material.dart';
import 'package:vary_recycle/widgets/google_login_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'LOGIN SCREEN',
                style: TextStyle(fontSize: 32),
              ),
              GoogleLogin(),
            ],
          ),
        ],
      ),
    );
  }
}
