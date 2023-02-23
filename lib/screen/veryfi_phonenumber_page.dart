// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import '../widgets/phone_auth_widget.dart';

// class VerifyPhoneNumberPage extends StatefulWidget {
//   final String verificationId;
//   const VerifyPhoneNumberPage({super.key, required this.verificationId});

//   @override
//   _VerifyPhoneNumberPageState createState() => _VerifyPhoneNumberPageState();
// }

// class _VerifyPhoneNumberPageState extends State<VerifyPhoneNumberPage> {
//   final TextEditingController _smsController = TextEditingController();

//   Future<void> _submitSmsCode(BuildContext context) async {
//     final String smsCode = _smsController.text.trim();
//     if (smsCode.isEmpty) {
//       return;
//     }

//     try {
//       await signInWithPhoneNumber(widget.verificationId, smsCode);
//       Navigator.pop(context);
//     } on FirebaseAuthException {
//       // 인증 실패 처리
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('전화번호 인증')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text('SMS 코드를 입력하세요'),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 32.0),
//               child: TextField(
//                 controller: _smsController,
//                 decoration: const InputDecoration(hintText: 'SMS 코드'),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () => _submitSmsCode(context),
//               child: const Text('확인'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
