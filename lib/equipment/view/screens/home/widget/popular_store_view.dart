import 'package:customer/equipment/controller/auth_controller.dart';
import 'package:customer/equipment/controller/store_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/controller/theme_controller.dart';
import 'package:customer/equipment/controller/wishlist_controller.dart';
import 'package:customer/equipment/data/model/response/module_model.dart';
import 'package:customer/equipment/data/model/response/store_model.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/util/app_constants.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/custom_image.dart';
import 'package:customer/equipment/view/base/custom_snackbar.dart';
import 'package:customer/equipment/view/base/discount_tag.dart';
import 'package:customer/equipment/view/base/not_available_widget.dart';
import 'package:customer/equipment/view/base/rating_bar.dart';
import 'package:customer/equipment/view/base/title_widget.dart';
import 'package:customer/equipment/view/screens/store/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

import '../../../../util/images.dart';

class PopularStoreView extends StatelessWidget {
  final bool isPopular;
  final bool isFeatured;
  const PopularStoreView(
      {Key? key, required this.isPopular, required this.isFeatured})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EQStoreController>(builder: (storeController) {
      List<Store>? storeList = isFeatured
          ? storeController.featuredStoreList
          : isPopular
              ? storeController.popularStoreList
              : storeController.latestStoreList;

      return (storeList != null && storeList.isEmpty)
          ? const SizedBox()
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, isPopular ? 2 : 15, 10, 10),
                  child: TitleWidget(
                    title: isFeatured
                        ? 'featured_stores'.tr
                        : isPopular
                            ? Get.find<EQSplashControllerEquip>()
                                    .configModel!
                                    .moduleConfig!
                                    .module!
                                    .showRestaurantText!
                                ? 'popular_restaurants'.tr
                                : 'popular_stores'.tr
                            : '${'new_on'.tr}',
                    onTap: () =>
                        Get.toNamed(RouteHelper.getAllStoreRoute(isFeatured
                            ? 'featured'
                            : isPopular
                                ? 'popular'
                                : 'latest')),
                  ),
                ),
                SizedBox(
                  height: 210,
                  child: storeList != null
                      ? ListView.builder(
                          controller: ScrollController(),
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding:   EdgeInsets.only(
                              left: Dimensions.paddingSizeSmall),
                          itemCount:
                              storeList.length > 10 ? 10 : storeList.length,
                          itemBuilder: (context, index) {
                            bool isAvailable = storeList[index].open == 1 &&
                                storeList[index].active == true;
// myString.substring(myString.lastIndexOf("/")+1, myString.indexOf("."))
//     String myString= storeList[index].deliveryTime.toString();
// String befDel= myString.substring(myString.lastIndexOf("-")+1, 6);
                            return Padding(
                              padding:   EdgeInsets.only(
                                  right: Dimensions.paddingSizeSmall,
                                  bottom: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[300]!,
                                          blurRadius: 10,
                                          spreadRadius: 1)
                                    ]),
                                child: InkWell(
                                  onTap: () {
                                    if (isFeatured &&
                                        Get.find<EQSplashControllerEquip>()
                                                .moduleList !=
                                            null) {
                                      for (ModuleModel module
                                          in Get.find<EQSplashControllerEquip>()
                                              .moduleList!) {
                                        if (module.id ==
                                            storeList[index].moduleId) {
                                          Get.find<EQSplashControllerEquip>()
                                              .setModule(module);
                                          break;
                                        }
                                      }
                                    }
                                    Get.toNamed(
                                      RouteHelper.getStoreRoute(
                                          storeList[index].id,
                                          isFeatured ? 'module' : 'store'),
                                      arguments: StoreScreen(
                                          store: storeList[index],
                                          fromModule: isFeatured),
                                    );
                                  },
                                  child: Container(
                                    height: 200,
                                    width: 200,
                                    margin:   EdgeInsets.only(
                                        top: Dimensions.paddingSizeExtraSmall),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: CustomImage(
                                                image:
                                                    '${Get.find<EQSplashControllerEquip>().configModel!.baseUrls!.storeCoverPhotoUrl}'
                                                    '/${storeList[index].coverPhoto}',
                                                height: 130,
                                                width: 312,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            DiscountTag(
                                              discount:
                                                  storeController.getDiscount(
                                                      storeList[index]),
                                              discountType: storeController
                                                  .getDiscountType(
                                                      storeList[index]),
                                              freeDelivery:
                                                  storeList[index].freeDelivery,
                                            ),
                                            storeController
                                                    .isOpenNow(storeList[index])
                                                ? const SizedBox()
                                                : NotAvailableWidget(
                                                    isStore: true,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                            Positioned(
                                              top: Dimensions
                                                      .paddingSizeExtraSmall +
                                                  5,
                                              right: Dimensions
                                                      .paddingSizeExtraSmall +
                                                  5,
                                              child: GetBuilder<
                                                      EQWishListController>(
                                                  builder: (wishController) {
                                                bool isWished = wishController
                                                    .wishStoreIdList
                                                    .contains(
                                                        storeList[index].id);
                                                return InkWell(
                                                  onTap: () {
                                                    if (Get.find<
                                                            EQAuthController>()
                                                        .isLoggedIn()) {
                                                      isWished
                                                          ? wishController
                                                              .removeFromWishList(
                                                                  storeList[
                                                                          index]
                                                                      .id,
                                                                  true)
                                                          : wishController
                                                              .addToWishList(
                                                                  null,
                                                                  storeList[
                                                                      index],
                                                                  true);
                                                    } else {
                                                      showCustomSnackBar(
                                                          'you_are_not_logged_in'
                                                              .tr);
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:   EdgeInsets
                                                            .all(
                                                        Dimensions
                                                            .paddingSizeExtraSmall),
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .cardColor,
                                                        borderRadius:
                                                            //  BorderRadius.only(
                                                            //                         topLeft:Radius.circular((index%2==0)?0: 20) ,
                                                            //                         bottomRight: Radius.circular((index%2==0)?0: 20) ,
                                                            //                         bottomLeft :Radius.circular((index%2!=0)?0: 20) ,
                                                            //                         topRight:Radius.circular((index%2!=0)?0: 20) ,

                                                            //                         )
                                                            BorderRadius
                                                                .circular(100)),
                                                    child: Icon(
                                                      isWished
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border,
                                                      size: 20,
                                                      color: isWished
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : Theme.of(context)
                                                              .primaryColor,
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ),
                                            Positioned(
                                                bottom: Dimensions
                                                        .paddingSizeExtraSmall +
                                                    5,
                                                right: Dimensions
                                                        .paddingSizeExtraSmall +
                                                    5,
                                                child: DecorationContainer(
                                                  color: Color(0xffFAFAFA),
                                                  borderRadius: 5,
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.circle,
                                                          color: isAvailable ==
                                                                  true
                                                              ? Colors.green
                                                              : Colors.red,
                                                          size: 10),
                                                      Text(
                                                        isAvailable == true
                                                            ? "مفتوح"
                                                            : "مغلق",
                                                        style: robotoMedium
                                                            .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                          color: isAvailable ==
                                                                  true
                                                              ? Colors.green
                                                              : Colors.red,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ]),
                                          Expanded(
                                            child: Padding(
                                              padding:   EdgeInsets
                                                      .symmetric(
                                                  horizontal: Dimensions
                                                      .paddingSizeExtraSmall),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Flexible(
                                                          child: Padding(
                                                            padding:
                                                                  EdgeInsets
                                                                        .only(
                                                                    bottom:
                                                                        0.0),
                                                            child: Text(
                                                              storeList[index]
                                                                      .name
                                                                      ?.replaceAll(
                                                                          "ْ",
                                                                          "") ??
                                                                  '',
                                                              style: robotoMedium.copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeDefault,
                                                                  color: Colors
                                                                      .black),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                        (storeList[index]
                                                                        .name ??
                                                                    "")
                                                                .contains("ْ")
                                                            ? SizedBox(
                                                                width: 5,
                                                              )
                                                            : Container(),
                                                        (storeList[index]
                                                                        .name ??
                                                                    "")
                                                                .contains("ْ")
                                                            ? Image.asset(
                                                                Images.quality,
                                                                width: 20,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              )
                                                            : Container(),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                        height: Dimensions
                                                            .paddingSizeExtraSmall),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                "assets/image/loca.png",
                                                                height: 25,
                                                                width: 25,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                              Flexible(
                                                                child: Text(
                                                                  storeList[index]
                                                                          .address ??
                                                                      '',
                                                                  style: robotoMedium.copyWith(
                                                                      fontSize:
                                                                          Dimensions
                                                                              .fontSizeSmall,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .disabledColor),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            DecorationContainer(
                                                             color: Colors.transparent,
                                                              borderRadius: 5,
                                                              child: RatingBar(
                                                                rating: storeList[
                                                                        index]
                                                                    .avgRating,
                                                                ratingCount:
                                                                    storeList[
                                                                            index]
                                                                        .ratingCount,
                                                                size: Dimensions
                                                                    .fontSizeSmall,
                                                                iconColor:Colors.amber
                                                              ),
                                                              width: 70,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                        height: Dimensions
                                                            .paddingSizeExtraSmall),
                                                  ]),
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : PopularStoreShimmer(storeController: storeController),
                ),
              ],
            );
    });
  }
}

class PopularStoreShimmer extends StatelessWidget {
  final EQStoreController storeController;
  const PopularStoreShimmer({Key? key, required this.storeController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding:   EdgeInsets.only(left: Dimensions.paddingSizeSmall),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          height: 200,
          width: 200,
          margin:   EdgeInsets.only(
              right: Dimensions.paddingSizeSmall, bottom: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300]!, blurRadius: 10, spreadRadius: 1)
              ]),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 90,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(Dimensions.radiusSmall)),
                    color: Colors.grey[300]),
              ),
              Expanded(
                child: Padding(
                  padding:
                        EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 10, width: 100, color: Colors.grey[300]),
                        const SizedBox(height: 5),
                        Container(
                            height: 10, width: 130, color: Colors.grey[300]),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const RatingBar(
                                rating: 0.0, size: 12, ratingCount: 0),
                          ],
                        ),
                      ]),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}

class DecorationContainer extends StatelessWidget {
  Widget child;
  Color color;
  double borderRadius;
  double? width;

  DecorationContainer(
      {Key? key,
      required this.child,
      required this.color,
      this.width,
      required this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: color,
        ),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: child);
  }
}
