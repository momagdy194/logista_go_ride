import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/images.dart';
import 'package:customer/equipment/view/base/custom_app_bar.dart';
import 'package:customer/equipment/view/base/custom_snackbar.dart';
import 'package:customer/equipment/view/base/footer_view.dart';
import 'package:customer/equipment/view/base/menu_drawer.dart';
import 'package:customer/equipment/view/screens/support/widget/support_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'help_support'.tr),
      endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
      body: Scrollbar(child: SingleChildScrollView(
        padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero :   EdgeInsets.all(Dimensions.paddingSizeSmall),
        physics: const BouncingScrollPhysics(),
        child: Center(child: FooterView(
          child: SizedBox(width: Dimensions.webMaxWidth, child: Column(children: [
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Image.asset(Images.supportImage, height: 120),
            const SizedBox(height: 30),

            Image.asset(Images.logo, width: 200),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            /*Text(AppConstants.APP_NAME, style: robotoBold.copyWith(
              fontSize: 20, color: Theme.of(context).primaryColor,
            )),*/
            const SizedBox(height: 30),

            SupportButton(
              icon: Icons.location_on, title: 'address'.tr, color: Colors.blue,
              info: Get.find<EQSplashControllerEquip>().configModel!.address,
              onTap: () {},
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            SupportButton(
              icon: Icons.call, title: 'call'.tr, color: Colors.red,
              info: Get.find<EQSplashControllerEquip>().configModel!.phone,
              onTap: () async {
                if(await canLaunchUrlString('tel:${Get.find<EQSplashControllerEquip>().configModel!.phone}')) {
                  launchUrlString('tel:${Get.find<EQSplashControllerEquip>().configModel!.phone}');
                }else {
                  showCustomSnackBar('${'can_not_launch'.tr} ${Get.find<EQSplashControllerEquip>().configModel!.phone}');
                }
              },
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            SupportButton(
              icon: Icons.mail_outline, title: 'email_us'.tr, color: Colors.green,
              info: Get.find<EQSplashControllerEquip>().configModel!.email,
              onTap: () {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: Get.find<EQSplashControllerEquip>().configModel!.email,
                );
                launchUrlString(emailLaunchUri.toString());
              },
            ),

          ])),
        )),
      )),
    );
  }
}
