import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:customer/equipment/controller/auth_controller.dart';
import 'package:customer/equipment/controller/localization_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/data/model/body/social_log_in_body.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/images.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/custom_app_bar.dart';
import 'package:customer/equipment/view/base/custom_button.dart';
import 'package:customer/equipment/view/base/custom_snackbar.dart';
import 'package:customer/equipment/view/base/custom_text_field.dart';
import 'package:customer/equipment/view/base/footer_view.dart';
import 'package:customer/equipment/view/base/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

class ForgetPassScreen extends StatefulWidget {
  final bool fromSocialLogin;
  final SocialLogInBody? socialLogInBody;
  const ForgetPassScreen({Key? key, required this.fromSocialLogin, required this.socialLogInBody}) : super(key: key);

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final TextEditingController _numberController = TextEditingController();
  String? _countryDialCode = CountryCode.fromCountryCode(Get.find<EQSplashControllerEquip>().configModel!.country!).dialCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.fromSocialLogin ? 'phone'.tr : 'forgot_password'.tr),
      endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
      body: SingleChildScrollView(
        child: Column(
mainAxisAlignment: MainAxisAlignment.start,
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

            Container(
              width: context.width > 700 ? 700 : context.width,
              padding: context.width > 700 ?   EdgeInsets.all(Dimensions.paddingSizeDefault) :   EdgeInsets.all(Dimensions.paddingSizeLarge),
              margin:   EdgeInsets.all(Dimensions.paddingSizeDefault),

              child: Column(children: [


                Padding(
                  padding:   EdgeInsets.all(30),
                  child: Text('please_enter_mobile'.tr, style: robotoRegular, textAlign: TextAlign.center),
                ),

                CustomTextField(
                  titleText: 'phone'.tr,
                  controller: _numberController,
                  inputType: TextInputType.phone,
                  inputAction: TextInputAction.done,
                  isPhone: true,
                  showTitle: ResponsiveHelper.isDesktop(context),
                  onCountryChanged: ( countryCode) {
                    _countryDialCode = countryCode.dialCode;
                  },
                  countryDialCode: _countryDialCode != null ? CountryCode.fromCountryCode(Get.find<EQSplashControllerEquip>().configModel!.country!).code
                      : Get.find<EQLocalizationController>().locale.countryCode,
                  onSubmit: (text) => GetPlatform.isWeb ? _forgetPass(_countryDialCode!) : null,
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                GetBuilder<EQAuthController>(builder: (authController) {
                  return CustomButton(
                    buttonText: 'next'.tr,
                    isLoading: authController.isLoading,
                    onPressed: () => _forgetPass(_countryDialCode!),
                  );
                }),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                RichText(text: TextSpan(children: [
                  TextSpan(
                    text: '${'if_you_have_any_queries_feel_free_to_contact_with_our'.tr} ',
                    style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                  ),
                  TextSpan(
                    text: 'help_and_support'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.toNamed(RouteHelper.getSupportRoute()),
                  ),
                ]), textAlign: TextAlign.center, maxLines: 3),

              ]),
            ),
          ],
        ),
      ),
    );
  }

  void _forgetPass(String countryCode) async {
    String phone = _numberController.text.trim();

    String numberWithCountryCode = countryCode+phone;
    bool isValid = GetPlatform.isAndroid ? false : true;
    if(GetPlatform.isAndroid) {
      try {
        PhoneNumber phoneNumber = await PhoneNumberUtil().parse(numberWithCountryCode);
        numberWithCountryCode = '+${phoneNumber.countryCode}${phoneNumber.nationalNumber}';
        isValid = true;
      } catch (_) {}
    }

    if (phone.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    }else if (!isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    }else {
      if(widget.fromSocialLogin) {
        widget.socialLogInBody!.phone = numberWithCountryCode;
        Get.find<EQAuthController>().registerWithSocialMedia(widget.socialLogInBody!);
      }else {
        Get.find<EQAuthController>().forgetPassword(numberWithCountryCode).then((status) async {
          if (status.isSuccess) {
            Get.toNamed(RouteHelper.getVerificationRoute(numberWithCountryCode, '', RouteHelper.forgotPassword, ''));
          }else {
            showCustomSnackBar(status.message);
          }
        });
      }
    }
  }
}
