import 'dart:async';

import 'package:customer/custom_ride/ui/auth_screen/login_screen.dart';
import 'package:customer/custom_ride/ui/dashboard_screen.dart';
import 'package:customer/custom_ride/ui/on_boarding_screen.dart';
import 'package:customer/custom_ride/utils/Preferences.dart';
import 'package:customer/custom_ride/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    Timer(const Duration(seconds: 3), () => redirectScreen());
    super.onInit();
  }

  redirectScreen() async {
    if (Preferences.getBoolean(Preferences.isFinishOnBoardingKey) == false) {
      Get.offAll(const OnBoardingScreen());
    } else {
      bool isLogin = await FireStoreUtils.isLogin();
      if (isLogin == true) {
        Get.offAll(  DashBoardScreen());
      } else {
        Get.offAll(const LoginScreen());
      }
    }
  }
}
