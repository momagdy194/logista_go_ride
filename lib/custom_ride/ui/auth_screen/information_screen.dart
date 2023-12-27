import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:customer/custom_ride/constant/constant.dart';
import 'package:customer/custom_ride/constant/show_toast_dialog.dart';
import 'package:customer/custom_ride/controller/information_controller.dart';
import 'package:customer/custom_ride/model/referral_model.dart';
import 'package:customer/custom_ride/model/user_model.dart';
import 'package:customer/custom_ride/themes/app_colors.dart';
import 'package:customer/custom_ride/themes/button_them.dart';
import 'package:customer/custom_ride/themes/responsive.dart';
import 'package:customer/custom_ride/themes/text_field_them.dart';
import 'package:customer/custom_ride/ui/dashboard_screen.dart';
import 'package:customer/custom_ride/utils/DarkThemeProvider.dart';
import 'package:customer/custom_ride/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../equipment/controller/auth_controller.dart';
import '../../../equipment/data/model/body/signup_body.dart';
import '../../controller/information_controller.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<InformationController>(
        init: InformationController(),
        builder: (controller) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/images/login_image.png", width: Responsive.width(100, context)),
                  Padding(
                    padding:   EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(top: 10),
                          child: Text("Sign up".tr, style: GoogleFonts.cairo(fontWeight: FontWeight.w600, fontSize: 18)),
                        ),
                        Padding(
                          padding:   EdgeInsets.only(top: 4),
                          child: Text("Create your account to start using Logista".tr, style: GoogleFonts.cairo(fontWeight: FontWeight.w400)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFieldThem.buildTextFiled(context, hintText: 'Full name'.tr, controller: controller.fullNameController.value),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            validator: (value) => value != null && value.isNotEmpty ? null : 'Required',
                            keyboardType: TextInputType.number,
                            textCapitalization: TextCapitalization.sentences,
                            controller: controller.phoneNumberController.value,
                            textAlign: TextAlign.start,
                            enabled: controller.loginType.value == Constant.phoneLoginType ? false : true,
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
                          height: 10,
                        ),
                        TextFieldThem.buildTextFiled(context,
                            hintText: 'Email'.tr, controller: controller.emailController.value, enable: controller.loginType.value == Constant.googleLoginType ? false : true),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldThem.buildTextFiled(context,
                            hintText: 'Coupon Code (Optional)'.tr, controller: controller.referralCodeController.value, enable: controller.loginType.value == Constant.googleLoginType ? false : true),
                        const SizedBox(
                          height: 60,
                        ),
                        ButtonThem.buildButton(
                          context,
                          title: "Create account".tr,
                          onPress: () async {
                            if (controller.fullNameController.value.text.isEmpty) {
                              ShowToastDialog.showToast("Please enter full name".tr);
                            } else if (controller.emailController.value.text.isEmpty) {
                              ShowToastDialog.showToast("Please enter email".tr);
                            } else if (controller.phoneNumberController.value.text.isEmpty) {
                              ShowToastDialog.showToast("Please enter phone".tr);
                            } else if (Constant.validateEmail(controller.emailController.value.text) == false) {
                              ShowToastDialog.showToast("Please enter valid email".tr);
                            } else {
                              if (controller.referralCodeController.value.text.isNotEmpty) {

                                FireStoreUtils.checkReferralCodeValidOrNot(controller.referralCodeController.value.text).then((value) async {
                                  if (value == true) {
                                    ShowToastDialog.showLoader("Please wait".tr);
                                    UserModel userModel = controller.userModel.value;
                                    userModel.fullName = controller.fullNameController.value.text;
                                    userModel.email = controller.emailController.value.text;
                                    userModel.countryCode = controller.countryCode.value;
                                    userModel.phoneNumber = controller.phoneNumberController.value.text;
                                    userModel.isActive = true;
                                    userModel.createdAt = Timestamp.now();
                                    await Get.find<EQAuthController>().registration(SignUpBody(email:"${userModel.email}",password:userModel.phoneNumber,fName: userModel.fullName,lName: "." ,phone:"${userModel.countryCode}${userModel.phoneNumber}"  )).then((value) {
                                      Get.find<EQAuthController>()
                                          .saveUserNumberAndPassword(
                                          "${userModel.countryCode}${userModel.phoneNumber}",
                                          "${userModel.phoneNumber}",
                                          "${userModel.countryCode}");
                                    });

                                    await FireStoreUtils.getReferralUserByCode(controller.referralCodeController.value.text).then((value) async {
                                      if (value != null) {
                                        ReferralModel ownReferralModel = ReferralModel(id: FireStoreUtils.getCurrentUid(), referralBy: value.id, referralCode: Constant.getReferralCode());
                                        await FireStoreUtils.referralAdd(ownReferralModel);
                                      } else {
                                        ReferralModel referralModel = ReferralModel(id: FireStoreUtils.getCurrentUid(), referralBy: "", referralCode: Constant.getReferralCode());
                                        await FireStoreUtils.referralAdd(referralModel);
                                      }
                                    });

                                    await FireStoreUtils.updateUser(userModel).then((value) {
                                      ShowToastDialog.closeLoader();
                                      print("------>$value");
                                      if (value == true) {
                                        Get.offAll(  DashBoardScreen());
                                      }
                                    });
                                  } else {
                                    ShowToastDialog.showToast("Referral code Invalid".tr);
                                  }
                                });
                              } else {
                                ShowToastDialog.showLoader("Please wait".tr);
                                UserModel userModel = controller.userModel.value;
                                userModel.fullName = controller.fullNameController.value.text;
                                userModel.email = controller.emailController.value.text;
                                userModel.countryCode = controller.countryCode.value;
                                userModel.phoneNumber = controller.phoneNumberController.value.text;
                                userModel.isActive = true;
                                userModel.createdAt = Timestamp.now();
                                 ReferralModel referralModel = ReferralModel(id: FireStoreUtils.getCurrentUid(), referralBy: "", referralCode: Constant.getReferralCode());


                                await Get.find<EQAuthController>().registration(SignUpBody(email:"${userModel.email}",password:"${userModel.phoneNumber}",fName: userModel.fullName,lName: "."  ,phone:"${userModel.countryCode}${userModel.phoneNumber}"  ));
                                await FireStoreUtils.referralAdd(referralModel);

                                await FireStoreUtils.updateUser(userModel).then((value) {
                                  ShowToastDialog.closeLoader();
                                  print("------>$value");
                                  if (value == true) {
                                    Get.offAll( DashBoardScreen());
                                  }
                                });
                              }
                            }
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
