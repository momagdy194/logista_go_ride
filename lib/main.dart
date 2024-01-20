import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:customer/custom_ride/controller/global_setting_conroller.dart';
import 'package:customer/custom_ride/utils/DarkThemeProvider.dart';
import 'package:customer/custom_ride/firebase_options.dart';
import 'package:customer/custom_ride/services/localization_service.dart';
import 'package:customer/custom_ride/themes/Styles.dart';
import 'package:customer/custom_ride/ui/splash_screen.dart';
import 'package:customer/custom_ride/utils/DarkThemeProvider.dart';
import 'package:customer/equipment/controller/auth_controller.dart';
import 'package:customer/equipment/controller/cart_controller.dart';
import 'package:customer/equipment/controller/localization_controller.dart';
import 'package:customer/equipment/controller/location_controller.dart';
import 'package:customer/equipment/controller/theme_controller.dart';
import 'package:customer/equipment/controller/wishlist_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:url_strategy/url_strategy.dart';

import 'custom_ride/utils/Preferences.dart';
import 'equipment/controller/splash_controller.dart';
import 'equipment/data/model/body/notification_body.dart';
import 'equipment/helper/notification_helper.dart';
import 'equipment/helper/get_di.dart' as di;
import 'equipment/helper/responsive_helper.dart';
import 'equipment/helper/route_helper.dart';
import 'equipment/util/app_constants.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // name: 'name-here',
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  await Preferences.initPref();


  if (ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = MyHttpOverrides();
  }
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  if (GetPlatform.isWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyDFN-73p8zKVZbA0i5DtO215XzAb-xuGSE',
          appId: '1:1000163153346:web:4f702a4b5adbd5c906b25b',
          messagingSenderId: 'G-L1GNL2YV61',
          projectId: 'ammart-8885e',
        ));
  }
  await Firebase.initializeApp();
  Map<String, Map<String, String>> languages = await di.init();

  NotificationBody? body;
  try {
    if (GetPlatform.isMobile) {
      final RemoteMessage? remoteMessage =
      await FirebaseMessaging.instance.getInitialMessage();
      if (remoteMessage != null) {
        body = NotificationHelper.convertNotification(remoteMessage.data);
      }

      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  } catch (_) {}

  if (ResponsiveHelper.isWeb()) {
    // await FacebookAuth.instance.webAndDesktopInitialize(
    //   appId: "380903914182154",
    //   cookie: true,
    //   xfbml: true,
    //   version: "v15.0",
    // );
  }


  runApp(  MyApp(languages: languages,));
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>>? languages;

  const MyApp({Key? key, required this.languages,});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void _route() async {
    if (GetPlatform.isWeb) {

      await Get.find<EQSplashControllerEquip>().initSharedData();
      if (Get.find<EQLocationController>().getUserAddress() != null &&
          Get.find<EQLocationController>().getUserAddress()!.zoneIds == null) {
        Get.find<EQAuthController>().clearSharedAddress();
      }
      Get.find<EQCartController>().getCartData();
    }
    Get.find<EQSplashControllerEquip>()
        .getConfigData(loadLandingData: GetPlatform.isWeb)
        .then((bool isSuccess) async {
      if (isSuccess) {
        if (Get.find<EQAuthController>().isLoggedIn()) {
          Get.find<EQAuthController>().updateToken();
          await Get.find<EQWishListController>().getWishList();
        }
      }
    });
  }






  @override
  void initState() {
    getCurrentAppTheme();
    _route();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme = await themeChangeProvider.darkThemePreference.getTheme();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(builder: (context, value, child) {
        return GetBuilder<EQThemeController>(builder: (themeController) {
          return GetBuilder<EQLocalizationController>(builder: (localizeController) {
            return GetBuilder<EQSplashControllerEquip>(builder: (splashController) {
              return (GetPlatform.isWeb && splashController.configModel == null)
                  ? const SizedBox()
                  :GetMaterialApp(
                  // ? RouteHelper.getInitialRoute()
                  //     : RouteHelper.getSplashRoute(),
                  // routes: ,
                  // getPages: RouteHelper.routes,
                  getPages:RouteHelper.routes,
                  title: 'Logista',

                  debugShowCheckedModeBanner: false,
                  theme: Styles.themeData(



                      false,
                      // themeChangeProvider.darkTheme == 0
                      //     ? true
                      //     : themeChangeProvider.darkTheme == 1
                      //         ? false
                      //         : themeChangeProvider.getSystemThem(),
                      context
                  ),
                  localizationsDelegates: const [
                    CountryLocalizations.delegate,
                  ],

                  // fallbackLocale: Locale(
                  //     AppConstants.languages[0].languageCode!,
                  //     AppConstants.languages[0].countryCode),
                  locale: LocalizationService.locale,
                  fallbackLocale: LocalizationService.locale,
                  translations: LocalizationService(),
                  builder:    EasyLoading.init(),
                  // builder: (context,Widget? child) {
                  //
                  //   child = ResponsiveWrapper.builder(
                  //     child,
                  //     maxWidth: 1080,
                  //     minWidth: 380,
                  //     defaultScale: true,
                  //     breakpoints: [
                  //       const ResponsiveBreakpoint.resize(460, name: MOBILE),
                  //       const ResponsiveBreakpoint.resize(460, name: PHONE),
                  //       const ResponsiveBreakpoint.resize(450, name: TABLET),
                  //       const ResponsiveBreakpoint.autoScale(1200, name: DESKTOP),
                  //       const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
                  //     ],
                  //     background: Container(color: const Color(0xFFF5F5F5)),
                  //   );
                  //   return child;
                  // },
                  home: GetBuilder<GlobalSettingController>(
                      init: GlobalSettingController(),
                      builder: (context) {
                        return const SplashScreen();
                      }));  });
          });
        });
      }),
    );
  }
}
