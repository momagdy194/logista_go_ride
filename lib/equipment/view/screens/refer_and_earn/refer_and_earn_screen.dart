import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:share_plus/share_plus.dart';
import 'package:customer/equipment/controller/auth_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/controller/user_controller.dart';
import 'package:customer/equipment/helper/price_converter.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/images.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/custom_app_bar.dart';
import 'package:customer/equipment/view/base/custom_snackbar.dart';
import 'package:customer/equipment/view/base/footer_view.dart';
import 'package:customer/equipment/view/base/menu_drawer.dart';
import 'package:customer/equipment/view/base/not_logged_in_screen.dart';
import 'package:customer/equipment/view/screens/refer_and_earn/widget/bottom_sheet_view.dart';
import 'package:flutter_share_me/flutter_share_me.dart';

enum ShareType {
  facebook,
  messenger,
  twitter,
  whatsapp,
}
class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({Key? key}) : super(key: key);

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {

  @override
  void initState() {
    super.initState();

    initCall();
  }

  void initCall(){

    if(Get.find<EQAuthController>().isLoggedIn() && Get.find<EQUserController>().userInfoModel == null) {
      Get.find<EQUserController>().getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Get.find<EQAuthController>().isLoggedIn();
    return Scaffold(
      endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
      appBar: CustomAppBar(title: 'refer_and_earn'.tr),
      body: ExpandableBottomSheet(
        background: isLoggedIn ? SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeLarge),
          child: FooterView(
            child: Center(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: GetBuilder<EQUserController>(builder: (userController) {
                    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [

                      Image.asset(
                        Images.referImage, width: 500,
                        height: ResponsiveHelper.isDesktop(context) ? 250 : 150, fit: BoxFit.contain,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      Text('earn_money_on_every_referral'.tr, style: robotoRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall)),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      Text(
                          '${'one_referral'.tr}= ${PriceConverter.convertPrice(Get.find<EQSplashControllerEquip>().configModel != null
                              ? Get.find<EQSplashControllerEquip>().configModel!.refEarningExchangeRate!.toDouble() : 0.0)}',
                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault), textDirection: TextDirection.ltr,
                      ),
                      const SizedBox(height: 40),

                      Text('invite_friends_and_business'.tr , style: robotoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge), textAlign: TextAlign.center),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Text('copy_your_code_share_it_with_your_friends'.tr , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      Text('your_personal_code'.tr , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor), textAlign: TextAlign.center),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      DottedBorder(
                        color: Theme.of(context).primaryColor,
                        strokeWidth: 1,
                        strokeCap: StrokeCap.butt,
                        dashPattern: const [8, 5],
                        padding:   EdgeInsets.all(0),
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(50),
                        child: SizedBox(
                          height: 50,
                          child: (userController.userInfoModel != null) ? Row(children: [
                            Expanded(
                              child: Padding(
                                padding:   EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                                child: Text(
                                  userController.userInfoModel != null ? userController.userInfoModel!.refCode ?? '' : '',
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if(userController.userInfoModel!.refCode!.isNotEmpty){
                                  Clipboard.setData(ClipboardData(text: '${userController.userInfoModel != null ? userController.userInfoModel!.refCode : ''}'));
                                  showCustomSnackBar('referral_code_copied'.tr, isError: false);
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(50)),
                                padding:   EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                                margin:   EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                child: Text('copy'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeDefault)),
                              ),
                            ),
                          ]) : const CircularProgressIndicator(),
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Wrap(children: [
                        // InkWell(
                        //   onTap: () => onButtonTap(ShareType.messenger, userController.userInfoModel!.refCode!),
                        //     child: Image.asset(Images.messengerIcon, height: 40, width: 40),
                        // ),
                        // const SizedBox(width: Dimensions.paddingSizeSmall),
                        //
                        // InkWell(
                        //   onTap: () => onButtonTap(ShareType.whatsapp, userController.userInfoModel!.refCode!),
                        //     child: Image.asset(Images.whatsappIcon, height: 40, width: 40),
                        // ),
                        // const SizedBox(width: Dimensions.paddingSizeSmall),

                        InkWell(
                          onTap: () => Share.share('${'this_is_my_refer_code'.tr}: ${userController.userInfoModel!.refCode}'),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).cardColor,
                              boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.2), blurRadius: 5)],
                            ),
                            padding:   EdgeInsets.all(7),
                            child: const Icon(Icons.share),
                          ),
                        )
                      ]),

                      ResponsiveHelper.isDesktop(context) ? const Padding(
                        padding: EdgeInsets.only(top: Dimensions.paddingSizeExtraLarge),
                        child: BottomSheetView(),
                      ) : const SizedBox(),

                    ]);
                  }
                ),
              ),
            ),
          ),
        ) : NotLoggedInScreen(callBack: (value){
          initCall();
          setState(() {});
        }),

        persistentContentHeight: ResponsiveHelper.isDesktop(context) ? 0 : 60,
        expandableContent: ResponsiveHelper.isDesktop(context) || !isLoggedIn ? const SizedBox() : const BottomSheetView(),

      ),
    );
  }


  Future<void> onButtonTap(ShareType share, String msg) async {
    String url = 'https://pub.dev/packages/flutter_share_me';

    String? response;
    final FlutterShareMe flutterShareMe = FlutterShareMe();
    switch (share) {
      case ShareType.facebook:
        response = await flutterShareMe.shareToFacebook(url: url, msg: msg);
        break;
      case ShareType.messenger:
        response = await flutterShareMe.shareToMessenger(url: url, msg: msg);
        break;
      case ShareType.twitter:
        response = await flutterShareMe.shareToTwitter(url: url, msg: msg);
        break;
      case ShareType.whatsapp:
        response = await flutterShareMe.shareToWhatsApp(msg: msg);
        break;

    }
    debugPrint(response);
  }
}
