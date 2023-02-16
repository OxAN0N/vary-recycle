import 'package:flutter/material.dart';

class SignupFormWidget extends StatelessWidget {
  const SignupFormWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Form(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
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
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {},
              child: Text("Signup".toUpperCase()),
            ),
          )
        ],
      )),
    );
  }
}
