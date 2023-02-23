import 'package:get/get.dart';
import 'package:vary_recycle/repository/authentication_repository/authentication_repository.dart';
import 'package:vary_recycle/screen/home_screen.dart';

class OTPController extends GetxController {
  static OTPController get instance => Get.find();

  void verifyOTP(String otp) async {
    var isVerified = await AuthenticationRepository.instance.verifyOTP(otp);
    isVerified ? Get.offAll(const HomeScreen()) : Get.back();
  }
}
