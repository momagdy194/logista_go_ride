import 'dart:async';

import 'package:customer/equipment/controller/location_controller.dart';
import 'package:customer/equipment/controller/order_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/controller/theme_controller.dart';
import 'package:customer/equipment/data/model/response/zone_response_model.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/images.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/custom_button.dart';
import 'package:customer/equipment/view/base/footer_view.dart';
import 'package:customer/equipment/view/base/menu_drawer.dart';
import 'package:customer/equipment/view/base/web_menu_bar.dart';
import 'package:customer/equipment/view/screens/checkout/widget/payment_failed_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderSuccessfulScreen extends StatefulWidget {
  final String? orderID;
  const OrderSuccessfulScreen({Key? key, required this.orderID}) : super(key: key);

  @override
  State<OrderSuccessfulScreen> createState() => _OrderSuccessfulScreenState();
}

class _OrderSuccessfulScreenState extends State<OrderSuccessfulScreen> {

  bool? _isCashOnDeliveryActive = false;

  @override
  void initState() {
    super.initState();

    Get.find<EQOrderController>().trackOrder(widget.orderID.toString(), null, false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        await Get.offAllNamed(RouteHelper.getInitialRoute());
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
        endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
        body: GetBuilder<EQOrderController>(builder: (orderController){
          double total = 0;
          bool success = true;
          bool parcel = false;
          double? maximumCodOrderAmount;
          if(orderController.trackModel != null) {
            total = ((orderController.trackModel!.orderAmount! / 100) * Get.find<EQSplashControllerEquip>().configModel!.loyaltyPointItemPurchasePoint!);
            success = orderController.trackModel!.paymentStatus == 'paid' || orderController.trackModel!.paymentMethod == 'cash_on_delivery';
            parcel = orderController.trackModel!.paymentMethod == 'parcel';
            for(ZoneData zData in Get.find<EQLocationController>().getUserAddress()!.zoneData!) {
              for(Modules m in zData.modules!) {
                if(m.id == Get.find<EQSplashControllerEquip>().module!.id) {
                  maximumCodOrderAmount = m.pivot!.maximumCodOrderAmount;
                  break;
                }
              }
              if(zData.id ==  Get.find<EQLocationController>().getUserAddress()!.zoneId){
                _isCashOnDeliveryActive = zData.cashOnDelivery;
              }
            }

            if (!success && !Get.isDialogOpen! && orderController.trackModel!.orderStatus != 'canceled') {
              Future.delayed(const Duration(seconds: 1), () {
                Get.dialog(PaymentFailedDialog(orderID: widget.orderID, isCashOnDelivery: _isCashOnDeliveryActive, orderAmount: total, maxCodOrderAmount: maximumCodOrderAmount, orderType: parcel ? 'parcel' : 'delivery'), barrierDismissible: false);
              });
            }
          }

          return orderController.trackModel != null ? Center(
            child: SingleChildScrollView(
              child: FooterView(child: SizedBox(width: Dimensions.webMaxWidth, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                Image.asset(success ? Images.checked : Images.warning, width: 100, height: 100),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text(
                  success ? parcel ? 'you_placed_the_parcel_request_successfully'.tr
                      : 'you_placed_the_order_successfully'.tr : 'your_order_is_failed_to_place'.tr,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Padding(
                  padding:   EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                  child: Text(
                    success ? parcel ? 'your_parcel_request_is_placed_successfully'.tr
                        : 'your_order_is_placed_successfully'.tr : 'your_order_is_failed_to_place_because'.tr,
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                    textAlign: TextAlign.center,
                  ),
                ),

                ResponsiveHelper.isDesktop(context) && (success && Get.find<EQSplashControllerEquip>().configModel!.loyaltyPointStatus == 1 && total.floor() > 0 )  ? Column(children: [

                  Image.asset(Get.find<EQThemeController>().darkTheme ? Images.congratulationDark : Images.congratulationLight, width: 150, height: 150),

                  Text('congratulations'.tr , style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Padding(
                    padding:   EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                    child: Text(
                      '${'you_have_earned'.tr} ${total.floor().toString()} ${'points_it_will_add_to'.tr}',
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).disabledColor),
                      textAlign: TextAlign.center,
                    ),
                  ),

                ]) : const SizedBox.shrink() ,
                const SizedBox(height: 30),

                Padding(
                  padding:   EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: CustomButton(buttonText: 'back_to_home'.tr, onPressed: () => Get.offAllNamed(RouteHelper.getInitialRoute())),
                ),
              ]))),
            ),
          ) : const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
