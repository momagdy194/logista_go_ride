import 'package:country_code_picker/country_code_picker.dart';
import 'package:customer/controller/global_setting_conroller.dart';
import 'package:customer/firebase_options.dart';
import 'package:customer/services/localization_service.dart';
import 'package:customer/themes/Styles.dart';
import 'package:customer/ui/splash_screen.dart';
import 'package:customer/utils/DarkThemeProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import 'utils/Preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'name-here',

    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Preferences.initPref();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    getCurrentAppTheme();
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
        return GetMaterialApp(
            title: 'Logista',
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(false,
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
            locale: LocalizationService.locale,
            fallbackLocale: LocalizationService.locale,
            translations: LocalizationService(),
            builder: (context,Widget? child) {
      EasyLoading.init();
              child = ResponsiveWrapper.builder(
                child,
                maxWidth: 1080,
                minWidth: 380,
                defaultScale: true,
                breakpoints: [
                  const ResponsiveBreakpoint.resize(460, name: MOBILE),
                  const ResponsiveBreakpoint.resize(460, name: PHONE),
                  const ResponsiveBreakpoint.resize(450, name: TABLET),
                  const ResponsiveBreakpoint.autoScale(1200, name: DESKTOP),
                  const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
                ],
                background: Container(color: const Color(0xFFF5F5F5)),
              );
              return child;
            },
            home: GetBuilder<GlobalSettingController>(
                init: GlobalSettingController(),
                builder: (context) {
                  return const SplashScreen();
                }));
      }),
    );
  }
}
