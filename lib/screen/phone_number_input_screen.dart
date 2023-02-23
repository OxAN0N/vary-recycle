// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:rive/rive.dart';
// import 'package:vary_recycle/screen/SMS_verification_screen.dart';

// class PhoneNumberInputScreen extends StatefulWidget {
//   const PhoneNumberInputScreen({super.key, required this.user});
//   final User user;

//   @override
//   _PhoneNumberInputScreenState createState() => _PhoneNumberInputScreenState();
// }

// class _PhoneNumberInputScreenState extends State<PhoneNumberInputScreen> {
//   final _phoneNumberController = TextEditingController();
//   String? _verificationId;

//   Future<void> _signInWithPhoneNumber() async {
//     try {
//       // phoneNumber 문자열에서 공백 제거
//       final phoneNumber =
//           _phoneNumberController.text.replaceAll(RegExp(r'\s+\b|\b\s'), '');
          
//       // 인증 문자열 전송
//       verificationCompleted(AuthCredential phoneAuthCredential) async {
//         await widget.user.updatePhoneNumber(phoneAuthCredential);
//         Navigator.pop(context);
//       }

//       verificationFailed(FirebaseAuthException authException) {
//         print('Verificaton failed: $authException');
//         // 에러 메시지를 표시하거나 다른 작업을 수행.
//       }

//       codeSent(String verificationId, [int? forceResendingToken]) async {
//         _verificationId = verificationId;
//         // 다음 화면으로 이동
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => SmsVerificationPage(
//                           verificationId: verificationId,

//                     phoneNumber: _phoneNumberController.text,
//                   )),
//         );
//       }

//       codeAutoRetrievalTimeout(String verificationId) {
//         _verificationId = verificationId;
//       }

//       await FirebaseAuth.instance.verifyPhoneNumber(
//           phoneNumber: phoneNumber,
//           verificationCompleted: verificationCompleted,
//           verificationFailed: verificationFailed,
//           codeSent: codeSent,
//           codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
//     } catch (e) {
//       // 에러 메시지를 표시하거나 다른 작업을 수행할 수 있습니다.
//       print('Failed to sign in with phone number: $e');
//     }
//   }

//   @override
//   void dispose() {
//     // 컨트롤러를 dispose합니다.
//     _phoneNumberController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Container(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(
//                   width: 400,
//                   height: 200,
//                   child: RiveAnimation.asset(
//                     "assets/RiveAssets/natural.div",
//                     fit: BoxFit.fill,
//                     alignment: Alignment.center,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   ("Get on Recyling!"),
//                   style: Theme.of(context).textTheme.displaySmall,
//                 ),
//                 Text(("Enter you Phone Number."),
//                     style: Theme.of(context).textTheme.bodyLarge),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 TextFormField(
//                   controller: _phoneNumberController,
//                   keyboardType: TextInputType.phone,
//                   decoration: InputDecoration(
//                     labelText: 'Phone Number',
//                     hintText: 'Enter your phone number',
//                     prefixText: '+82',
//                     filled: true,
//                     fillColor: Colors.grey[200],
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: _signInWithPhoneNumber,
//                   child: const Text('Next'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
