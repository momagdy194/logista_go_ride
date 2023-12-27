import 'package:customer/equipment/controller/auth_controller.dart';
import 'package:customer/equipment/controller/wishlist_controller.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/view/base/custom_snackbar.dart';
import 'package:get/get.dart';

class ApiChecker {
  static void checkApi(Response response, {bool getXSnackBar = false}) {
    if(response.statusCode == 401) {
      Get.find<EQAuthController>().clearSharedData();
      Get.find<EQWishListController>().removeWishes();
      Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
    }else {
      showCustomSnackBar(response.statusText, getXSnackBar: getXSnackBar);
    }
  }
}
