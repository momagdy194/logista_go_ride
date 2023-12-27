import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:customer/equipment/controller/auth_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/controller/store_controller.dart';
import 'package:customer/equipment/controller/wishlist_controller.dart';
import 'package:customer/equipment/data/model/response/config_model.dart';
import 'package:customer/equipment/data/model/response/store_model.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/custom_image.dart';
import 'package:customer/equipment/view/base/custom_snackbar.dart';
import 'package:customer/equipment/view/base/discount_tag.dart';
import 'package:customer/equipment/view/base/not_available_widget.dart';
import 'package:customer/equipment/view/base/rating_bar.dart';
import 'package:customer/equipment/view/screens/store/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreWidget extends StatelessWidget {
  final Store? store;
  final int index;
  final bool inStore;
  const StoreWidget({Key? key, required this.store, required this.index, this.inStore = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseUrls baseUrls = Get.find<EQSplashControllerEquip>().configModel!.baseUrls!;
    bool desktop = ResponsiveHelper.isDesktop(context);
    return InkWell(
      onTap: () {
        if(store != null){
          Get.toNamed(
            RouteHelper.getStoreRoute(store!.id, 'item'),
            arguments: StoreScreen(store: store!, fromModule: false),
          );
        }
      },
      child: Container(
        margin:   EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(
            color: Colors.grey[Get.isDarkMode ? 800 : 300]!, spreadRadius: 1, blurRadius: 5,
          )],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Stack(children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusSmall)),
              child: CustomImage(
                image: '${baseUrls.storeCoverPhotoUrl}/${store!.coverPhoto}',
                height: context.width * 0.3, width: Dimensions.webMaxWidth, fit: BoxFit.cover,
              )
            ),
            DiscountTag(
              discount: Get.find<EQStoreController>().getDiscount(store!),
              discountType: Get.find<EQStoreController>().getDiscountType(store!),
              freeDelivery: store!.freeDelivery,
            ),
            Get.find<EQStoreController>().isOpenNow(store!) ? const SizedBox() : const NotAvailableWidget(isStore: true),
          ]),

          Expanded(child: Padding(
            padding:   EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: Row(children: [

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                  Text(
                    store!.name!,
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                    maxLines: desktop ? 2 : 1, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),

                  (store!.address != null) ? Text(
                    store!.address ?? '',
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                      color: Theme.of(context).disabledColor,
                    ),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ) : const SizedBox(),
                  SizedBox(height: store!.address != null ? 2 : 0),

                  RatingBar(
                    rating: store!.avgRating, size: desktop ? 15 : 12,
                    ratingCount: store!.ratingCount,
                  ),

                ]),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              GetBuilder<EQWishListController>(builder: (wishController) {
                bool isWished = wishController.wishStoreIdList.contains(store!.id);
                return InkWell(
                  onTap: () {
                    if(Get.find<EQAuthController>().isLoggedIn()) {
                      isWished ? wishController.removeFromWishList(store!.id, true)
                          : wishController.addToWishList(null, store, true);
                    }else {
                      showCustomSnackBar('you_are_not_logged_in'.tr);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: desktop ? Dimensions.paddingSizeSmall : 0),
                    child: Icon(
                      isWished ? Icons.favorite : Icons.favorite_border,  size: desktop ? 30 : 25,
                      color: isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                    ),
                  ),
                );
              }),

            ]),
          )),

        ]),
      ),
    );
  }
}

class StoreShimmer extends StatelessWidget {
  final bool isEnable;
  const StoreShimmer({Key? key, required this.isEnable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:   EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(
          color: Colors.grey[Get.isDarkMode ? 800 : 300]!, spreadRadius: 1, blurRadius: 5,
        )],
      ),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        enabled: isEnable,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Container(
            height: context.width * 0.3, width: Dimensions.webMaxWidth,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusSmall)),
              color: Colors.grey[300],
            ),
          ),

          Expanded(child: Padding(
            padding:   EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: Row(children: [

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                  Container(height: 15, width: 150, color: Colors.grey[300]),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Container(height: 10, width: 50, color: Colors.grey[300]),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  const RatingBar(rating: 0, size: 12, ratingCount: 0),

                ]),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Icon(Icons.favorite_border,  size: 25, color: Theme.of(context).disabledColor),

            ]),
          )),

        ]),
      ),
    );
  }
}

