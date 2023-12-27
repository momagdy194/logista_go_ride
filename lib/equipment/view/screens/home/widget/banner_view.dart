import 'package:carousel_slider/carousel_slider.dart';
import 'package:customer/equipment/controller/banner_controller.dart';
import 'package:customer/equipment/controller/item_controller.dart';
import 'package:customer/equipment/controller/location_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/data/model/response/basic_campaign_model.dart';
import 'package:customer/equipment/data/model/response/item_model.dart';
import 'package:customer/equipment/data/model/response/module_model.dart';
import 'package:customer/equipment/data/model/response/store_model.dart';
import 'package:customer/equipment/data/model/response/zone_response_model.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/view/base/custom_image.dart';
import 'package:customer/equipment/view/base/custom_snackbar.dart';
import 'package:customer/equipment/view/screens/store/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BannerView extends StatelessWidget {
  final bool isFeatured;
  const BannerView({Key? key, required this.isFeatured}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EQBannerController>(builder: (bannerController) {
      List<String?>? bannerList = isFeatured
          ? bannerController.featuredBannerList
          : bannerController.bannerImageList;
      List<dynamic>? bannerDataList = isFeatured
          ? bannerController.featuredBannerDataList
          : bannerController.bannerDataList;

      return (bannerList != null && bannerList.isEmpty)
          ? const SizedBox()
          : Container(
              width: MediaQuery.of(context).size.width,
              height: GetPlatform.isDesktop ? 500 : 160,
              padding:   EdgeInsets.only(top: Dimensions.paddingSizeSmall),
              child: bannerList != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                              autoPlay: true,
                              enlargeCenterPage: true,
                              disableCenter: true,
                              viewportFraction: 0.96,
                              autoPlayInterval: const Duration(seconds: 7),
                              onPageChanged: (index, reason) {
                                bannerController.setCurrentIndex(index, true);
                              },
                            ),
                            itemCount:
                                bannerList.isEmpty ? 1 : bannerList.length,
                            itemBuilder: (context, index, _) {
                              String? baseUrl =
                                  bannerDataList![index] is BasicCampaignModel
                                      ? Get.find<EQSplashControllerEquip>()
                                          .configModel!
                                          .baseUrls!
                                          .campaignImageUrl
                                      : Get.find<EQSplashControllerEquip>()
                                          .configModel!
                                          .baseUrls!
                                          .bannerImageUrl;
                              return InkWell(
                                onTap: () async {
                                  if (bannerDataList[index] is Item) {
                                    Item? item = bannerDataList[index];
                                    Get.find<EQItemController>()
                                        .navigateToItemPage(item, context);
                                  } else if (bannerDataList[index] is Store) {
                                    Store? store = bannerDataList[index];
                                    if (isFeatured &&
                                        (Get.find<EQLocationController>()
                                                    .getUserAddress()!
                                                    .zoneData !=
                                                null &&
                                            Get.find<EQLocationController>()
                                                .getUserAddress()!
                                                .zoneData!
                                                .isNotEmpty)) {
                                      for (ModuleModel module
                                          in Get.find<EQSplashControllerEquip>()
                                              .moduleList!) {
                                        if (module.id == store!.moduleId) {
                                          Get.find<EQSplashControllerEquip>()
                                              .setModule(module);
                                          break;
                                        }
                                      }
                                      ZoneData zoneData =
                                          Get.find<EQLocationController>()
                                              .getUserAddress()!
                                              .zoneData!
                                              .firstWhere((data) =>
                                                  data.id == store!.zoneId);

                                      Modules module = zoneData.modules!
                                          .firstWhere((module) =>
                                              module.id == store!.moduleId);
                                      Get.find<EQSplashControllerEquip>().setModule(
                                          ModuleModel(
                                              id: module.id,
                                              moduleName: module.moduleName,
                                              moduleType: module.moduleType,
                                              themeId: module.themeId,
                                              storesCount: module.storesCount));
                                    }
                                    Get.toNamed(
                                      RouteHelper.getStoreRoute(store!.id,
                                          isFeatured ? 'module' : 'banner'),
                                      arguments: StoreScreen(
                                          store: store, fromModule: isFeatured),
                                    );
                                  } else if (bannerDataList[index]
                                      is BasicCampaignModel) {
                                    BasicCampaignModel campaign =
                                        bannerDataList[index];
                                    Get.toNamed(
                                        RouteHelper.getBasicCampaignRoute(
                                            campaign));
                                  } else {
                                    String url = bannerDataList[index];
                                    if (await canLaunchUrlString(url)) {
                                      await launchUrlString(url,
                                          mode: LaunchMode.externalApplication);
                                    } else {
                                      showCustomSnackBar(
                                          'unable_to_found_url'.tr);
                                    }
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusDefault),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[
                                              Get.isDarkMode ? 800 : 200]!,
                                          spreadRadius: 1,
                                          blurRadius: 5)
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusDefault),
                                    child: GetBuilder<EQSplashControllerEquip>(
                                        builder: (splashController) {
                                      return CustomImage(
                                        image: '$baseUrl/${bannerList[index]}',
                                        fit: BoxFit.fill,
                                      );
                                    }),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: bannerList.map((bnr) {
                        //     int index = bannerList.indexOf(bnr);
                        //     return TabPageSelectorIndicator(
                        //       backgroundColor: index == bannerController.currentIndex ? Theme.of(context).primaryColor
                        //           : Theme.of(context).primaryColor.withOpacity(0.5),
                        //       borderColor: Theme.of(context).colorScheme.background,
                        //       size: index == bannerController.currentIndex ? 10 : 7,
                        //     );
                        //   }).toList(),
                        // ),
                      ],
                    )
                  : Shimmer(
                      duration: const Duration(seconds: 2),
                      enabled: bannerList == null,
                      child: Container(
                          margin:   EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                            color: Colors.grey[300],
                          )),
                    ),
            );
    });
  }
}
