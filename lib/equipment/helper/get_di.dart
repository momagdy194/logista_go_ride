
import 'dart:convert';

import 'package:customer/equipment/controller/auth_controller.dart';
import 'package:customer/equipment/controller/banner_controller.dart';
import 'package:customer/equipment/controller/booking_checkout_controller.dart';
import 'package:customer/equipment/controller/campaign_controller.dart';
import 'package:customer/equipment/controller/car_selection_controller.dart';
import 'package:customer/equipment/controller/cart_controller.dart';
import 'package:customer/equipment/controller/category_controller.dart';
import 'package:customer/equipment/controller/chat_controller.dart';
import 'package:customer/equipment/controller/coupon_controller.dart';
import 'package:customer/equipment/controller/localization_controller.dart';
import 'package:customer/equipment/controller/location_controller.dart';
import 'package:customer/equipment/controller/notification_controller.dart';
import 'package:customer/equipment/controller/onboarding_controller.dart';
import 'package:customer/equipment/controller/order_controller.dart';
import 'package:customer/equipment/controller/item_controller.dart';
import 'package:customer/equipment/controller/parcel_controller.dart';
import 'package:customer/equipment/controller/rider_controller.dart';
import 'package:customer/equipment/controller/store_controller.dart';
import 'package:customer/equipment/controller/search_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/controller/theme_controller.dart';
import 'package:customer/equipment/controller/user_controller.dart';
import 'package:customer/equipment/controller/wallet_controller.dart';
import 'package:customer/equipment/controller/wishlist_controller.dart';
import 'package:customer/equipment/data/repository/auth_repo.dart';
import 'package:customer/equipment/data/repository/banner_repo.dart';
import 'package:customer/equipment/data/repository/campaign_repo.dart';
import 'package:customer/equipment/data/repository/car_selection_repo.dart';
import 'package:customer/equipment/data/repository/cart_repo.dart';
import 'package:customer/equipment/data/repository/category_repo.dart';
import 'package:customer/equipment/data/repository/coupon_repo.dart';
import 'package:customer/equipment/data/repository/language_repo.dart';
import 'package:customer/equipment/data/repository/location_repo.dart';
import 'package:customer/equipment/data/repository/notification_repo.dart';
import 'package:customer/equipment/data/repository/onboarding_repo.dart';
import 'package:customer/equipment/data/repository/order_repo.dart';
import 'package:customer/equipment/data/repository/item_repo.dart';
import 'package:customer/equipment/data/repository/parcel_repo.dart';
import 'package:customer/equipment/data/repository/rider_repo.dart';
import 'package:customer/equipment/data/repository/store_repo.dart';
import 'package:customer/equipment/data/repository/search_repo.dart';
import 'package:customer/equipment/data/repository/splash_repo.dart';
import 'package:customer/equipment/data/api/api_client.dart';
import 'package:customer/equipment/data/repository/user_repo.dart';
import 'package:customer/equipment/data/repository/wallet_repo.dart';
import 'package:customer/equipment/data/repository/wishlist_repo.dart';
import 'package:customer/equipment/util/app_constants.dart';
import 'package:customer/equipment/data/model/response/language_model.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../data/repository/chat_repo.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));

  // Repository
  Get.lazyPut(() => SplashRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => LanguageRepo());
  Get.lazyPut(() => OnBoardingRepo());
  Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => LocationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => UserRepo(apiClient: Get.find()));
  Get.lazyPut(() => BannerRepo(apiClient: Get.find()));
  Get.lazyPut(() => CategoryRepo(apiClient: Get.find()));
  Get.lazyPut(() => StoreRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => WishListRepo(apiClient: Get.find()));
  Get.lazyPut(() => ItemRepo(apiClient: Get.find()));
  Get.lazyPut(() => CartRepo(sharedPreferences: Get.find()));
  Get.lazyPut(() => SearchRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CouponRepo(apiClient: Get.find()));
  Get.lazyPut(() => OrderRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => NotificationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CampaignRepo(apiClient: Get.find()));
  Get.lazyPut(() => ParcelRepo(apiClient: Get.find()));
  Get.lazyPut(() => WalletRepo(apiClient: Get.find()));
  Get.lazyPut(() => ChatRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => RiderRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CarSelectionRepo(apiClient: Get.find()));

  // Controller
  Get.lazyPut(() => EQThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => EQSplashControllerEquip(splashRepo: Get.find()));
  Get.lazyPut(() => EQLocalizationController(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => EQOnBoardingController(onboardingRepo: Get.find()));
  Get.lazyPut(() => EQAuthController(authRepo: Get.find()));
  Get.lazyPut(() => EQLocationController(locationRepo: Get.find()));
  Get.lazyPut(() => EQUserController(userRepo: Get.find()));
  Get.lazyPut(() => EQBannerController(bannerRepo: Get.find()));
  Get.lazyPut(() => EQCategoryController(categoryRepo: Get.find()));
  Get.lazyPut(() => EQItemController(itemRepo: Get.find()));
  Get.lazyPut(() => EQCartController(cartRepo: Get.find()));
  Get.lazyPut(() => EQStoreController(storeRepo: Get.find()));
  Get.lazyPut(() => EQWishListController(wishListRepo: Get.find(), itemRepo: Get.find()));
  Get.lazyPut(() => EQSearchingController(searchRepo: Get.find()));
  Get.lazyPut(() => EQCouponController(couponRepo: Get.find()));
  Get.lazyPut(() => EQOrderController(orderRepo: Get.find()));
  Get.lazyPut(() => EQNotificationController(notificationRepo: Get.find()));
  Get.lazyPut(() => EQCampaignController(campaignRepo: Get.find()));
  Get.lazyPut(() => EQParcelController(parcelRepo: Get.find()));
  Get.lazyPut(() => EQWalletController(walletRepo: Get.find()));
  Get.lazyPut(() => EQChatController(chatRepo: Get.find()));
  Get.lazyPut(() => EQRiderController(riderRepo: Get.find()));
  Get.lazyPut(() => EQCarSelectionController(carSelectionRepo: Get.find()));
  Get.lazyPut(() => BookingCheckoutController(riderRepo: Get.find()));

  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
    Map<String, String> json = {};
    mappedJson.forEach((key, value) {
      json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = json;
  }
  return languages;
}
