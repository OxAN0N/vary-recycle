import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:vary_recycle/screen/SMS_verification_screen.dart';
import 'package:vary_recycle/screen/home_screen.dart';

class PhoneNumberInputScreen extends StatefulWidget {
  final AuthCredential credential;
  const PhoneNumberInputScreen({super.key, required this.credential});

  @override
  _PhoneNumberInputScreenState createState() => _PhoneNumberInputScreenState();
}

class _PhoneNumberInputScreenState extends State<PhoneNumberInputScreen> {
  final _phoneNumberController = TextEditingController();
  final _smsCodeController = TextEditingController();
  String _verificationId = '';

  void _verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+82 ${_phoneNumberController.text}',
      verificationCompleted: _verificationCompleted,
      verificationFailed: _verificationFailed,
      codeSent: _codeSent,
      codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
    );
  }

  void _verificationCompleted(AuthCredential phoneAuthCredential) async {
    await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
    // Do something after phone number verification is complete
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void _verificationFailed(FirebaseAuthException error) {
    print(error.toString());
    // Handle phone number verification failed error
  }

  void _codeSent(String verificationId, int? forceResendingToken) {
    setState(() {
      _verificationId = verificationId;
    });
    // Navigate to SMS code input screen
    Navigator.of(context)
        .pushReplacement(
      MaterialPageRoute(
        builder: (context) => SMSVerificationScreen(
          verificationId: verificationId,
          phoneNumber: '+82 ${_phoneNumberController.text}',
        ),
      ),
    )
        .then((credential) {
      if (credential != null) {
      } else {}
    });
  }

  void _codeAutoRetrievalTimeout(String verificationId) {
    setState(() {
      _verificationId = verificationId;
    });
  }

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
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Text(("Enter you Phone Number."),
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                    prefixText: '+82',
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _verifyPhoneNumber,
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
