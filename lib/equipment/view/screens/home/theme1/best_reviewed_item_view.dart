import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:customer/equipment/controller/item_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/controller/theme_controller.dart';
import 'package:customer/equipment/data/model/response/item_model.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/custom_image.dart';
import 'package:customer/equipment/view/base/title_widget.dart';

import '../../../../controller/auth_controller.dart';
import '../../../../controller/wishlist_controller.dart';
import '../../../../helper/price_converter.dart';
import '../../../base/custom_snackbar.dart';
import '../../../base/rating_bar.dart';

class BestReviewedItemView extends StatelessWidget {
  const BestReviewedItemView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = Get.find<EQAuthController>().isLoggedIn();

    return GetBuilder<EQItemController>(builder: (itemController) {
      List<Item>? itemList = itemController.reviewedItemList;

      return (itemList != null && itemList.isEmpty)
          ? const SizedBox()
          : Column(
              children: [
                Padding(
                  padding:   EdgeInsets.fromLTRB(10, 15, 10, 10),
                  child: TitleWidget(
                    title: Get.find<EQSplashControllerEquip>().module!.themeId == 2
                        ? 'best_reviewed_item2'.tr
                        : 'best_reviewed_item'.tr,
                    onTap: () =>
                        Get.toNamed(RouteHelper.getPopularItemRoute(false)),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: itemList != null
                      ? ListView.builder(
                          controller: ScrollController(),
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding:   EdgeInsets.only(
                              left: Dimensions.paddingSizeSmall),
                          itemCount:
                              itemList.length > 10 ? 10 : itemList.length,
                          itemBuilder: (context, index) {

                            double? startingPrice;
                            double? endingPrice;



                            double? discount = (Get.find<EQItemController>().item?.availableDateStarts != null || Get.find<EQItemController>().item?.storeDiscount == 0) ? Get.find<EQItemController>().item!.discount : Get.find<EQItemController>().item?.storeDiscount;
                            String? discountType = (Get.find<EQItemController>().item?.availableDateStarts != null || Get.find<EQItemController>().item?.storeDiscount == 0) ? Get.find<EQItemController>().item!.discountType : 'percent';

                            if (itemList[index]!.variations!.isNotEmpty) {
                              List<double?> priceList = [];
                              for (var variation
                                  in itemList[index]!.variations!) {
                                priceList.add(variation.price);
                              }
                              priceList.sort((a, b) => a!.compareTo(b!));
                              startingPrice = priceList[0];
                              if (priceList[0]! <
                                  priceList[priceList.length - 1]!) {
                                endingPrice = priceList[priceList.length - 1];
                              }
                            } else {
                              startingPrice = itemList[index]!.price;
                            }
                            return Padding(
                              padding:
                                    EdgeInsets.only(right: 5, bottom: 0),
                              child: InkWell(
                                onTap: () {
                                  Get.find<EQItemController>().navigateToItemPage(
                                      itemList[index], context);
                                },
                                child: Container(
                                  height: 200,
                                  width: 180,
                                  padding:   EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSmall),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[
                                            Get.find<EQThemeController>()
                                                    .darkTheme
                                                ? 800
                                                : 300]!,
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(
                                                      Dimensions.radiusSmall)),
                                          child: CustomImage(
                                            image:
                                                '${Get.find<EQSplashControllerEquip>().configModel!.baseUrls!.itemImageUrl}/${itemList[index].image}',
                                            height: 200,
                                            width: 180,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(decoration:  BoxDecoration(
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
                                      ),
                                      )
                                      ,                                        GetBuilder<EQWishListController>(
                                          builder: (wishController) {
                                            return InkWell(
                                              onTap: () {
                                                if (isLoggedIn) {
                                                  if (wishController
                                                      .wishItemIdList
                                                      .contains(
                                                      itemList[index].id)) {
                                                    wishController
                                                        .removeFromWishList(
                                                        itemList[index].id,
                                                        false);
                                                  } else {
                                                    wishController.addToWishList(
                                                        itemList[index],
                                                        null,
                                                        false);
                                                  }
                                                } else {
                                                  showCustomSnackBar(
                                                      'you_are_not_logged_in'.tr);
                                                }
                                              },
                                              child: Padding(
                                                padding:
                                                  EdgeInsets.all(5.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                      color: Colors.white),
                                                  child: Padding(
                                                    padding:
                                                      EdgeInsets.all(8.0),
                                                    child: Icon(
                                                      wishController
                                                          .wishItemIdList
                                                          .contains(
                                                          itemList[index]
                                                              .id)
                                                          ? Icons.favorite
                                                          : Icons.favorite_border,
                                                      size: 25,
                                                      color: wishController
                                                          .wishItemIdList
                                                          .contains(
                                                          itemList[index]
                                                              .id)
                                                          ? Theme.of(context)
                                                          .primaryColor
                                                          : Theme.of(context)
                                                          .disabledColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),

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
                                                '${PriceConverter.convertPrice(startingPrice, discount: discount, discountType: discountType)}'
                                                    '${endingPrice!= null ? ' - ${PriceConverter.convertPrice(endingPrice, discount: discount, discountType: discountType)}' : ''}',
                                                style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge), textDirection: TextDirection.ltr,
                                              ),
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

                                    ],
                                  ),
                                ),
                  ),
                );
              },
            ) : BestReviewedItemShimmer(itemController: itemController),
          ),
        ],
      );
    });
  }
}

class BestReviewedItemShimmer extends StatelessWidget {
  final EQItemController itemController;

  const BestReviewedItemShimmer({Key? key, required this.itemController}) : super(key: key);

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
          child: Container(
            height: 200, width: 180,
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
              duration: const Duration(seconds: 2),
              enabled: itemController.reviewedItemList == null,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                Stack(children: [
                  Container(
                    height: 125, width: 170,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusSmall)),
                      color: Colors.grey[300],
                    ),
                  ),
                  Positioned(
                    top: Dimensions.paddingSizeExtraSmall, right: Dimensions.paddingSizeExtraSmall,
                    child: Container(
                      padding:   EdgeInsets.symmetric(vertical: 2, horizontal: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      child: Row(children: [
                        Icon(Icons.star, color: Theme.of(context).primaryColor, size: 15),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Text('0.0', style: robotoRegular),
                      ]),
                    ),
                  ),
                ]),

                Expanded(
                  child: Stack(children: [
                    Padding(
                      padding:   EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                        Container(height: 15, width: 100, color: Colors.grey[300]),
                        const SizedBox(height: 2),

                        Container(height: 10, width: 70, color: Colors.grey[300]),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                                      Container(
                                          height: 10,
                                          width: 40,
                                          color: Colors.grey[300]),
                                      const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall),
                                      Container(
                                          height: 15,
                                          width: 40,
                                          color: Colors.grey[300]),
                                    ]),
                      ]),
                    ),
                    Positioned(bottom: 0, right: 0, child: Container(
                      height: 25, width: 25,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor
                      ),
                      child: const Icon(Icons.add, size: 20, color: Colors.white),
                    )),
                  ]),
                ),

              ]),
            ),
          ),
        );
      },
    );
  }
}