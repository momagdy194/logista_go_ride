import 'package:flutter/rendering.dart';
import 'package:customer/equipment/controller/auth_controller.dart';
import 'package:customer/equipment/controller/cart_controller.dart';
import 'package:customer/equipment/controller/category_controller.dart';
import 'package:customer/equipment/controller/store_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/controller/wishlist_controller.dart';
import 'package:customer/equipment/data/model/response/category_model.dart';
import 'package:customer/equipment/data/model/response/item_model.dart';
import 'package:customer/equipment/data/model/response/store_model.dart';
import 'package:customer/equipment/helper/date_converter.dart';
import 'package:customer/equipment/helper/price_converter.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/images.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/custom_image.dart';
import 'package:customer/equipment/view/base/custom_snackbar.dart';
import 'package:customer/equipment/view/base/footer_view.dart';
import 'package:customer/equipment/view/base/item_view.dart';
import 'package:customer/equipment/view/base/item_widget.dart';
import 'package:customer/equipment/view/base/menu_drawer.dart';
import 'package:customer/equipment/view/base/paginated_list_view.dart';
import 'package:customer/equipment/view/base/veg_filter_widget.dart';
import 'package:customer/equipment/view/base/web_menu_bar.dart';
import 'package:customer/equipment/view/screens/checkout/checkout_screen.dart';
import 'package:customer/equipment/view/screens/store/widget/customizable_space_bar.dart';
import 'package:customer/equipment/view/screens/store/widget/store_description_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widget/bottom_cart_widget.dart';

class StoreScreen extends StatefulWidget {
  final Store? store;
  final bool fromModule;
  const StoreScreen({Key? key, required this.store, required this.fromModule}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<EQStoreController>().hideAnimation();
    Get.find<EQStoreController>().getStoreDetails(Store(id: widget.store!.id), widget.fromModule).then((value) {
      Get.find<EQStoreController>().showButtonAnimation();
    });
    if(Get.find<EQCategoryController>().categoryList == null) {
      Get.find<EQCategoryController>().getCategoryList(true);
    }
    Get.find<EQStoreController>().getRestaurantRecommendedItemList(widget.store!.id, false);
    Get.find<EQStoreController>().getStoreItemList(widget.store!.id, 1, 'all', false);

    scrollController.addListener(() {
      if(scrollController.position.userScrollDirection == ScrollDirection.reverse){
        if(Get.find<EQStoreController>().showFavButton){
          Get.find<EQStoreController>().changeFavVisibility();
          Get.find<EQStoreController>().hideAnimation();
        }
      }else{
        if(!Get.find<EQStoreController>().showFavButton){
          Get.find<EQStoreController>().changeFavVisibility();
          Get.find<EQStoreController>().showButtonAnimation();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
      endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        child: GetBuilder<EQStoreController>(builder: (storeController) {
          return GetBuilder<EQCategoryController>(builder: (categoryController) {
            Store? store;
            if(storeController.store != null && storeController.store!.name != null && categoryController.categoryList != null) {
              store = storeController.store;
            }
            storeController.setCategoryList();

            return (storeController.store != null && storeController.store!.name != null && categoryController.categoryList != null)
                ? CustomScrollView(
              primary: true,
              shrinkWrap: false,
              // controller: scrollController,

              slivers: [

                ResponsiveHelper.isDesktop(context) ? SliverToBoxAdapter(
                  child: Container(
                    color: const Color(0xFF171A29),
                    padding:   EdgeInsets.all(Dimensions.paddingSizeLarge),
                    alignment: Alignment.center,
                    child: Center(child: SizedBox(width: Dimensions.webMaxWidth, child: Padding(
                      padding:   EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      child: Row(children: [

                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            child: CustomImage(
                              fit: BoxFit.cover, height: 220,
                              image: '${Get.find<EQSplashControllerEquip>().configModel!.baseUrls!.storeCoverPhotoUrl}/${store!.coverPhoto}',
                            ),
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeLarge),

                        Expanded(child: StoreDescriptionView(store: store)),

                      ]),
                    ))),
                  ),
                ) :





                SliverAppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  expandedHeight: 310,
                  elevation: 0,
                  floating: true,
                  iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                  centerTitle: true,
                  automaticallyImplyLeading: false,

                  // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  // expandedHeight: 310,
                  // elevation: 0,
                  // floating: true,
                  // pinned: true,
                  snap: true,
                  //  iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                  // centerTitle: true,
                  // toolbarHeight: 100,
                  //  automaticallyImplyLeading: true,

                  // backgroundColor: Theme.of(context).cardColor,
                  leading: IconButton(
                    icon: Container(
                      height: 50, width: 50,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).cardColor),
                      alignment: Alignment.center,
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                    onPressed: () => Get.back(),
                  ),

                  /*flexibleSpace: CustomizableSpaceBar(
                    builder: (context, scrollingRate) {
                      print('--------?>>> $scrollingRate');
                      /// Example content
                      return Padding(
                        padding: EdgeInsets.only(bottom: 0, left: 20 + 40 * scrollingRate),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            height: 100, color: Theme.of(context).cardColor,
                            child: Row(children: [

                              ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                child: Stack(children: [
                                  CustomImage(
                                    image: '${Get.find<SplashController>().configModel!.baseUrls!.storeImageUrl}/${store!.logo}',
                                    height: ResponsiveHelper.isDesktop(context) ? 80 : 60, width: ResponsiveHelper.isDesktop(context) ? 100 : 70, fit: BoxFit.cover,
                                  ),

                                  storeController.isStoreOpenNow(store.active!, store.schedules) ? const SizedBox() : Positioned(
                                    bottom: 0, left: 0, right: 0,
                                    child: Container(
                                      height: 30,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(Dimensions.radiusSmall)),
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                      child: Text(
                                        'closed_now'.tr, textAlign: TextAlign.center,
                                        style: robotoRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeSmall),

                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center, children: [
                                Row(children: [
                                  Expanded(child: Text(
                                    store.name!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyMedium!.color),
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                  )),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),

                                  GetBuilder<WishListController>(builder: (wishController) {
                                    bool isWished = wishController.wishStoreIdList.contains(store!.id);
                                    return InkWell(
                                      onTap: () {
                                        if(Get.find<AuthController>().isLoggedIn()) {
                                          isWished ? wishController.removeFromWishList(store!.id, true)
                                              : wishController.addToWishList(null, store, true);
                                        }else {
                                          showCustomSnackBar('you_are_not_logged_in'.tr);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        ),
                                        padding:   EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                        child: Icon(
                                          isWished ? Icons.favorite : Icons.favorite_border,
                                          color: isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    );
                                  }),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),

                                ]),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                Text(
                                  store.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                                ),
                                SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 0),
                                Row(children: [
                                  Text('minimum_order'.tr, style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
                                  )),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                  Text(
                                    PriceConverter.convertPrice(store.minimumOrder), textDirection: TextDirection.ltr,
                                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
                                  ),
                                ]),
                              ])),

                            ]),
                          ),
                        ),
                      );
                    },
                  ),*/
                  bottom:    RestorantTitleBarWidget(title: Column(children: [
                    Container(
                      height: 90,
                      color: Theme.of(context).cardColor,
                      child: Container(
                        // color: Theme.of(context).cardColor.withOpacity(scrollingRate),
                        // padding: EdgeInsets.only(bottom: 0, left: 40 * scrollingRate),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            // height: 100, color: Theme.of(context).cardColor.withOpacity(scrollingRate == 0.0 ? 1 : 0),
                            padding:   EdgeInsets.only(left: 20),
                            child: Row(children: [

                              ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                child: Stack(children: [
                                  CustomImage(
                                    image: '${Get.find<EQSplashControllerEquip>().configModel!.baseUrls!.storeImageUrl}/${store!.logo}',
                                    height: 60 , width: 70, fit: BoxFit.cover,
                                  ),

                                  storeController.isStoreOpenNow(store.active!, store.schedules) ? const SizedBox() : Positioned(
                                    bottom: 0, left: 0, right: 0,
                                    child: Container(
                                      height: 30,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(Dimensions.radiusSmall)),
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                      child: Text(
                                        'closed_now'.tr, textAlign: TextAlign.center,
                                        style: robotoRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeSmall),

                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center, children: [
                                Row(children: [
                                  Flexible(
                                    child: Padding(
                                      padding:   EdgeInsets.only(bottom: 0.0),
                                      child: Text(
                                        store.name?.replaceAll("ْ", "") ?? '',
                                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault,color: Colors.black),
                                        maxLines: 1, overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  (store.name??"").contains("ْ") ?   SizedBox(width: 5,):Container(),

                                  (store.name??"").contains("ْ") ?   Image.asset(Images.quality, width: 20,color: Theme.of(context).primaryColor ,):Container(),




                                  // Expanded(child: Text(
                                  //   store.name!,
                                  //   // style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge - (scrollingRate * 3), color: Theme.of(context).textTheme.bodyMedium!.color),
                                  //   maxLines: 1, overflow: TextOverflow.ellipsis,
                                  // )),
                                  // const SizedBox(width: Dimensions.paddingSizeSmall),

                                ]),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                Text(
                                  store.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                                  // style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall - (scrollingRate * 2), color: Theme.of(context).disabledColor),
                                ),
                                SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 0),
                                Row(children: [
                                  Text('minimum_order'.tr, style: robotoRegular.copyWith(
                                    // fontSize: Dimensions.fontSizeExtraSmall - (scrollingRate * 2),
                                    color: Theme.of(context).disabledColor,
                                  )),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                  Text(
                                    PriceConverter.convertPrice(store.minimumOrder), textDirection: TextDirection.ltr,
                                    // style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall - (scrollingRate * 2),
                                    //     color: Theme.of(context).primaryColor),
                                  ),
                                ]),
                              ])),

                              const SizedBox(width: Dimensions.paddingSizeSmall),
                            ]),
                          ),
                        ),
                      ),
                    ),
                    ResponsiveHelper.isDesktop(context) ? const SizedBox() : StoreDescriptionView(store: store),
                    store.discount != null ? Container(
                      width: context.width,
                      margin:   EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).primaryColor),
                      padding:   EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(
                          store.discount!.discountType == 'percent' ? '${store.discount!.discount}% ${'off'.tr}'
                              : '${PriceConverter.convertPrice(store.discount!.discount)} ${'off'.tr}',
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).cardColor),
                          textDirection: TextDirection.ltr,
                        ),
                        Text(
                          store.discount!.discountType == 'percent'
                              ? '${'enjoy'.tr} ${store.discount!.discount}% ${'off_on_all_categories'.tr}'
                              : '${'enjoy'.tr} ${PriceConverter.convertPrice(store.discount!.discount)}'
                              ' ${'off_on_all_categories'.tr}',
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor), textDirection: TextDirection.ltr,
                        ),
                        SizedBox(height: (store.discount!.minPurchase != 0 || store.discount!.maxDiscount != 0) ? 5 : 0),
                        store.discount!.minPurchase != 0 ? Text(
                          '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(store.discount!.minPurchase)} ]',
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor), textDirection: TextDirection.ltr,
                        ) : const SizedBox(),
                        store.discount!.maxDiscount != 0 ? Text(
                          '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(store.discount!.maxDiscount)} ]',
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor), textDirection: TextDirection.ltr,
                        ) : const SizedBox(),
                        Text(
                          '[ ${'daily_time'.tr}: ${DateConverter.convertTimeToTime(store.discount!.startTime!)} '
                              '- ${DateConverter.convertTimeToTime(store.discount!.endTime!)} ]',
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor),
                        ),
                      ]),
                    ) : const SizedBox(),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    storeController.recommendedItemModel != null && storeController.recommendedItemModel!.items!.isNotEmpty ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('recommended_items'.tr, style: robotoMedium),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        SizedBox(
                          height: ResponsiveHelper.isDesktop(context) ? 150 : 125,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: storeController.recommendedItemModel!.items!.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: ResponsiveHelper.isDesktop(context) ?   EdgeInsets.symmetric(vertical: 20) :   EdgeInsets.symmetric(vertical: 10) ,
                                child: Container(
                                  width: ResponsiveHelper.isDesktop(context) ? 500 : 300,
                                  padding:   EdgeInsets.only(right: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeExtraSmall),
                                  margin:   EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                  child: ItemWidget(
                                    isStore: false, item: storeController.recommendedItemModel!.items![index],
                                    store: null, index: index, length: null, isCampaign: false, inStore: true,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ) : const SizedBox(),
                  ]),),
                  flexibleSpace: Container(
                    margin: EdgeInsets.only(bottom: 50),
                    child: FlexibleSpaceBar(
                      titlePadding: EdgeInsets.zero,
                      centerTitle: true,
                      title: Text("data"),
                      expandedTitleScale: 1.1,
                      // title: CustomizableSpaceBar(
                      //   builder: (context, scrollingRate) {
                      //     return Container(
                      //       height: 100,
                      //       color: Theme.of(context).cardColor,
                      //       child: Container(
                      //         color: Theme.of(context).cardColor.withOpacity(scrollingRate),
                      //         padding: EdgeInsets.only(bottom: 0, left: 40 * scrollingRate),
                      //         child: Align(
                      //           alignment: Alignment.bottomLeft,
                      //           child: Container(
                      //             height: 100, color: Theme.of(context).cardColor.withOpacity(scrollingRate == 0.0 ? 1 : 0),
                      //             padding:   EdgeInsets.only(left: 20),
                      //             child: Row(children: [
                      //
                      //               ClipRRect(
                      //                 borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      //                 child: Stack(children: [
                      //                   CustomImage(
                      //                     image: '${Get.find<SplashController>().configModel!.baseUrls!.storeImageUrl}/${store!.logo}',
                      //                     height: 60 - (scrollingRate * 15), width: 70 - (scrollingRate * 15), fit: BoxFit.cover,
                      //                   ),
                      //
                      //                   storeController.isStoreOpenNow(store.active!, store.schedules) ? const SizedBox() : Positioned(
                      //                     bottom: 0, left: 0, right: 0,
                      //                     child: Container(
                      //                       height: 30,
                      //                       alignment: Alignment.center,
                      //                       decoration: BoxDecoration(
                      //                         borderRadius: const BorderRadius.vertical(bottom: Radius.circular(Dimensions.radiusSmall)),
                      //                         color: Colors.black.withOpacity(0.6),
                      //                       ),
                      //                       child: Text(
                      //                         'closed_now'.tr, textAlign: TextAlign.center,
                      //                         style: robotoRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ]),
                      //               ),
                      //               const SizedBox(width: Dimensions.paddingSizeSmall),
                      //
                      //               Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center, children: [
                      //                 Row(children: [
                      //                   Expanded(child: Text(
                      //                     store.name!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge - (scrollingRate * 3), color: Theme.of(context).textTheme.bodyMedium!.color),
                      //                     maxLines: 1, overflow: TextOverflow.ellipsis,
                      //                   )),
                      //                   const SizedBox(width: Dimensions.paddingSizeSmall),
                      //
                      //                 ]),
                      //                 const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      //                 Text(
                      //                   store.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                      //                   style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall - (scrollingRate * 2), color: Theme.of(context).disabledColor),
                      //                 ),
                      //                 SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 0),
                      //                 Row(children: [
                      //                   Text('minimum_order'.tr, style: robotoRegular.copyWith(
                      //                     fontSize: Dimensions.fontSizeExtraSmall - (scrollingRate * 2), color: Theme.of(context).disabledColor,
                      //                   )),
                      //                   const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      //                   Text(
                      //                     PriceConverter.convertPrice(store.minimumOrder), textDirection: TextDirection.ltr,
                      //                     style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall - (scrollingRate * 2), color: Theme.of(context).primaryColor),
                      //                   ),
                      //                 ]),
                      //               ])),
                      //
                      //               GetBuilder<WishListController>(builder: (wishController) {
                      //                 bool isWished = wishController.wishStoreIdList.contains(store!.id);
                      //                 return InkWell(
                      //                   onTap: () {
                      //                     if(Get.find<AuthController>().isLoggedIn()) {
                      //                       isWished ? wishController.removeFromWishList(store!.id, true)
                      //                           : wishController.addToWishList(null, store, true);
                      //                     }else {
                      //                       showCustomSnackBar('you_are_not_logged_in'.tr);
                      //                     }
                      //                   },
                      //                   child: Container(
                      //                     decoration: BoxDecoration(
                      //                       color: Theme.of(context).primaryColor.withOpacity(0.1),
                      //                       borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      //                     ),
                      //                     padding:   EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      //                     child: Icon(
                      //                       isWished ? Icons.favorite : Icons.favorite_border,
                      //                       color: isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                      //                       size: 24  - (scrollingRate * 4),
                      //                     ),
                      //                   ),
                      //                 );
                      //               }),
                      //               const SizedBox(width: Dimensions.paddingSizeSmall),
                      //             ]),
                      //           ),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                      background: CustomImage(
                        fit: BoxFit.cover,
                        image: '${Get.find<EQSplashControllerEquip>().configModel!.baseUrls!.storeCoverPhotoUrl}/${store!.coverPhoto}',
                        height: 350,
                        width: double.infinity,
                      ),
                      // Stack(
                      //   children: [
                     //
                     // ],
                     //  ),
                    ),
                  ),
                  actions:   [SizedBox(width: 10,),

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
                        child:

                        Container(
                          height: 40, width: 40,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).cardColor),
                          alignment: Alignment.center,
                          child: Icon(
                            isWished ? Icons.favorite : Icons.favorite_border,
                            color: isWished ?Colors.red : Colors.black,
                            // size: 24  - (scrollingRate * 4),
                          ),
                        ),



                      );
                    }),
SizedBox(width: 10,),
                    InkWell(
                      onTap: ()=> Get.toNamed(RouteHelper.getSearchStoreItemRoute(store!.id)),
                      child: Container(
                        height: 40, width: 40,

                        decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).cardColor),

                        padding:   EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        child: Icon(Icons.search, size: 28, color: Colors.black),
                      ),
                    ),SizedBox(width: 10,),

                  ],
                ),

                // SliverToBoxAdapter(child: Center(child: Container(
                //   width: Dimensions.webMaxWidth,
                //   padding:   EdgeInsets.all(Dimensions.paddingSizeSmall),
                //   color: Theme.of(context).cardColor,
                //   child:
                // ))),

                (storeController.categoryList!.isNotEmpty) ? SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverDelegate(height: 125, child: Center(child: Container(
                    width: Dimensions.webMaxWidth,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      // boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, spreadRadius: 1, blurRadius: 5)],
                    ),
                    padding:   EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Padding(
                          padding:   EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          child: Row(children: [
                            Text('all_products'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                            const Expanded(child: SizedBox()),
                            storeController.type.isNotEmpty ? VegFilterWidget(
                                type: storeController.type,
                                onSelected: (String type) {
                                  storeController.getStoreItemList(storeController.store!.id, 1, type, true);
                                },
                            ) : const SizedBox(),

                          ]),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: storeController.categoryList!.length,
                            padding:   EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () => storeController.setCategoryIndex(index),
                                child: Container(
                                  padding:   EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                                  margin:   EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    color: index == storeController.categoryIndex ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
                                  ),
                                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Text(
                                      storeController.categoryList![index].name!,
                                      style: index == storeController.categoryIndex
                                          ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)
                                          : robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                    ),
                                  ]),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Divider(thickness: 2),

                      ],
                    ),
                  ))),
                ) : const SliverToBoxAdapter(child: SizedBox()),

                SliverToBoxAdapter(child: FooterView(child: Container(
                  width: Dimensions.webMaxWidth,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                  ),
                  child: PaginatedListView(
                    scrollController: scrollController,
                    onPaginate: (int? offset) => storeController.getStoreItemList(widget.store!.id, offset!, storeController.type, false),
                    totalSize: storeController.storeItemModel != null ? storeController.storeItemModel!.totalSize : null,
                    offset: storeController.storeItemModel != null ? storeController.storeItemModel!.offset : null,
                    itemView: ItemsView(
                      isStore: false, stores: null,
                      items: (storeController.categoryList!.isNotEmpty && storeController.storeItemModel != null)
                          ? storeController.storeItemModel!.items : null,
                      inStorePage: true,
                      padding:   EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeSmall,
                        vertical: Dimensions.paddingSizeSmall,
                      ),
                    ),
                  ),
                ))),
              ],
            ) : const Center(child: CircularProgressIndicator());
          });
        }),
      ),

      floatingActionButton: GetBuilder<EQStoreController>(
        builder: (storeController) {
          return Visibility(
            visible: storeController.showFavButton && Get.find<EQSplashControllerEquip>().configModel!.moduleConfig!.module!.orderAttachment!
                && (storeController.store != null && storeController.store!.prescriptionOrder!) && Get.find<EQSplashControllerEquip>().configModel!.prescriptionStatus!,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.5), blurRadius: 10, offset: const Offset(2, 2))],
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [

                AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  width: storeController.currentState == true ? 0 : ResponsiveHelper.isDesktop(context) ? 180 : 150,
                  height: 30,
                  curve: Curves.linear,
                  child:  Center(
                    child: Text(
                      'prescription_order'.tr, textAlign: TextAlign.center,
                      style: robotoMedium.copyWith(color: Theme.of(context).primaryColor), maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                InkWell(
                  onTap: () => Get.toNamed(
                    RouteHelper.getCheckoutRoute('prescription', storeId: storeController.store!.id),
                    arguments: CheckoutScreen(fromCart: false, cartList: null, storeId: storeController.store!.id),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    padding:   EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Image.asset(Images.prescriptionIcon, height: 25, width: 25),
                  ),
                ),

              ]),
            ),
          );
        }
      ),

      bottomNavigationBar: GetBuilder<EQCartController>(builder: (cartController) {
        return cartController.cartList.isNotEmpty && !ResponsiveHelper.isDesktop(context) ? const BottomCartWidget() : const SizedBox();
      })
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;

  SliverDelegate({required this.child, this.height = 100});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != height || oldDelegate.minExtent != height || child != oldDelegate.child;
  }
}

class CategoryProduct {
  CategoryModel category;
  List<Item> products;
  CategoryProduct(this.category, this.products);
}





class RestorantTitleBarWidget extends StatelessWidget implements PreferredSize {
  final Widget  title;


  RestorantTitleBarWidget({required this.title});

  Widget buildTitleBar() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: title,
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildTitleBar();
  }

  @override
  Widget get child => buildTitleBar();

  @override
  Size get preferredSize => new Size(Get.width, 110);
}