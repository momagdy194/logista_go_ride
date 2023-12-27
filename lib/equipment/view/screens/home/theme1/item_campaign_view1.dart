import 'package:customer/equipment/controller/campaign_controller.dart';
import 'package:customer/equipment/controller/item_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/view/base/custom_image.dart';
import 'package:customer/equipment/view/base/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

class ItemCampaignView1 extends StatelessWidget {
  const ItemCampaignView1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EQCampaignController>(builder: (campaignController) {
      return (campaignController.itemCampaignList != null && campaignController.itemCampaignList!.isEmpty) ? const SizedBox() : Column(
        children: [
          Padding(
            padding:   EdgeInsets.fromLTRB(10, 15, 10, 10),
            child: TitleWidget(title: 'campaigns'.tr, onTap: () => Get.toNamed(RouteHelper.getItemCampaignRoute())),
          ),

          SizedBox(
            height: 150,
            child: campaignController.itemCampaignList != null ? ListView.builder(
              controller: ScrollController(),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding:   EdgeInsets.only(left: Dimensions.paddingSizeSmall),
              itemCount: campaignController.itemCampaignList!.length > 10 ? 10 : campaignController.itemCampaignList!.length,
              itemBuilder: (context, index){
                return Padding(
                  padding:   EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: 5),
                  child: InkWell(
                    onTap: () {
                      Get.find<EQItemController>().navigateToItemPage(campaignController.itemCampaignList![index], context, isCampaign: true);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: CustomImage(
                        image: '${Get.find<EQSplashControllerEquip>().configModel!.baseUrls!.campaignImageUrl}'
                            '/${campaignController.itemCampaignList![index].image}',
                        height: 150, width: 150, fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ) : ItemCampaignShimmer(campaignController: campaignController),
          ),
        ],
      );
    });
  }
}

class ItemCampaignShimmer extends StatelessWidget {
  final EQCampaignController campaignController;
  const ItemCampaignShimmer({Key? key, required this.campaignController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding:   EdgeInsets.only(left: Dimensions.paddingSizeSmall),
      itemCount: 10,
      itemBuilder: (context, index){
        return Padding(
          padding:   EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: 5),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: campaignController.itemCampaignList == null,
            child: Container(
              height: 150, width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                color: Colors.grey[300],
              ),
            ),
          ),
        );
      },
    );
  }
}

