import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:customer/equipment/controller/auth_controller.dart';
import 'package:customer/equipment/controller/cart_controller.dart';
import 'package:customer/equipment/controller/location_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/controller/wishlist_controller.dart';
import 'package:customer/equipment/data/model/body/notification_body.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/util/app_constants.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/images.dart';
import 'package:customer/equipment/view/base/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/light_theme.dart';

class SplashScreen extends StatefulWidget {
  final NotificationBody? body;
  const SplashScreen({Key? key, required this.body}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>  with TickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

 late AnimationController animation;
  late Animation<double> _fadeInFadeOut;


  @override
  void initState() {
    super.initState();
    animation = AnimationController(vsync: this, duration: Duration(seconds: 2),);
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1).animate(animation);

    // animation.addStatusListener((status){
    //   if(status == AnimationStatus.completed){
    //     animation.forward();
    //   }
    //   else if(status == AnimationStatus.dismissed){
    //     animation.forward();
    //   }
    // });
    animation.forward();
    bool firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? const SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection'.tr : 'connected'.tr,
            textAlign: TextAlign.center,
          ),
        ));
        if(!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    Get.find<EQSplashControllerEquip>().initSharedData();
    Get.find<EQCartController>().getCartData();
    _route();

  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  void _route() {
    Get.find<EQSplashControllerEquip>().getConfigData().then((isSuccess) {
      if(isSuccess) {
        Timer(const Duration(seconds: 1), () async {
          double? minimumVersion = 0;
          if(GetPlatform.isAndroid) {
            minimumVersion = Get.find<EQSplashControllerEquip>().configModel!.appMinimumVersionAndroid;
          }else if(GetPlatform.isIOS) {
            minimumVersion = Get.find<EQSplashControllerEquip>().configModel!.appMinimumVersionIos;
          }
          if(AppConstants.appVersion < minimumVersion! || Get.find<EQSplashControllerEquip>().configModel!.maintenanceMode!) {
            Get.offNamed(RouteHelper.getUpdateRoute(AppConstants.appVersion < minimumVersion));
          }else {
            if(widget.body != null) {
              if (widget.body!.notificationType == NotificationType.order) {
                Get.offNamed(RouteHelper.getOrderDetailsRoute(widget.body!.orderId, fromNotification: true));
              }else if(widget.body!.notificationType == NotificationType.general){
                Get.offNamed(RouteHelper.getNotificationRoute(fromNotification: true));
              }else {
                Get.offNamed(RouteHelper.getChatRoute(notificationBody: widget.body, conversationID: widget.body!.conversationId, fromNotification: true));
              }
            }else {
              if (Get.find<EQAuthController>().isLoggedIn()) {
                Get.find<EQAuthController>().updateToken();
                if (Get.find<EQLocationController>().getUserAddress() != null) {
                  await Get.find<EQWishListController>().getWishList();
                  Get.offNamed(RouteHelper.getInitialRoute(fromSplash: true));
                } else {
                  Get.find<EQLocationController>().navigateToLocationScreen('splash', offNamed: true);
                }
              } else {
                if (Get.find<EQSplashControllerEquip>().showIntro()!) {
                  if(AppConstants.languages.length > 1) {
                    Get.offNamed(RouteHelper.getLanguageRoute('splash'));
                  }else {
                    Get.offNamed(RouteHelper.getOnBoardingRoute());
                  }
                } else {
                  Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
                }
              }
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.find<EQSplashControllerEquip>().initSharedData();
    if(Get.find<EQLocationController>().getUserAddress() != null && Get.find<EQLocationController>().getUserAddress()!.zoneIds == null) {
      Get.find<EQAuthController>().clearSharedAddress();
    }

    return Scaffold(
      key: _globalKey,
      backgroundColor: Get.theme.primaryColor,
      body: GetBuilder<EQSplashControllerEquip>(builder: (splashController) {
        return Center(
          child: splashController.hasConnection ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              FadeTransition(opacity: _fadeInFadeOut,
              child: Image.asset(Images.logoSplash, width: 200)),
              
              const SizedBox(height: Dimensions.paddingSizeSmall),
              // Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: 25)),
            ],
          ) : NoInternetScreen(child: SplashScreen(body: widget.body)),
        );
      }),
    );
  }
}
