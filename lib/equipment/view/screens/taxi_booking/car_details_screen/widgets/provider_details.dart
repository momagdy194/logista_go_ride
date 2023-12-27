import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/equipment/controller/theme_controller.dart';
import 'package:customer/equipment/data/model/response/vehicle_model.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';

class ProviderDetails extends StatelessWidget {
  final Vehicles vehicle;
  const ProviderDetails({Key? key, required this.vehicle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        boxShadow: [BoxShadow(color: Colors.grey[Get.find<EQThemeController>().darkTheme ? 800 : 300]!, blurRadius: 5, spreadRadius: 1,)],
      ),
      child: Padding(
        padding:   EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('provider_details'.tr,style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            _providerDetailsItem("name".tr, vehicle.provider!.name!),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            _providerDetailsItem("contact".tr, vehicle.provider!.phone!),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            _providerDetailsItem("email".tr, vehicle.provider!.email!),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            _providerDetailsItem("address".tr, vehicle.provider!.address!),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            _providerDetailsItem("completed_trip".tr, vehicle.provider!.completedTrip.toString()),
          ],
        ),
      ),
    );
  }

  Widget _providerDetailsItem(String title,String subTitle,){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
        Text(subTitle,style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
      ],
    );

  }

}
