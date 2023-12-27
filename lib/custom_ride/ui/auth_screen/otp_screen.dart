import 'package:customer/custom_ride/constant/constant.dart';
import 'package:customer/custom_ride/constant/show_toast_dialog.dart';
import 'package:customer/custom_ride/controller/otp_controller.dart';
import 'package:customer/custom_ride/model/user_model.dart';
import 'package:customer/custom_ride/themes/app_colors.dart';
import 'package:customer/custom_ride/themes/button_them.dart';
import 'package:customer/custom_ride/ui/auth_screen/information_screen.dart';
import 'package:customer/custom_ride/ui/dashboard_screen.dart';
import 'package:customer/custom_ride/utils/DarkThemeProvider.dart';
import 'package:customer/custom_ride/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../equipment/controller/auth_controller.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<OtpController>(
        init: OtpController(),
        builder: (controller) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/images/login_image.png"),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text("Verify Phone Number".tr,
                              style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.w600, fontSize: 18)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Text(
                              "We just send a verification code to \n${controller.countryCode.value + controller.phoneNumber.value}"
                                  .tr,
                              style: GoogleFonts.cairo()),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: PinCodeTextField(
                            length: 6,
                            appContext: context,
                            keyboardType: TextInputType.phone,
                            pinTheme: PinTheme(
                              fieldHeight: 50,
                              fieldWidth: 50,
                              activeColor: themeChange.getThem()
                                  ? AppColors.darkTextFieldBorder
                                  : AppColors.textFieldBorder,
                              selectedColor: themeChange.getThem()
                                  ? AppColors.darkTextFieldBorder
                                  : AppColors.textFieldBorder,
                              inactiveColor: themeChange.getThem()
                                  ? AppColors.darkTextFieldBorder
                                  : AppColors.textFieldBorder,
                              activeFillColor: themeChange.getThem()
                                  ? AppColors.darkTextField
                                  : AppColors.textField,
                              inactiveFillColor: themeChange.getThem()
                                  ? AppColors.darkTextField
                                  : AppColors.textField,
                              selectedFillColor: themeChange.getThem()
                                  ? AppColors.darkTextField
                                  : AppColors.textField,
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enableActiveFill: true,
                            cursorColor: AppColors.primary,
                            controller: controller.otpController.value,
                            onCompleted: (v) async {},
                            onChanged: (value) {},
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ButtonThem.buildButton(
                          context,
                          title: "Verify".tr,
                          onPress: () async {
                            if (controller.otpController.value.text.length == 6) {
                              ShowToastDialog.showLoader("Verify OTP".tr);

                              PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: controller.verificationId.value, smsCode: controller.otpController.value.text);
                              await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
                                if (value.additionalUserInfo!.isNewUser) {
                                  print("----->new user");
                                  UserModel userModel = UserModel();
                                  userModel.id = value.user!.uid;
                                  userModel.countryCode = controller.countryCode.value;
                                  userModel.phoneNumber = controller.phoneNumber.value;
                                  userModel.loginType = Constant.phoneLoginType;

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
                                          // authController.saveUserNumberAndPassword(
                                          // phone, password, countryDialCode);
                                          await Get.find<EQAuthController>()
                                              .login(
                                                  "${userModel.countryCode}${userModel.phoneNumber}",
                                                  "${userModel.phoneNumber}")
                                              .then((value) {
                                            Get.find<EQAuthController>()
                                                .saveUserNumberAndPassword(
                                                    "${userModel.countryCode}${userModel.phoneNumber}",
                                                    "${userModel.phoneNumber}",
                                                    "${userModel.countryCode}");
                                          });

                                          Get.offAll(DashBoardScreen());
                                        } else {
                                          await FirebaseAuth.instance.signOut();
                                          ShowToastDialog.showToast("This user is disable please contact administrator".tr);
                                        }
                                      }
                                    } else {
                                      UserModel userModel = UserModel();
                                      userModel.id = value.user!.uid;
                                      userModel.countryCode = controller.countryCode.value;
                                      userModel.phoneNumber = controller.phoneNumber.value;
                                      userModel.loginType = Constant.phoneLoginType;

                                      Get.to(const InformationScreen(), arguments: {
                                        "userModel": userModel,
                                      });
                                    }
                                  });
                                }
                              }).catchError((error) {
                                ShowToastDialog.closeLoader();
                                ShowToastDialog.showToast("Code is Invalid".tr);
                              });
                            } else {
                              ShowToastDialog.showToast("Please Enter Valid OTP".tr);
                            }

                            // print(controller.countryCode.value);
                            // print(controller.phoneNumberController.value.text);
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
