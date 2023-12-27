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

class PopularItemView extends StatelessWidget {
  final bool isPopular;
  const PopularItemView({Key? key, required this.isPopular}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EQItemController>(builder: (itemController) {
      List<Item>? itemList = isPopular
          ? itemController.popularItemList
          : itemController.reviewedItemList;

      return (itemList != null && itemList.isEmpty)
          ? const SizedBox()
          : Column(
              children: [
                Padding(
                  padding:   EdgeInsets.fromLTRB(10, 15, 10, 10),
                  child: TitleWidget(
                    title: isPopular
                        ? 'popular_items_nearby'.tr
                        : 'best_reviewed_item'.tr,
                    onTap: () =>
                        Get.toNamed(RouteHelper.getPopularItemRoute(isPopular)),
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
                            return Padding(
                              padding:   EdgeInsets.fromLTRB(
                                  2, 2, Dimensions.paddingSizeSmall, 2),
                              child: InkWell(
                                onTap: () {
                                  Get.find<EQItemController>().navigateToItemPage(
                                      itemList[index], context);
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 180,
                                      width: 150,
                                      padding:   EdgeInsets.all(
                                          Dimensions.paddingSizeExtraSmall),
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
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Stack(children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions.radiusSmall),
                                                child: CustomImage(
                                                  image:
                                                      '${Get.find<EQSplashControllerEquip>().configModel!.baseUrls!.itemImageUrl}'
                                                      '/${itemList[index].image}',
                                                  height: 80,
                                                  width: 150,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              OrganicTag(
                                                  item: itemList[index],
                                                  placeInImage: true),
                                              itemController.isAvailable(
                                                      itemList[index])
                                                  ? const SizedBox()
                                                  : const NotAvailableWidget(),
                                            ]),
                                            Expanded(
                                              child: Padding(
                                                padding:   EdgeInsets
                                                        .symmetric(
                                                    horizontal: Dimensions
                                                        .paddingSizeExtraSmall),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Wrap(children: [
                                                        Row(children: [
                                                          Expanded(
                                                            child: Text(
                                                              itemList[index]
                                                                  .name!,
                                                              style: robotoMedium
                                                                  .copyWith(
                                                                      fontSize:
                                                                          Dimensions
                                                                              .fontSizeSmall),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 20)
                                                        ]),
                                                        const SizedBox(
                                                            width: Dimensions
                                                                .paddingSizeExtraSmall),
                                                        (Get.find<EQSplashControllerEquip>()
                                                                    .configModel!
                                                                    .moduleConfig!
                                                                    .module!
                                                                    .vegNonVeg! &&
                                                                Get.find<
                                                                        EQSplashControllerEquip>()
                                                                    .configModel!
                                                                    .toggleVegNonVeg!)
                                                            ? Image.asset(
                                                                itemList[index]
                                                                            .veg ==
                                                                        0
                                                                    ? Images
                                                                        .nonVegImage
                                                                    : Images
                                                                        .vegImage,
                                                                height: 10,
                                                                width: 10,
                                                                fit: BoxFit
                                                                    .contain)
                                                            : const SizedBox(),
                                                      ]),
                                                      const SizedBox(
                                                          height: Dimensions
                                                              .paddingSizeExtraSmall),

                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Flexible(
                                                            child: Text(
                                                              itemList[index]
                                                                  .storeName!,
                                                              style: robotoMedium.copyWith(
                                                                  fontSize: Dimensions
                                                                      .fontSizeExtraSmall,
                                                                  color: Theme.of(
                                                                      context)
                                                                      .disabledColor),
                                                              maxLines: 1,
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                            ),
                                                          ),
                                                          RatingBar(
                                                            rating:
                                                                itemList[index]
                                                                    .avgRating,
                                                            size: 12,
                                                            ratingCount:
                                                                itemList[index]
                                                                    .ratingCount,
                                                          ),
                                                        ],
                                                      ),
                                                      (Get.find<EQSplashControllerEquip>()
                                                                  .configModel!
                                                                  .moduleConfig!
                                                                  .module!
                                                                  .unit! &&
                                                              itemList[index]
                                                                      .unitType !=
                                                                  null)
                                                          ? Text(
                                                              '(${itemList[index].unitType ?? ''})',
                                                              style: robotoRegular.copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeExtraSmall,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .hintColor),
                                                            )
                                                          : const SizedBox(),
                                                      Row(children: [
                                                        Expanded(
                                                          child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  PriceConverter
                                                                      .convertPrice(
                                                                    itemController
                                                                        .getStartingPrice(
                                                                            itemList[index]),
                                                                    discount: itemList[
                                                                            index]
                                                                        .discount,
                                                                    discountType:
                                                                        itemList[index]
                                                                            .discountType,
                                                                  ),
                                                                  textDirection:
                                                                      TextDirection
                                                                          .ltr,
                                                                  style: robotoBold
                                                                      .copyWith(
                                                                          fontSize:
                                                                              Dimensions.fontSizeSmall),
                                                                ),
                                                                SizedBox(
                                                                    width: itemList[index].discount! >
                                                                            0
                                                                        ? Dimensions
                                                                            .paddingSizeExtraSmall
                                                                        : 0),
                                                                itemList[index]
                                                                            .discount! >
                                                                        0
                                                                    ? Flexible(
                                                                        child:
                                                                            Text(
                                                                        PriceConverter.convertPrice(
                                                                            itemController.getStartingPrice(itemList[index])),
                                                                        style: robotoMedium
                                                                            .copyWith(
                                                                          fontSize:
                                                                              Dimensions.fontSizeExtraSmall,
                                                                          color:
                                                                              Theme.of(context).disabledColor,
                                                                          decoration:
                                                                              TextDecoration.lineThrough,
                                                                        ),
                                                                        textDirection:
                                                                            TextDirection.ltr,
                                                                      ))
                                                                    : const SizedBox(),
                                                              ]),
                                                        ),
                                                        Icon(
                                                            Icons.arrow_forward,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            size: 20),
                                                      ]),
                                                    ]),
                                              ),
                                            ),
                                          ]),
                                    ),
                                    Positioned(
                                      right: Get.find<EQLocalizationController>()
                                              .isLtr
                                          ? 0
                                          : null,
                                      left: Get.find<EQLocalizationController>()
                                              .isLtr
                                          ? null
                                          : 0,
                                      child: CornerDiscountTag(
                                        bannerPosition:
                                            Get.find<EQLocalizationController>()
                                                    .isLtr
                                                ? CornerBannerPosition.topRight
                                                : CornerBannerPosition.topLeft,
                                        elevation: 0,
                                        discount: itemController
                                            .getDiscount(itemList[index]),
                                        discountType: itemController
                                            .getDiscountType(itemList[index]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : PopularItemShimmer(enabled: itemList == null),
                ),
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
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding:   EdgeInsets.only(left: Dimensions.paddingSizeSmall),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding:
                EdgeInsets.fromLTRB(2, 2, Dimensions.paddingSizeSmall, 2),
          child: Container(
            height: 90,
            width: 250,
            padding:   EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: [
                BoxShadow(
                  color: Colors
                      .grey[Get.find<EQThemeController>().darkTheme ? 700 : 300]!,
                  blurRadius: 5,
                  spreadRadius: 1,
                )
              ],
            ),
            child: Shimmer(
              duration: const Duration(seconds: 1),
              interval: const Duration(seconds: 1),
              enabled: enabled,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                        color: Colors.grey[300],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:   EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeExtraSmall),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: 15,
                                  width: 100,
                                  color: Colors.grey[300]),
                              const SizedBox(height: 5),
                              Container(
                                  height: 10,
                                  width: 130,
                                  color: Colors.grey[300]),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const RatingBar(
                                      rating: 0, size: 12, ratingCount: 0),
                                ],
                              ),
                              Row(children: [
                                Expanded(
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                            height: 15,
                                            width: 50,
                                            color: Colors.grey[300]),
                                        const SizedBox(
                                            width: Dimensions
                                                .paddingSizeExtraSmall),
                                        Container(
                                            height: 10,
                                            width: 50,
                                            color: Colors.grey[300]),
                                      ]),
                                ),
                                const Icon(Icons.add, size: 20),
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
