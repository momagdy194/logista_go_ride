import 'dart:developer';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:customer/custom_ride/constant/constant.dart';
import 'package:customer/custom_ride/constant/show_toast_dialog.dart';
import 'package:customer/custom_ride/controller/login_controller.dart';
import 'package:customer/custom_ride/model/user_model.dart';
import 'package:customer/custom_ride/themes/app_colors.dart';
import 'package:customer/custom_ride/themes/button_them.dart';
import 'package:customer/custom_ride/themes/responsive.dart';
import 'package:customer/custom_ride/ui/auth_screen/information_screen.dart';
import 'package:customer/custom_ride/ui/dashboard_screen.dart';
import 'package:customer/custom_ride/ui/terms_and_condition/terms_and_condition_screen.dart';
import 'package:customer/custom_ride/utils/DarkThemeProvider.dart';
import 'package:customer/custom_ride/utils/fire_store_utils.dart';
import 'package:customer/equipment/controller/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<LoginController>(
        init: LoginController(),
        builder: (controller) {
          return Scaffold(
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height:250,child: Image.asset("assets/app_logo.png", width: Responsive.width(100, context))),
                    Padding(
                      padding:   EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:   EdgeInsets.only(top: 10),
                            child: Text("Login".tr, style: GoogleFonts.cairo(fontWeight: FontWeight.w600, fontSize: 18)),
                          ),
                          Padding(
                            padding:   EdgeInsets.only(top: 5),
                            child: Text("Welcome Back! We are happy to have \n you back".tr, style: GoogleFonts.cairo(fontWeight: FontWeight.w400)),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                              validator: (value) => value != null && value.isNotEmpty ? null : 'Required',
                              keyboardType: TextInputType.number,
                              textCapitalization: TextCapitalization.sentences,
                              controller: controller.phoneNumberController.value,
                              textAlign: TextAlign.start,
                              style: GoogleFonts.cairo(color: themeChange.getThem() ? Colors.white : Colors.black),
                              decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: themeChange.getThem() ? AppColors.darkTextField : AppColors.textField,
                                  contentPadding:   EdgeInsets.symmetric(vertical: 12),
                                  prefixIcon: CountryCodePicker(
                                    onChanged: (value) {
                                      controller.countryCode.value = value.dialCode.toString();
                                    },
                                    dialogBackgroundColor: themeChange.getThem() ? AppColors.darkBackground : AppColors.background,
                                    initialSelection: controller.countryCode.value,
                                    comparator: (a, b) => b.name!.compareTo(a.name.toString()),
                                    flagDecoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(2)),
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                                  ),
                                  hintText: "Phone number".tr)),
                          const SizedBox(
                            height: 30,
                          ),
                          ButtonThem.buildButton(
                            context,
                            title: "Next".tr,
                            onPress: () {
                              controller.sendCode();
                            },
                          ),
                          Padding(
                            padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                            child: Row(
                              children: [
                                const Expanded(
                                    child: Divider(
                                  height: 1,
                                )),
                                Padding(
                                  padding:   EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    "OR".tr,
                                    style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ),
Expanded(
                                    child: Divider(
                                  height: 1,
                                )),
                              ],
                            ),
                          ),
                          ButtonThem.buildBorderButton(
                            context,
                            title: "Login with google".tr,
                            iconVisibility: true,
                            iconAssetImage: 'assets/icons/ic_google.png',
                            onPress: () async {
                              ShowToastDialog.showLoader("Please wait".tr);
                              await controller.signInWithGoogle().then((value) {
                                ShowToastDialog.closeLoader();
                                if (value != null) {
                                  if (value.additionalUserInfo!.isNewUser) {
                                    print("----->new user");
                                    UserModel userModel = UserModel();
                                    userModel.id = value.user!.uid;
                                    userModel.email = value.user!.email;
                                    userModel.fullName = value.user!.displayName;
                                    userModel.profilePic = value.user!.photoURL;
                                    userModel.loginType = Constant.googleLoginType;

                                    ShowToastDialog.closeLoader();
                                    Get.to(const InformationScreen(), arguments: {
                                      "userModel": userModel,
                                    });
                                  } else {
                                    print("----->old user");
                                    FireStoreUtils.userExitOrNot(value.user!.uid).then((userExit) async {
                                      ShowToastDialog.closeLoader();
                                      if (userExit == true) {


                                        UserModel? userModel = await FireStoreUtils.getUserProfile(value.user!.uid);
                                        if (userModel != null) {
                                          if (userModel.isActive == true) {
                                            Get.offAll( DashBoardScreen());
                                          } else {
                                            await FirebaseAuth.instance.signOut();
                                            ShowToastDialog.showToast("This user is disable please contact administrator".tr);
                                          }
                                        }
                                      } else {
                                        UserModel userModel = UserModel();
                                        userModel.id = value.user!.uid;
                                        userModel.email = value.user!.email;
                                        userModel.fullName = value.user!.displayName;
                                        userModel.profilePic = value.user!.photoURL;
                                        userModel.loginType = Constant.googleLoginType;

                                        Get.to(const InformationScreen(), arguments: {
                                          "userModel": userModel,
                                        });
                                      }
                                    });
                                  }
                                }
                              });
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Visibility(
                              visible: Platform.isIOS,
                              child: ButtonThem.buildBorderButton(
                                context,
                                title: "Login with apple".tr,
                                iconVisibility: true,
                                iconAssetImage: 'assets/icons/ic_apple.png',
                                onPress: () async {
                                  ShowToastDialog.showLoader("Please wait".tr);
                                  await controller.signInWithApple().then((value) {
                                    ShowToastDialog.closeLoader();
                                    if (value != null) {
                                      if (value.additionalUserInfo!.isNewUser) {
                                        log("----->new user");
                                        UserModel userModel = UserModel();
                                        userModel.id = value.user!.uid;
                                        userModel.email = value.user!.email;
                                        userModel.profilePic = value.user!.photoURL;
                                        userModel.loginType = Constant.appleLoginType;

                                        ShowToastDialog.closeLoader();
                                        Get.to(const InformationScreen(), arguments: {
                                          "userModel": userModel,
                                        });
                                      } else {
                                        print("----->old user");
                                        FireStoreUtils.userExitOrNot(value.user!.uid).then((userExit) async {
                                          ShowToastDialog.closeLoader();

                                          if (userExit == true) {
                                            UserModel? userModel = await FireStoreUtils.getUserProfile(value.user!.uid);
                                            if (userModel != null) {
                                              if (userModel.isActive == true) {
                                                await Get.find<EQAuthController>().login(
                                                    "${userModel.countryCode}${userModel.phoneNumber}",
                                                 "${ userModel.phoneNumber}"
                                                    // SignUpBody(email:"${userModel.email}",password:userModel.phoneNumber,fName: userModel.fullName,lName: "." ,phone:"${userModel.countryCode}${userModel.phoneNumber}"  )
                                          ).then((value) {
                                                  Get.find<EQAuthController>()
                                                      .saveUserNumberAndPassword(
                                                      "${userModel.countryCode}${userModel.phoneNumber}",
                                                      "${userModel.phoneNumber}",
                                                      "${userModel.countryCode}");
                                                });

                                                Get.offAll( DashBoardScreen());




                                              } else {
                                                await FirebaseAuth.instance.signOut();
                                                ShowToastDialog.showToast("This user is disable please contact administrator".tr);
                                              }
                                            }
                                          } else {
                                            UserModel userModel = UserModel();
                                            userModel.id = value.user!.uid;
                                            userModel.email = value.user!.email;
                                            userModel.profilePic = value.user!.photoURL;
                                            userModel.loginType = Constant.googleLoginType;

                                            Get.to(const InformationScreen(), arguments: {
                                              "userModel": userModel,
                                            });
                                          }
                                        });
                                      }
                                    }
                                  });
                                },
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
                padding:   EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: 'By tapping "Next" you agree to '.tr,
                    style: GoogleFonts.cairo(),
                    children: <TextSpan>[
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(const TermsAndConditionScreen(
                                type: "terms",
                              ));
                            },
                          text: 'Terms and conditions'.tr,
                          style: GoogleFonts.cairo(decoration: TextDecoration.underline)),
                      TextSpan(text: ' and ', style: GoogleFonts.cairo()),
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(const TermsAndConditionScreen(
                                type: "privacy",
                              ));
                            },
                          text: 'privacy policy'.tr,
                          style: GoogleFonts.cairo(decoration: TextDecoration.underline)),
                      // can add more TextSpans here...
                    ],
                  ),
                )),
          );
        });
  }
}
