import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/data/model/response/order_model.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/custom_image.dart';
import 'package:customer/equipment/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryManWidget extends StatelessWidget {
  final DeliveryMan? deliveryMan;
  const DeliveryManWidget({Key? key, required this.deliveryMan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:   EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        boxShadow: [BoxShadow(
          color: Colors.grey[Get.isDarkMode ? 700 : 300]!,
          blurRadius: 5, spreadRadius: 1,
        )],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('delivery_man'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
        ListTile(
          leading: ClipOval(
            child: CustomImage(
              image: '${Get.find<EQSplashControllerEquip>().configModel!.baseUrls!.deliveryManImageUrl}/${deliveryMan!.image}',
              height: 40, width: 40, fit: BoxFit.cover,
            ),
          ),
          title: Text(
            '${deliveryMan!.fName} ${deliveryMan!.lName}',
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
          ),
          subtitle: RatingBar(rating: deliveryMan!.avgRating, size: 15, ratingCount: deliveryMan!.ratingCount ?? 0),
        ),
      ]),
    );
  }
}
