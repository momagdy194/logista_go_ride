import 'dart:developer';

import 'package:customer/custom_ride/constant/constant.dart';
import 'package:customer/custom_ride/constant/show_toast_dialog.dart';
import 'package:customer/custom_ride/model/user_model.dart';
import 'package:customer/custom_ride/ui/auth_screen/login_screen.dart';
import 'package:customer/custom_ride/ui/chat_screen/inbox_screen.dart';
import 'package:customer/custom_ride/ui/contact_us/contact_us_screen.dart';
import 'package:customer/custom_ride/ui/faq/faq_screen.dart';
import 'package:customer/custom_ride/ui/home_screens/home_screen.dart';
import 'package:customer/custom_ride/ui/interCity/interCity_screen.dart';
import 'package:customer/custom_ride/ui/intercityOrders/intercity_order_screen.dart';
import 'package:customer/custom_ride/ui/orders/order_screen.dart';
import 'package:customer/custom_ride/ui/profile_screen/profile_screen.dart';
import 'package:customer/custom_ride/ui/referral_screen/referral_screen.dart';
import 'package:customer/custom_ride/ui/settings_screen/setting_screen.dart';
import 'package:customer/custom_ride/ui/wallet/wallet_screen.dart';
import 'package:customer/custom_ride/utils/fire_store_utils.dart';
import 'package:customer/custom_ride/utils/notification_service.dart';
import 'package:customer/custom_ride/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class DashBoardController extends GetxController {
  final drawerItems = [
    DrawerItem('City'.tr, "assets/icons/ic_city.svg"),
    // DrawerItem('OutStation'.tr, "assets/icons/ic_intercity.svg"),
    DrawerItem('Rides'.tr, "assets/icons/ic_order.svg"),
    DrawerItem('Profile'.tr, "assets/icons/ic_profile.svg"),
    // DrawerItem('OutStation Rides'.tr, "assets/icons/ic_order.svg"),
    DrawerItem('My Wallet'.tr, "assets/icons/ic_wallet.svg"),
    DrawerItem('Settings'.tr, "assets/icons/ic_settings.svg"),
    // DrawerItem('Referral a friends'.tr, "assets/icons/ic_referral.svg"),
    DrawerItem('Inbox'.tr, "assets/icons/ic_inbox.svg"),
    // DrawerItem('OutStation Rides'.tr, "assets/icons/ic_order.svg"),
    DrawerItem('Contact us'.tr, "assets/icons/ic_contact_us.svg"),
    DrawerItem('FAQs'.tr, "assets/icons/ic_faq.svg"),
    DrawerItem('Log out'.tr, "assets/icons/ic_logout.svg"),
  ];
  getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return const HomeScreen();
      // case 1:
      //   return const InterCityScreen();
      case 1:
        return const OrderScreen();
      case 2:
        return const ProfileScreen();
      case 3:
        return const WalletScreen();
      case 4:
        return const SettingScreen();
      // case 5:
      //   return const ReferralScreen();
      case 5:
        return const InboxScreen();
      // case 8:
      //   return const InterCityOrderScreen();
      case 6:
        return const ContactUsScreen();
      case 7:
        return const FaqScreen();
      default:
        return const Text("Error");
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getLocation();
    super.onInit();
  }

  RxBool isLoading = true.obs;

  getLocation() async {

    try{
      Constant.currentLocation = await Utils.getCurrentLocation();
      if(Constant.currentLocation != null){
        List<Placemark> placeMarks = await placemarkFromCoordinates(Constant.currentLocation!.latitude, Constant.currentLocation!.longitude);
        print("=====>");
        print(placeMarks.first);
        Constant.country = placeMarks.first.country;
        Constant.city = placeMarks.first.locality;
      }else{
        await Utils.getCurrentLocation().then((value) async {
          Constant.currentLocation = value;
          List<Placemark> placeMarks = await placemarkFromCoordinates(Constant.currentLocation!.latitude, Constant.currentLocation!.longitude);
          print("=====>");
          print(placeMarks.first);
          Constant.country = placeMarks.first.country;
          Constant.city = placeMarks.first.locality;
        });
      }


    }catch(e){

      print("exc:$e");



    }

    await FireStoreUtils().getTaxList().then((value) {
      if (value != null) {
        Constant.taxList = value;
      }
    });


    await FireStoreUtils().getAirports().then((value) {
      if (value != null) {
        Constant.airaPortList = value;
        print("====>");
        print(Constant.airaPortList!.length);
      }
    });
    String token = await NotificationService.getToken();
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      UserModel userModel = value!;
      userModel.fcmToken = token;
      FireStoreUtils.updateUser(userModel);
    });

    isLoading.value = false;

  }

  RxInt selectedDrawerIndex = 0.obs;

  onSelectItem(int index) async {
    print(index);
    if (index == 8) {
      await FirebaseAuth.instance.signOut();
      Get.offAll(const LoginScreen());
    } else {
      selectedDrawerIndex.value = index;
    }
    Get.back();
  }

  Rx<DateTime> currentBackPressTime = DateTime.now().obs;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime.value) > const Duration(seconds:  2)) {
      currentBackPressTime.value = now;
      ShowToastDialog.showToast("Double press to exit",position:EasyLoadingToastPosition.center );
      return Future.value(false);
    }
    return Future.value(true);
  }
}

class DrawerItem {
  String title;
  String icon;

  DrawerItem(this.title, this.icon);
}
