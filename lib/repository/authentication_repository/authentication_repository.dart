import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:vary_recycle/repository/authentication_repository/exceptions/signup_email_password_failure.dart';
import 'package:vary_recycle/screen/home_screen.dart';
import 'package:vary_recycle/screen/welcom_screen.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //Variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationID = ''.obs;

  @override
  void onReady() {
    // TODO: implement onReady
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    //로그아웃 시 다른 화면으로 이동하는 게 아니라 모든 이전 화면 제거 후,
    //사용자가 null이 아닌 경우 환영 화면으로 사용자를 리디렉션한다. 사용자가 이미 로그인하고 앱을 닫고 다시 켰을 때 환영 화면으로 간다는 의미.
    //사용자가 로그인 버튼을 클릭하고 인증을 받은 다음 사용자를 대시보드로 리디렉션한다.
    user == null
        ? Get.offAll(() => const WelcomeScreen())
        : Get.offAll(() => const HomeScreen());
  }

  Future<void> phoneAuthentication(String phoneNo) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
      },
      codeSent: (verificationId, resendToken) {
        verificationID.value = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {
        verificationID.value = verificationId;
      },
      verificationFailed: (e) {
        if (e.code == 'invalid-phone-number') {
          Get.snackbar('Error', 'The provided phone number is not valid');
        } else {
          Get.snackbar('Error', 'Something went wrong. Try again.');
          print(e.code);
        }
      },
    );
  }

  Future<bool> verifyOTP(String otp) async {
    var credentials = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationID.value, smsCode: otp));
    return credentials.user != null ? true : false;
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password); //클라우드 문이므로 예외를 throw할 수 있으므로 await로 시작해야 한다.
      firebaseUser.value != null
          ? Get.offAll(() => const WelcomeScreen())
          : Get.to(() =>
              const HomeScreen()); //FirebaseUser.value rkqtdl null이 아닌지를 확인하여 해당 사용자를 리디렉션. 이전 화면을 모두 제거하고 대시보드로 이동,
    } on FirebaseAuthException catch (e) {
      final ex = SignUpwithEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    } catch (_) {
      const ex = SignUpwithEmailAndPasswordFailure();
      print('EXCEPTION - ${ex.message}');
      throw ex;
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (_) {}
  }

  Future<void> logout() async => await _auth.signOut();
}
