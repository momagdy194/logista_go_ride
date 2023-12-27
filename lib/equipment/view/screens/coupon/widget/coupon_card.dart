import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/equipment/controller/coupon_controller.dart';
import 'package:customer/equipment/controller/localization_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/controller/theme_controller.dart';
import 'package:customer/equipment/helper/date_converter.dart';
import 'package:customer/equipment/helper/price_converter.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/images.dart';
import 'package:customer/equipment/util/styles.dart';

class CouponCard extends StatelessWidget {
  final EQCouponController couponController;
  final int index;
  const CouponCard({Key? key, required this.couponController, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(children: [

      ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        child: Transform.rotate(
          angle: Get.find<EQLocalizationController>().isLtr ? 0 : pi,
          child: Image.asset(
            Get.find<EQThemeController>().darkTheme ? Images.couponBgDark : Images.couponBgLight,
            height: ResponsiveHelper.isMobilePhone() ? 120 : 140, width: size.width,
            fit: BoxFit.cover,
          ),
        ),
      ),

      Container(
        height: ResponsiveHelper.isMobilePhone() ? 110 : 140,
        alignment: Alignment.center,
        child: Row(children: [

          SizedBox(
            width: ResponsiveHelper.isDesktop(context) ? 150 : size.width * 0.3,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(
                couponController.couponList![index].discountType == 'percent' ? Images.percentCouponOffer : couponController.couponList![index].couponType
                    == 'free_delivery' ? Images.freeDelivery : Images.money,
                height: 25, width: 25,
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Text(
                '${couponController.couponList![index].discount}${couponController.couponList![index].discountType == 'percent' ? '%'
                    : Get.find<EQSplashControllerEquip>().configModel!.currencySymbol} ${'off'.tr}',
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              couponController.couponList![index].store == null ?  Flexible(child: Text(
                couponController.couponList![index].couponType == 'store_wise' ?
                '${'on'.tr} ${couponController.couponList![index].data}' : 'on_all_store'.tr,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              )) : Flexible(child: Text(
                couponController.couponList![index].couponType == 'default' ?
                '${couponController.couponList![index].store!.name}' : '',
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              )),
            ]),
          ),

          const SizedBox(width: 40),

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

              Text(
                '${couponController.couponList![index].title}',
                style: robotoRegular,
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Text(
                '${DateConverter.stringToReadableString(couponController.couponList![index].startDate!)} ${'to'.tr} ${DateConverter.stringToReadableString(couponController.couponList![index].expireDate!)}',
                style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),

              Row(children: [
                Text(
                  '*${'min_purchase'.tr} ',
                  style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(
                  PriceConverter.convertPrice(couponController.couponList![index].minPurchase),
                  style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                  maxLines: 1, overflow: TextOverflow.ellipsis, textDirection: TextDirection.ltr,
                ),
              ]),

            ]),
          ),

        ]),
      ),

    ]);
  }
}
