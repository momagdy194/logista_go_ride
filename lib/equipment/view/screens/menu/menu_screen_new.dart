import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/equipment/controller/auth_controller.dart';
import 'package:customer/equipment/controller/cart_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/controller/user_controller.dart';
import 'package:customer/equipment/controller/wishlist_controller.dart';
import 'package:customer/equipment/helper/date_converter.dart';
import 'package:customer/equipment/helper/price_converter.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/images.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/confirmation_dialog.dart';
import 'package:customer/equipment/view/base/custom_image.dart';
import 'package:customer/equipment/view/screens/auth/sign_in_screen.dart';
import 'package:customer/equipment/view/screens/menu/widget/portion_widget.dart';

class MenuScreenNew extends StatefulWidget {
  const MenuScreenNew({Key? key}) : super(key: key);

  @override
  State<MenuScreenNew> createState() => _MenuScreenNewState();
}

class _MenuScreenNewState extends State<MenuScreenNew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<EQUserController>(builder: (userController) {
        final bool isLoggedIn = Get.find<EQAuthController>().isLoggedIn();

        return Column(children: [
          Container(
            // decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Padding(
              padding:   EdgeInsets.only(
                left: Dimensions.paddingSizeExtremeLarge,
                right: Dimensions.paddingSizeExtremeLarge,
                top: 50,
                bottom: Dimensions.paddingSizeExtremeLarge,
              ),
              child: Row(children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  padding:   EdgeInsets.all(1),
                  child: ClipOval(
                      child: CustomImage(
                    placeholder: Images.guestIconLight,
                    image:
                        '${Get.find<EQSplashControllerEquip>().configModel!.baseUrls!.customerImageUrl}'
                        '/${(userController.userInfoModel != null && isLoggedIn) ? userController.userInfoModel!.image : ''}',
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  )),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isLoggedIn
                              ? '${userController.userInfoModel?.fName} ${userController.userInfoModel?.lName}'
                              : 'guest_user'.tr,
                          style: robotoBold.copyWith(
                              fontSize: Dimensions.fontSizeExtraLarge,
                              color: Theme.of(context).primaryColor),
                        ),
                        const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),
                        isLoggedIn
                            ? Text(
                                userController.userInfoModel != null
                                    ? DateConverter.containTAndZToUTCFormat(
                                        userController
                                            .userInfoModel!.createdAt!)
                                    : '',
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).primaryColor),
                              )
                            : InkWell(
                                onTap: () async {
                                  if (!ResponsiveHelper.isDesktop(context)) {
                                    await Get.toNamed(
                                        RouteHelper.getSignInRoute(
                                            Get.currentRoute));
                                  } else {
                                    Get.dialog(const SignInScreen(
                                        exitFromApp: false,
                                        backFromThis: true));
                                  }
                                },
                                child: Text(
                                  'login_to_view_all_feature'.tr,
                                  style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    // color: Theme.of(context).cardColor
                                  ),
                                ),
                              ),
                      ]),
                ),
              ]),
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Ink(
              // color: Theme.of(context).primaryColor.withOpacity(0.1),
              padding:   EdgeInsets.only(top: Dimensions.paddingSizeLarge),
              child: Column(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding:   EdgeInsets.only(
                        left: Dimensions.paddingSizeDefault,
                        right: Dimensions.paddingSizeDefault),
                    child: Text(
                      'general'.tr,
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.5)),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      // color: Theme.of(context).cardColor ,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusDefault),
                      // boxShadow: [
                      //   BoxShadow(
                      //       color: Colors.grey[Get.isDarkMode ? 800 : 200]!,
                      //       spreadRadius: 1,
                      //       blurRadius: 5)
                      // ],
                    ),
                    padding:   EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeLarge,
                        vertical: Dimensions.paddingSizeDefault),
                    margin:   EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Column(children: [
                      PortionWidget(
                          hideDivider: true,
                          icon: Images.profileIcon,
                          title: 'profile'.tr,
                          route: RouteHelper.getProfileRoute()),
                      PortionWidget(
                          hideDivider: true,
                          icon: Images.addressIcon,
                          title: 'my_address'.tr,
                          route: RouteHelper.getAddressRoute()),
                      PortionWidget(
                          icon: Images.languageIcon,
                          title: 'language'.tr,
                          route: RouteHelper.getLanguageRoute('menu')),
                    ]),
                  ),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding:   EdgeInsets.only(
                        left: Dimensions.paddingSizeDefault,
                        right: Dimensions.paddingSizeDefault),
                    child: Text(
                      'promotional_activity'.tr,
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.5)),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      // color: Theme.of(context).cardColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusDefault),
                      // boxShadow: [
                      //   BoxShadow(
                      //       color: Colors.grey[Get.isDarkMode ? 800 : 200]!,
                      //       spreadRadius: 1,
                      //       blurRadius: 5)
                      // ],
                    ),
                    padding:   EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeLarge,
                        vertical: Dimensions.paddingSizeDefault),
                    margin:   EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Column(children: [
                      PortionWidget(
                        icon: Images.couponIcon,
                        title: 'coupon'.tr,
                        route: RouteHelper.getCouponRoute(),
                        hideDivider: true,
                      ),
                      (Get.find<EQSplashControllerEquip>()
                                  .configModel!
                                  .loyaltyPointStatus ==
                              1)
                          ? PortionWidget(
                              icon: Images.pointIcon,
                              title: 'loyalty_points'.tr,
                              route: RouteHelper.getWalletRoute(false),
                              hideDivider: Get.find<EQSplashControllerEquip>()
                                          .configModel!
                                          .customerWalletStatus !=
                                      1
                                  ? false
                                  : true,
                              suffix: !isLoggedIn
                                  ? null
                                  : '${userController.userInfoModel?.loyaltyPoint != null ? userController.userInfoModel!.loyaltyPoint.toString() : '0'} ${'points'.tr}',
                            )
                          : const SizedBox(),
                      (Get.find<EQSplashControllerEquip>()
                                  .configModel!
                                  .customerWalletStatus ==
                              1)
                          ? PortionWidget(
                              icon: Images.walletIcon,
                              title: 'my_wallet'.tr,
                              // hideDivider: true,
                              route: RouteHelper.getWalletRoute(true),
                              suffix: !isLoggedIn
                                  ? null
                                  : PriceConverter.convertPrice(
                                      userController.userInfoModel != null
                                          ? userController
                                              .userInfoModel!.walletBalance
                                          : 0),
                            )
                          : const SizedBox(),
                    ]),
                  )
                ]),

                // Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                //   Padding(
                //     padding:   EdgeInsets.only(
                //         left: Dimensions.paddingSizeDefault,
                //         right: Dimensions.paddingSizeDefault),
                //     child: Text(
                //       'earnings'.tr,
                //       style: robotoMedium.copyWith(
                //           fontSize: Dimensions.fontSizeDefault,
                //           color:
                //               Theme.of(context).primaryColor.withOpacity(0.5)),
                //     ),
                //   ),
                //   Container(
                //     decoration: BoxDecoration(
                //       color: Theme.of(context).cardColor,
                //       borderRadius:
                //           BorderRadius.circular(Dimensions.radiusDefault),
                //       // boxShadow: [
                //       //   BoxShadow(
                //       //       color: Colors.grey[Get.isDarkMode ? 800 : 200]!,
                //       //       spreadRadius: 1,
                //       //       blurRadius: 5)
                //       // ],
                //     ),
                //     padding:   EdgeInsets.symmetric(
                //         horizontal: Dimensions.paddingSizeLarge,
                //         vertical: Dimensions.paddingSizeDefault),
                //     margin:   EdgeInsets.all(Dimensions.paddingSizeDefault),
                //     child: Column(children: [
                //       (Get.find<SplashController>()
                //                   .configModel!
                //                   .refEarningStatus ==
                //               1)
                //           ? PortionWidget(
                //               icon: Images.referIcon,
                //               title: 'refer_and_earn'.tr,
                //               route: RouteHelper.getReferAndEarnRoute(),
                //               hideDivider: true,
                //             )
                //           : const SizedBox(),
                //       (Get.find<SplashController>()
                //                   .configModel!
                //                   .toggleDmRegistration! &&
                //               !ResponsiveHelper.isDesktop(context))
                //           ? PortionWidget(
                //               icon: Images.dmIcon,
                //               title: 'join_as_a_delivery_man'.tr,
                //               route:
                //                   RouteHelper.getDeliverymanRegistrationRoute(),
                //               hideDivider: true,
                //             )
                //           : const SizedBox(),
                //       (Get.find<SplashController>()
                //                   .configModel!
                //                   .toggleStoreRegistration! &&
                //               !ResponsiveHelper.isDesktop(context))
                //           ? PortionWidget(
                //               icon: Images.storeIcon,
                //               title: 'open_store'.tr,
                //               hideDivider: true,
                //               route:
                //                   RouteHelper.getRestaurantRegistrationRoute(),
                //             )
                //           : const SizedBox(),
                //     ]),
                //   )
                // ]),

                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding:   EdgeInsets.only(
                        left: Dimensions.paddingSizeDefault,
                        right: Dimensions.paddingSizeDefault),
                    child: Text(
                      'help_and_support'.tr,
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.5)),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      // color: Theme.of(context).cardColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusDefault),
                      // boxShadow: [
                      //   BoxShadow(
                      //       color: Colors.grey[Get.isDarkMode ? 800 : 200]!,
                      //       spreadRadius: 1,
                      //       blurRadius: 5)
                      // ],
                    ),
                    padding:   EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeLarge,
                        vertical: Dimensions.paddingSizeDefault),
                    margin:   EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Column(children: [
                      PortionWidget(
                          hideDivider: true,
                          icon: Images.chatIcon,
                          title: 'live_chat'.tr,
                          route: RouteHelper.getConversationRoute()),
                      PortionWidget(
                          hideDivider: true,
                          icon: Images.helpIcon,
                          title: 'help_and_support'.tr,
                          route: RouteHelper.getSupportRoute()),
                      PortionWidget(
                          hideDivider: true,
                          icon: Images.aboutIcon,
                          title: 'about_us'.tr,
                          route: RouteHelper.getHtmlRoute('about-us')),
                      PortionWidget(
                          hideDivider: true,
                          icon: Images.termsIcon,
                          title: 'terms_conditions'.tr,
                          route:
                              RouteHelper.getHtmlRoute('terms-and-condition')),
                      PortionWidget(
                          hideDivider: true,
                          icon: Images.privacyIcon,
                          title: 'privacy_policy'.tr,
                          route: RouteHelper.getHtmlRoute('privacy-policy')),
                      (Get.find<EQSplashControllerEquip>()
                                  .configModel!
                                  .refundPolicyStatus ==
                              1)
                          ? PortionWidget(
                              hideDivider: true,
                              icon: Images.refundIcon,
                              title: 'refund_policy'.tr,
                              route: RouteHelper.getHtmlRoute('refund-policy'),
                            )
                          : const SizedBox(),
                      (Get.find<EQSplashControllerEquip>()
                                  .configModel!
                                  .cancellationPolicyStatus ==
                              1)
                          ? PortionWidget(
                              hideDivider: true,
                              icon: Images.cancelationIcon,
                              title: 'cancellation_policy'.tr,
                              route: RouteHelper.getHtmlRoute(
                                  'cancellation-policy'),
                            )
                          : const SizedBox(),
                      (Get.find<EQSplashControllerEquip>()
                                  .configModel!
                                  .shippingPolicyStatus ==
                              1)
                          ? PortionWidget(
                              icon: Images.shippingIcon,
                              title: 'shipping_policy'.tr,
                              hideDivider: true,
                              route:
                                  RouteHelper.getHtmlRoute('shipping-policy'),
                            )
                          : const SizedBox(),
                    ]),
                  )
                ]),
                InkWell(
                  onTap: () {
                    if (Get.find<EQAuthController>().isLoggedIn()) {
                      Get.dialog(
                          ConfirmationDialog(
                              icon: Images.support,
                              description: 'are_you_sure_to_logout'.tr,
                              isLogOut: true,
                              onYesPressed: () {
                                Get.find<EQAuthController>().clearSharedData();
                                Get.find<EQAuthController>().socialLogout();
                                Get.find<EQCartController>().clearCartList();
                                Get.find<EQWishListController>().removeWishes();
                                if (ResponsiveHelper.isDesktop(context)) {
                                  Get.offAllNamed(
                                      RouteHelper.getInitialRoute());
                                } else {
                                  Get.offAllNamed(RouteHelper.getSignInRoute(
                                      RouteHelper.splash));
                                }
                              }),
                          useSafeArea: false);
                    } else {
                      Get.find<EQWishListController>().removeWishes();
                      Get.toNamed(RouteHelper.getSignInRoute(Get.currentRoute));
                    }
                  },
                  child: Padding(
                    padding:   EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeSmall),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding:   EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.red),
                            child: Icon(
                              Icons.power_settings_new_sharp,
                              size: 18,
                              //  color: Theme.of(context).cardColor
                            ),
                          ),
                          const SizedBox(
                              width: Dimensions.paddingSizeExtraSmall),
                          Text(
                              Get.find<EQAuthController>().isLoggedIn()
                                  ? 'logout'.tr
                                  : 'sign_in'.tr,
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge))
                        ]),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtremeLarge)
              ]),
            ),
          )),
        ]);
      }),
    );
  }
}
