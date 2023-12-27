import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:customer/equipment/controller/auth_controller.dart';
import 'package:customer/equipment/controller/localization_controller.dart';
import 'package:customer/equipment/controller/location_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/data/model/body/signup_body.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/images.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/custom_button.dart';
import 'package:customer/equipment/view/base/custom_snackbar.dart';
import 'package:customer/equipment/view/base/custom_text_field.dart';
import 'package:customer/equipment/view/base/menu_drawer.dart';
import 'package:customer/equipment/view/screens/auth/sign_in_screen.dart';
import 'package:customer/equipment/view/screens/auth/widget/condition_check_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';
import 'package:customer/equipment/view/screens/auth/widget/pass_view.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referCodeFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _referCodeController = TextEditingController();
  String? _countryDialCode;

  @override
  void initState() {
    super.initState();

    _countryDialCode = CountryCode.fromCountryCode(Get.find<EQSplashControllerEquip>().configModel!.country!).dialCode;
    if(Get.find<EQAuthController>().showPassView){
      Get.find<EQAuthController>().showHidePass(isUpdate: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ResponsiveHelper.isDesktop(context) ? Colors.transparent : Theme.of(context).cardColor,
      endDrawer: const MenuDrawer(), endDrawerEnableOpenDragGesture: false,
      body: SafeArea(child: Scrollbar(
        child: Center(
          child: Container(
           decoration: context.width > 700 ? BoxDecoration(
              color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              // boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, blurRadius: 5, spreadRadius: 1)],
            ) : null,
            child: GetBuilder<EQAuthController>(builder: (authController) {

              return SingleChildScrollView(
                child: Column(
                  children: [


                                                   Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(25),
                                        bottomLeft: Radius.circular(25)),
                                    child: Image.asset(
                                      Images.headerImage,
                                      height: context.height / 3,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(25),
                                        bottomLeft: Radius.circular(25)),
                                    child: Container(color: Colors.black.withOpacity(.5),
                                      height: context.height / 3,
                                    )
                                  ),
                                  Center(
                                      child:
                                          Image.asset(Images.logo, width: 150)),
                                ],
                              ),

                    Container(    width: context.width > 700 ? 700 : context.width,
                      padding: context.width > 700 ?   EdgeInsets.all(40) :   EdgeInsets.all(Dimensions.paddingSizeLarge),
                      margin: context.width > 700 ?   EdgeInsets.all(Dimensions.paddingSizeDefault) : null,

                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                        ResponsiveHelper.isDesktop(context) ? Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.clear),
                          ),
                        ) : const SizedBox(),


                         // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        // Center(child: Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge))),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('sign_up'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        Row(children: [
                          Expanded(
                            child: CustomTextField(
                              titleText: 'first_name'.tr,
                              hintText: 'ex_jhon'.tr,
                              controller: _firstNameController,
                              focusNode: _firstNameFocus,
                              nextFocus: _lastNameFocus,
                              inputType: TextInputType.name,
                              capitalization: TextCapitalization.words,
                              prefixIcon: Icons.person,
                              showTitle: ResponsiveHelper.isDesktop(context),
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Expanded(
                            child: CustomTextField(
                              titleText: 'last_name'.tr,
                              hintText: 'ex_doe'.tr,
                              controller: _lastNameController,
                              focusNode: _lastNameFocus,
                              nextFocus: _phoneFocus,
                              inputType: TextInputType.name,
                              capitalization: TextCapitalization.words,
                              prefixIcon: Icons.person,
                              showTitle: ResponsiveHelper.isDesktop(context),
                            ),
                          )
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        Row(children: [
                          ResponsiveHelper.isDesktop(context) ? Expanded(
                            child: CustomTextField(
                              titleText: 'email'.tr,
                              hintText: 'enter_email'.tr,
                              controller: _emailController,
                              focusNode: _emailFocus,
                              nextFocus: _passwordFocus,
                              inputType: TextInputType.emailAddress,
                              prefixImage: Images.mail,
                              showTitle: ResponsiveHelper.isDesktop(context),
                            ),
                          ) : const SizedBox(),
                          SizedBox(width: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0),

                          Expanded(
                            child: CustomTextField(
                              titleText: ResponsiveHelper.isDesktop(context) ? 'phone'.tr : 'enter_phone_number'.tr,
                              controller: _phoneController,
                              focusNode: _phoneFocus,
                              nextFocus: _emailFocus,
                              inputType: TextInputType.phone,
                              isPhone: true,
                              showTitle: ResponsiveHelper.isDesktop(context),
                              onCountryChanged: (  countryCode) {
                                _countryDialCode = countryCode.dialCode;
                              },
                              countryDialCode: _countryDialCode != null ? CountryCode.fromCountryCode(Get.find<EQSplashControllerEquip>().configModel!.country!).code
                                  : Get.find<EQLocalizationController>().locale.countryCode,
                            ),
                          ),

                        ]),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        !ResponsiveHelper.isDesktop(context) ? CustomTextField(
                          titleText: 'email'.tr,
                          hintText: 'enter_email'.tr,
                          controller: _emailController,
                          focusNode: _emailFocus,
                          nextFocus: _passwordFocus,
                          inputType: TextInputType.emailAddress,
                          prefixIcon: Icons.mail,
                        ) : const SizedBox(),
                        SizedBox(height: !ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0),

                        Row(children: [
                          Expanded(
                            child: Column(children: [
                              CustomTextField(
                                titleText: 'password'.tr,
                                hintText: '8_character'.tr,
                                controller: _passwordController,
                                focusNode: _passwordFocus,
                                nextFocus: _confirmPasswordFocus,
                                inputType: TextInputType.visiblePassword,
                                prefixIcon: Icons.lock,
                                isPassword: true,
                                showTitle: ResponsiveHelper.isDesktop(context),
                                onChanged: (value){
                                  if(value != null && value.isNotEmpty){
                                    if(!authController.showPassView){
                                      authController.showHidePass();
                                    }
                                    authController.validPassCheck(value);
                                  }else{
                                    if(authController.showPassView){
                                      authController.showHidePass();
                                    }
                                  }
                                },
                              ),

                              authController.showPassView ? const PassView() : const SizedBox(),
                            ]),
                          ),
                          SizedBox(width: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0),

                          ResponsiveHelper.isDesktop(context) ? Expanded(child: CustomTextField(
                            titleText: 'confirm_password'.tr,
                            hintText: '8_character'.tr,
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocus,
                            nextFocus: Get.find<EQSplashControllerEquip>().configModel!.refEarningStatus == 1 ? _referCodeFocus : null,
                            inputAction: Get.find<EQSplashControllerEquip>().configModel!.refEarningStatus == 1 ? TextInputAction.next : TextInputAction.done,
                            inputType: TextInputType.visiblePassword,
                            prefixImage: Images.lock,
                            isPassword: true,
                            showTitle: ResponsiveHelper.isDesktop(context),
                            onSubmit: (text) => (GetPlatform.isWeb) ? _register(authController, _countryDialCode!) : null,
                          )) : const SizedBox()

                        ]),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        !ResponsiveHelper.isDesktop(context) ? CustomTextField(
                          titleText: 'confirm_password'.tr,
                          hintText: '8_character'.tr,
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocus,
                          nextFocus: Get.find<EQSplashControllerEquip>().configModel!.refEarningStatus == 1 ? _referCodeFocus : null,
                          inputAction: Get.find<EQSplashControllerEquip>().configModel!.refEarningStatus == 1 ? TextInputAction.next : TextInputAction.done,
                          inputType: TextInputType.visiblePassword,
                          prefixIcon: Icons.lock,
                          isPassword: true,
                          onSubmit: (text) => (GetPlatform.isWeb) ? _register(authController, _countryDialCode!) : null,
                        ) : const SizedBox(),
                        SizedBox(height: !ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0),

                        (Get.find<EQSplashControllerEquip>().configModel!.refEarningStatus == 1 ) ? CustomTextField(
                          titleText: 'refer_code'.tr,
                          hintText: 'enter_refer_code'.tr,
                          controller: _referCodeController,
                          focusNode: _referCodeFocus,
                          inputAction: TextInputAction.done,
                          inputType: TextInputType.text,
                          capitalization: TextCapitalization.words,
                          prefixImage: Images.referCode,
                          prefixSize: 14,
                          showTitle: ResponsiveHelper.isDesktop(context),
                        ) : const SizedBox(),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        ConditionCheckBox(authController: authController, fromSignUp: true),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        CustomButton(
                          buttonText: 'sign_up'.tr,
                          isLoading: authController.isLoading,
                          onPressed: authController.acceptTerms ? () => _register(authController, _countryDialCode!) : null,
                        ),

                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text('already_have_account'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),

                          InkWell(
                            onTap: () {
                              if(ResponsiveHelper.isDesktop(context)){
                                Get.back();
                                Get.dialog(const SignInScreen(exitFromApp: false, backFromThis: false));
                              }else{
                                Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.signUp));
                              }
                            },
                            child: Padding(
                              padding:   EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                              child: Text('sign_in'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
                            ),
                          ),
                        ]),

                      ]),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      )),
    );
  }

  void _register(EQAuthController authController, String countryCode) async {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String number = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String referCode = _referCodeController.text.trim();

    String numberWithCountryCode = countryCode+number;
    bool isValid = GetPlatform.isAndroid ? false : true;
    if(GetPlatform.isAndroid) {
      try {
        PhoneNumber phoneNumber = await PhoneNumberUtil().parse(numberWithCountryCode);
        numberWithCountryCode = '+${phoneNumber.countryCode}${phoneNumber.nationalNumber}';
        isValid = true;
      } catch (_) {}
    }

    if (firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    }else if (lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    }else if (email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    }else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    }else if (number.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    }else if (!isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    }else if (password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    }else if (password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    }else if (password != confirmPassword) {
      showCustomSnackBar('confirm_password_does_not_matched'.tr);
    }else {
      SignUpBody signUpBody = SignUpBody(
        fName: firstName, lName: lastName, email: email, phone: numberWithCountryCode,
        password: password, refCode: referCode,
      );
      authController.registration(signUpBody).then((status) async {
        if (status.isSuccess) {
          if(Get.find<EQSplashControllerEquip>().configModel!.customerVerification!) {
            List<int> encoded = utf8.encode(password);
            String data = base64Encode(encoded);
            Get.toNamed(RouteHelper.getVerificationRoute(numberWithCountryCode, status.message, RouteHelper.signUp, data));
          }else {
            Get.find<EQLocationController>().navigateToLocationScreen(RouteHelper.signUp);
          }
        }else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
