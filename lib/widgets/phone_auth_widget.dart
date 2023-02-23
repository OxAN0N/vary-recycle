// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';

// final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

// Future<void> verifyPhoneNumber(String phoneNumber) async {
//   await firebaseAuth.verifyPhoneNumber(
//     phoneNumber: phoneNumber,
//     verificationCompleted: (PhoneAuthCredential credential) async {
//       // 사용자가 이미 로그인한 경우 자동으로 연결
//       final UserCredential userCredential =
//           await firebaseAuth.signInWithCredential(credential);
//       final user = userCredential.user!;

//       // Firestore에 사용자 데이터 업데이트
//       final userRef =
//           FirebaseFirestore.instance.collection('users').doc(user.uid);
//       await userRef.update({'phone': user.phoneNumber});
//     },
//     verificationFailed: (FirebaseAuthException e) {
//       if (e.code == 'invalid-phone-number') {
//         Get.snackbar('Error', 'The provided phone number is not valid');
//       } else {
//         Get.snackbar('Error', 'Something went wrong. Try again.');
//         print(e.code);
//       }
//       // 인증 실패 처리
//     },
//     codeSent: (String verificationId, int? resendToken) {
//       // 코드를 확인하기 위해 사용자에게 보내진 ID 저장
//       // 나중에 사용자가 코드를 제출할 때 필요
//     },
//     codeAutoRetrievalTimeout: (String verificationId) {
//       // 인증 시간이 초과되었을 때 처리
//     },
//   );
// }

// Future<void> signInWithPhoneNumber(
//     String verificationId, String smsCode) async {
//   final PhoneAuthCredential credential = PhoneAuthProvider.credential(
//     verificationId: verificationId,
//     smsCode: smsCode,
//   );
//   final UserCredential userCredential =
//       await firebaseAuth.signInWithCredential(credential);

//   // Firestore에 사용자 데이터 업데이트
//   final userRef = FirebaseFirestore.instance
//       .collection('users')
//       .doc(userCredential.user!.uid);
//   await userRef.update({'phone': userCredential.user!.phoneNumber});
// }

// Future<void> linkPhoneNumber(String phoneNumber) async {
//   final PhoneAuthCredential credential =
//       PhoneAuthProvider.credential(verificationId: _verificationId, smsCode: _smsCode);
  
//   final User user = firebaseAuth.currentUser!;
  
//   final UserCredential userCredential = await user.linkWithCredential(credential);
// }