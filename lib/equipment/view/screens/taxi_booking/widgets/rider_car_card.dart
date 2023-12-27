import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/controller/theme_controller.dart';
import 'package:customer/equipment/data/model/body/user_information_body.dart';
import 'package:customer/equipment/data/model/response/vehicle_model.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/images.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/custom_image.dart';
import 'package:customer/equipment/view/base/ripple_button.dart';

class RiderCarCard extends StatelessWidget {
  final Vehicles vehicle;
  final UserInformationBody filterBody;
  const RiderCarCard({Key? key, required this.vehicle, required this.filterBody}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:   EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: [BoxShadow(color: Colors.grey[Get.find<EQThemeController>().darkTheme ? 800 : 300]!, blurRadius: 5, spreadRadius: 1,)],
            ),
            margin:   EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            padding:   EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                    child: CustomImage(
                        image: '${Get.find<EQSplashControllerEquip>().configModel!.baseUrls!.vehicleImageUrl}/${vehicle.carImages!.isNotEmpty ? vehicle.carImages![0] : ''}',
                      height: 130,width: Get.width),
                ),
                Padding(
                  padding:   EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      Text("${vehicle.name}",style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                      const SizedBox(height: 8,),
                      Row(
                        children: [
                          Image.asset(Images.starFill,height: 10,width: 10,),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                          Text('${vehicle.avgRating},',style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                          ),),
                          Text(
                            "(${vehicle.ratingCount} ${'review'.tr})",
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5),
                            ),
                          )
                        ]),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                carFeatureItem(Images.riderSeat, '${vehicle.seatingCapacity} ${'seat'.tr}'),
                                const SizedBox(width: Dimensions.paddingSizeLarge),
                                carFeatureItem(Images.acIcon, vehicle.airCondition == 'yes' ? 'ac'.tr : 'non_ac'.tr),
                                const SizedBox(width: Dimensions.paddingSizeLarge,),
                                carFeatureItem(Images.riderKm, '${vehicle.engineCapacity}km/h'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8,),

                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: '${Get.find<EQSplashControllerEquip>().configModel!.currencySymbol}',
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                TextSpan(
                                    text: double.parse(vehicle.minFare.toString()).toStringAsFixed(Get.find<EQSplashControllerEquip>().configModel!.digitAfterDecimalPoint!),
                                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                                TextSpan(
                                    text: '/hr',
                                    style: robotoBold.copyWith(
                                        color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5),
                                        fontSize: Dimensions.fontSizeSmall)),
                              ],
                            ),
                          ),

                        ],
                      ),


                    ],
                  ),
                )
              ],
            ),
          ),

          Positioned.fill(child: Padding(
            padding:   EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: RippleButton(
              onTap: () => Get.toNamed(RouteHelper.getCarDetailsScreen(vehicle, filterBody)),
              radius: Dimensions.radiusSmall,
            ),
          )),

        ],
      ),
    );
  }

  Widget carFeatureItem(String imagePath,String title){
    return Row(
      children: [
        Image.asset(imagePath,height: 13,),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
        Text(title),
      ],
    );
  }
}
