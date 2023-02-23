import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vary_recycle/screen/home_screen.dart';

class SMSVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const SMSVerificationScreen(
      {super.key, required this.phoneNumber, required this.verificationId});

  @override
  _SMSVerificationScreenState createState() => _SMSVerificationScreenState();
}

class _SMSVerificationScreenState extends State<SMSVerificationScreen> {
  final _smsCodeController = TextEditingController();

// 구글 로그인으로 로그인한 사용자 정보로 SMS 인증으로 로그인한 사용자 정보를 업데이트하는 함수
  Future<UserCredential?> updatePhoneNumberAuthWithGoogleAuth(
      String verificationId, String smsCode) async {
    // 현재 로그인된 사용자 정보 가져오기
    User? user = FirebaseAuth.instance.currentUser;

    // 구글 로그인이 아닌 경우에는 아무 작업도 수행하지 않음
    if (user?.providerData.first.providerId != 'google.com') {
      return null;
    }

    // PhoneAuthCredential 객체 생성
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    // PhoneAuthCredential 객체를 사용하여 사용자 인증 정보 업데이트
    await user?.updatePhoneNumber(phoneAuthCredential);
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: _smsCodeController.text.trim(),
    );

    // 업데이트된 사용자 정보 출력
    print('User updated phone number: ${user?.phoneNumber}');
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential?> _signInWithPhoneNumber() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    try {
      updatePhoneNumberAuthWithGoogleAuth(
          widget.verificationId, _smsCodeController.text.trim());
      // if (user != null) {
      // user = phoneUser;
      // print()

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );

      // }
    } on FirebaseAuthException {
      // ...
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Enter the code sent to ${widget.phoneNumber}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _smsCodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                //hintText: '123456',
                labelText: 'Verification code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _signInWithPhoneNumber,
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
