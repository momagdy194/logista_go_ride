import 'package:customer/equipment/controller/item_controller.dart';
import 'package:customer/equipment/controller/localization_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/controller/theme_controller.dart';
import 'package:customer/equipment/data/model/response/item_model.dart';
import 'package:customer/equipment/helper/price_converter.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/images.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/corner_banner/banner.dart';
import 'package:customer/equipment/view/base/corner_banner/corner_discount_tag.dart';
import 'package:customer/equipment/view/base/custom_image.dart';
import 'package:customer/equipment/view/base/not_available_widget.dart';
import 'package:customer/equipment/view/base/organic_tag.dart';
import 'package:customer/equipment/view/base/rating_bar.dart';
import 'package:customer/equipment/view/base/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

import '../../../../helper/responsive_helper.dart';

class PopularItemView1 extends StatelessWidget {
  final bool isPopular;
  const PopularItemView1({Key? key, required this.isPopular}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool ltr = Get.find<EQLocalizationController>().isLtr;

    return GetBuilder<EQItemController>(builder: (itemController) {
      List<Item>? itemList = isPopular ? itemController.popularItemList : itemController.reviewedItemList;

      return (itemList != null && itemList.isEmpty) ? const SizedBox() : Column(
        children: [
          Padding(
            padding:   EdgeInsets.fromLTRB(10, 15, 10, 10),
            child: TitleWidget(
              title: Get.find<EQSplashControllerEquip>().module!.themeId == 2
                  ?'all_trip'.tr:  isPopular ? 'popular_items_nearby'.tr : 'best_reviewed_item'.tr,
              onTap: () => Get.toNamed(RouteHelper.getPopularItemRoute(isPopular)),
            ),
          ),

          if (itemList != null) GridView.builder(
            key: UniqueKey(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: Dimensions.paddingSizeLarge,
              mainAxisSpacing: Dimensions.paddingSizeLarge,
              childAspectRatio:    1.3,
              crossAxisCount: 2,
            ),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap:true,
            padding:   EdgeInsets.only(left: Dimensions.paddingSizeSmall),
            itemCount:  itemList.length,
             itemBuilder: (context, index){
              return InkWell(
                onTap: () {
                  Get.find<EQItemController>().navigateToItemPage(itemList[index], context);
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CustomImage(
                        image: '${Get.find<EQSplashControllerEquip>().configModel!.baseUrls!.itemImageUrl}'
                            '/${itemList[index].image}',
              fit: BoxFit.cover,
                      ),
                    ),
              Container(decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(10),

                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.5, 0.7 ],
                  colors: [
                    Colors.black.withOpacity(.1),

                    Colors.black.withOpacity(.3),
                    Colors.black.withOpacity(.6),

                  ],
                ),
              ) ),
                    Positioned(
                      bottom: 2,
                      right: 5,left: 5,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text(
                              itemList[index]!.name ?? '',
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge,color: Colors.white),
                              maxLines: 2, overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5,),
                            Container(
                              width: 180,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    RatingBar2(rating: itemList[index]!.avgRating, ratingCount: itemList[index]!.ratingCount,),
                                    const SizedBox(width: 5),
                                    Text(
                                      PriceConverter.convertPrice(itemController.getStartingPrice(itemList[index])),
                                      style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).colorScheme.error,
                                        decoration: TextDecoration.lineThrough,
                                      ), textDirection: TextDirection.ltr,
                                    )
                                  ]),
                            )
                            // Positioned(bottom: 0, right: 0, child:
                            // Container(
                            //   height: 25, width: 25,
                            //   decoration: BoxDecoration(
                            //       shape: BoxShape.circle,
                            //       color: Theme.of(context).primaryColor
                            //   ),
                            //   child: const Icon(Icons.add, size: 20, color: Colors.white),
                            // )),
                          ]),
                    ),

                    Positioned(
                      right: ltr ? 0 : null, left: ltr ? null : 0,
                      child: CornerDiscountTag(
                        bannerPosition: ltr ? CornerBannerPosition.topRight : CornerBannerPosition.topLeft,
                        elevation: 0,
                        discount: itemController.getDiscount(itemList[index]),
                        discountType: itemController.getDiscountType(itemList[index]),
                      ),

                    ),
                  ],
                ),
              );
            },
          ) else Container()
        ],
      );
    });
  }
}

class PopularItemShimmer extends StatelessWidget {
  final bool enabled;
  const PopularItemShimmer({Key? key, required this.enabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: UniqueKey(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: Dimensions.paddingSizeLarge,
        mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0.01,
        childAspectRatio: ResponsiveHelper.isDesktop(context) ? 4 :  2 ,
        crossAxisCount: 2,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding:   EdgeInsets.only(left: Dimensions.paddingSizeSmall),
      itemCount: 10,
      itemBuilder: (context, index){
         return Padding(
          padding:   EdgeInsets.fromLTRB(2, 2, Dimensions.paddingSizeSmall, 2),
          child: Container(
            height: 90, width: 250,
            padding:   EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: [BoxShadow(
                color: Colors.grey[Get.find<EQThemeController>().darkTheme ? 700 : 300]!,
                blurRadius: 5, spreadRadius: 1,
              )],
            ),
            child: Shimmer(
              duration: const Duration(seconds: 1),
              interval: const Duration(seconds: 1),
              enabled: enabled,
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                Container(
                  height: 80, width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Colors.grey[300],
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding:   EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(height: 15, width: 100, color: Colors.grey[300]),
                      const SizedBox(height: 5),

                      Container(height: 10, width: 130, color: Colors.grey[300]),
                      const SizedBox(height: 5),

                      const RatingBar(rating: 0, size: 12, ratingCount: 0),

                      Row(children: [
                        Expanded(
                          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                            Container(height: 10, width: 40, color: Colors.grey[300]),
                            Container(height: 15, width: 40, color: Colors.grey[300]),
                          ]),
                        ),
                        Container(
                          height: 25, width: 25,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor
                          ),
                          child: const Icon(Icons.add, size: 20, color: Colors.white),
                        ),
                      ]),
                    ]),
                  ),
                ),

              ]),
            ),
          ),
        );
      },
    );
  }
}

