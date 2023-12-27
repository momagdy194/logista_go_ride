
import 'package:customer/equipment/controller/auth_controller.dart';
import 'package:customer/equipment/controller/coupon_controller.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/view/base/custom_app_bar.dart';
import 'package:customer/equipment/view/base/custom_snackbar.dart';
import 'package:customer/equipment/view/base/footer_view.dart';
import 'package:customer/equipment/view/base/menu_drawer.dart';
import 'package:customer/equipment/view/base/no_data_screen.dart';
import 'package:customer/equipment/view/base/not_logged_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:customer/equipment/view/screens/coupon/widget/coupon_card.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({Key? key}) : super(key: key);

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {

  @override
  void initState() {
    super.initState();

    initCall();
  }

  void initCall(){
    if(Get.find<EQAuthController>().isLoggedIn()) {
      Get.find<EQCouponController>().getCouponList();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Get.find<EQAuthController>().isLoggedIn();
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: CustomAppBar(title: 'coupon'.tr),
      endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
      body: isLoggedIn ? GetBuilder<EQCouponController>(builder: (couponController) {
        return couponController.couponList != null ? couponController.couponList!.isNotEmpty ? RefreshIndicator(
          onRefresh: () async {
            await couponController.getCouponList();
          },
          child: Scrollbar(child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(child: FooterView(
              child: SizedBox(width: Dimensions.webMaxWidth, child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
                  mainAxisSpacing: Dimensions.paddingSizeSmall, crossAxisSpacing: Dimensions.paddingSizeSmall,
                  childAspectRatio: ResponsiveHelper.isMobile(context) ? 3 : 3,
                ),
                itemCount: couponController.couponList!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:   EdgeInsets.all(Dimensions.paddingSizeLarge),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: couponController.couponList![index].code!));
                      showCustomSnackBar('coupon_code_copied'.tr, isError: false);
                    },
                    child: CouponCard(couponController: couponController, index: index),
                  );
                },
              )),
            )),
          )),
        ) : NoDataScreen(text: 'no_coupon_found'.tr, showFooter: true) : const Center(child: CircularProgressIndicator());
      }) :  NotLoggedInScreen(callBack: (bool value)  {
        initCall();
        setState(() {});
      }),
    );
  }
}