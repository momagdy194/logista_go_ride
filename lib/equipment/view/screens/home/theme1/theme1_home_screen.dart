import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:customer/equipment/controller/location_controller.dart';
import 'package:customer/equipment/controller/notification_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/controller/store_controller.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/images.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/item_view.dart';
import 'package:customer/equipment/view/base/paginated_list_view.dart';
import 'package:customer/equipment/view/screens/home/theme1/banner_view1.dart';
import 'package:customer/equipment/view/screens/home/theme1/best_reviewed_item_view.dart';
import 'package:customer/equipment/view/screens/home/theme1/category_view1.dart';
import 'package:customer/equipment/view/screens/home/theme1/item_campaign_view1.dart';
import 'package:customer/equipment/view/screens/home/theme1/popular_item_view1.dart';
import 'package:customer/equipment/view/screens/home/theme1/popular_store_view1.dart';
import 'package:customer/equipment/view/screens/home/widget/filter_view.dart';
import 'package:customer/equipment/view/screens/home/widget/module_view.dart';

import '../../../../controller/banner_controller.dart';
import '../../../../controller/localization_controller.dart';
import '../../../../data/model/response/banner_model.dart';

class Theme1HomeScreen extends StatelessWidget {
  final ScrollController scrollController;
  final EQSplashControllerEquip splashController;
  final bool showMobileModule;

    Theme1HomeScreen(
      {Key? key,
      required this.scrollController,
      required this.splashController,
      required this.showMobileModule})
      : super(key: key);

  bool isGet=false;
  xxxx(bannerController){
    bannerController.getBannerList(false);
       isGet=true;
  }
  @override
  Widget build(BuildContext context) {

    return CustomScrollView(
      shrinkWrap: true,
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // App Bar
        // SliverAppBar(
        //   floating: true, elevation: 0, automaticallyImplyLeading: false,
        //   backgroundColor: ResponsiveHelper.isDesktop(context) ? Colors.transparent : Theme.of(context).colorScheme.background,
        //   title: Center(child: Container(
        //     width: Dimensions.webMaxWidth, height: 50, color: Theme.of(context).colorScheme.background,
        //     child: Row(children: [
        //       (splashController.module != null && splashController.configModel!.module == null) ? InkWell(
        //         onTap: () => splashController.removeModule(),
        //         child: Image.asset(Images.moduleIcon, height: 22, width: 22),
        //       ) : const SizedBox(),
        //       SizedBox(width: (splashController.module != null && splashController.configModel!.module
        //           == null) ? Dimensions.paddingSizeExtraSmall : 0),
        //       Expanded(child: InkWell(
        //         onTap: () => Get.find<LocationController>().navigateToLocationScreen('home'),
        //         child: Padding(
        //           padding: EdgeInsets.symmetric(
        //             vertical: Dimensions.paddingSizeSmall,
        //             horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0,
        //           ),
        //           child: GetBuilder<LocationController>(builder: (locationController) {
        //             return Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start,
        //               children: [
        //                 Icon(
        //                   locationController.getUserAddress()!.addressType == 'home' ? Icons.home_filled
        //                       : locationController.getUserAddress()!.addressType == 'office' ? Icons.work : Icons.location_on,
        //                   size: 20, color: Theme.of(context).textTheme.bodyLarge!.color,
        //                 ),
        //                 const SizedBox(width: 10),
        //                 Flexible(
        //                   child: Text(
        //                     locationController.getUserAddress()!.address!,
        //                     style: robotoRegular.copyWith(
        //                       color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeSmall,
        //                     ),
        //                     maxLines: 1, overflow: TextOverflow.ellipsis,
        //                   ),
        //                 ),
        //                 Icon(Icons.arrow_drop_down, color: Theme.of(context).textTheme.bodyLarge!.color),
        //               ],
        //             );
        //           }),
        //         ),
        //       )),
        //       InkWell(
        //         child: GetBuilder<NotificationController>(builder: (notificationController) {
        //           return Stack(children: [
        //             Icon(Icons.notifications, size: 25, color: Theme.of(context).textTheme.bodyLarge!.color),
        //             notificationController.hasNotification ? Positioned(top: 0, right: 0, child: Container(
        //               height: 10, width: 10, decoration: BoxDecoration(
        //               color: Theme.of(context).primaryColor, shape: BoxShape.circle,
        //               border: Border.all(width: 1, color: Theme.of(context).cardColor),
        //             ),
        //             )) : const SizedBox(),
        //           ]);
        //         }),
        //         onTap: () => Get.toNamed(RouteHelper.getNotificationRoute()),
        //       ),
        //     ]),
        //   )),
        //   actions: const [SizedBox()],
        // ),

        // Search Button
        // !showMobileModule ? SliverPersistentHeader(
        //   pinned: true,
        //   delegate: SliverDelegate(child: Center(child: Container(
        //     height: 50, width: Dimensions.webMaxWidth,
        //     color: Theme.of(context).colorScheme.background,
        //     padding:   EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        //     child: InkWell(
        //       onTap: () => Get.toNamed(RouteHelper.getSearchRoute()),
        //       child: Container(
        //         padding:   EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        //         decoration: BoxDecoration(
        //           color: Theme.of(context).cardColor,
        //           borderRadius: BorderRadius.circular(25),
        //           boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
        //         ),
        //         child: Row(children: [
        //           const SizedBox(width: Dimensions.paddingSizeExtraSmall),
        //           Icon(
        //             Icons.search, size: 25,
        //             color: Theme.of(context).hintColor,
        //           ),
        //           const SizedBox(width: Dimensions.paddingSizeExtraSmall),
        //           Expanded(child: Text(
        //             Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
        //                 ? 'search_food_or_restaurant'.tr : 'search_item_or_store'.tr,
        //             style: robotoRegular.copyWith(
        //               fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor,
        //             ),
        //           )),
        //         ]),
        //       ),
        //     ),
        //   ))),
        // ) : const SliverToBoxAdapter(),
        SliverToBoxAdapter(
          child: GetBuilder<EQBannerController>(builder: (bannerController) {
            final bool ltr = Get.find<EQLocalizationController>().isLtr;

            List<BannerModel1>? banars = bannerController.bannerDataModel2List;
if(isGet==false){
  bannerController.getBannerList(false);
}
            BannerModel1 ban = (banars ?? []).firstWhere(
              (element) => (element.is_main != 1 && element.module_id != null),
              orElse: () {
                return BannerModel1();
              },
            );
            return  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  splashController.moduleList != null
                      ? splashController.moduleList!.isNotEmpty
                          ? Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 172,
                             decoration:  BoxDecoration(
                               gradient: LinearGradient(
                                 begin: Alignment.topCenter,
                                 end: Alignment.bottomCenter,
                                 stops: [0.1, 0.5, 0.7 ],
                                 colors: [
                                   HexColor(ban.bg_color??"#000000"),
                                   HexColor(ban.bg_color??"#000000").withOpacity(.5),
                                   HexColor(ban.bg_color??"#000000").withOpacity(.1),
                                 ],
                               ),
                             ), ),
                                    Positioned(
                                      left: ltr == false ? 0 : null,
                                      right: ltr == false ? null : 11,
                                      bottom: 0,
                                      child: Padding(
                                        padding:   EdgeInsets.symmetric(
                                            horizontal: 17),
                                        child: Image.network(
                                          '${Get.find<EQSplashControllerEquip>().configModel!.baseUrls!.bannerImageUrl}/${ban.image.toString()}',
                                          // "assets/image/person_image.png",
                                          height: 130,
                                          width: 150,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: ltr == true ? 11 : null,
                                      right: ltr == true ? null : 0,
                                      bottom: 11,
                                      child: Container(
                                        margin:   EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.paddingSizeSmall),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              ban.title?.replaceAll("..", "") ?? "",
                                              style: robotoMedium.copyWith(
                                                fontSize: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              ban.sub_title ?? "",

                                              // "What do you want to order today?".tr,
                                              style: robotoMedium.copyWith(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              child: Container(
                                                height: 30,
                                                width: 170,
                                                padding:
                                                      EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                child: InkWell(
                                                  onTap: () => Get.toNamed(
                                                      RouteHelper
                                                          .getSearchRoute()),
                                                  child: Container(
                                                    padding:   EdgeInsets
                                                            .symmetric(
                                                        horizontal: Dimensions
                                                            .paddingSizeSmall),
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .cardColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2),
                                                    ),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          const SizedBox(
                                                              width: Dimensions
                                                                  .paddingSizeExtraSmall),
                                                          Expanded(
                                                              child: Text(
                                                            Get.find<EQSplashControllerEquip>()
                                                                    .configModel!
                                                                    .moduleConfig!
                                                                    .module!
                                                                    .showRestaurantText!
                                                                ? 'بتدور علي ايه'
                                                                    .tr
                                                                : 'search_item_or_store'
                                                                    .tr,
                                                            style: robotoRegular
                                                                .copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall,
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor,
                                                            ),
                                                          )),
                                                          Icon(
                                                            IconlyLight.search,
                                                            size: 22,
                                                            color: Colors.black,
                                                          ),
                                                        ]),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Center(
                                    //     child: Container(
                                    //   width: Dimensions.webMaxWidth,
                                    //   child: Row(children: [
                                    //     (splashController.module != null &&
                                    //             splashController
                                    //                     .configModel!.module ==
                                    //                 null)
                                    //         ? InkWell(
                                    //             onTap: () => splashController
                                    //                 .removeModule(),
                                    //             child: Image.asset(
                                    //                 Images.moduleIcon,
                                    //                 height: 22,
                                    //                 width: 22),
                                    //           )
                                    //         : const SizedBox(),
                                    //     SizedBox(
                                    //         width: (splashController.module !=
                                    //                     null &&
                                    //                 splashController
                                    //                         .configModel!
                                    //                         .module ==
                                    //                     null)
                                    //             ? Dimensions
                                    //                 .paddingSizeExtraSmall
                                    //             : 0),
                                    //     Expanded(
                                    //         child: InkWell(
                                    //       onTap: () =>
                                    //           Get.find<LocationController>()
                                    //               .navigateToLocationScreen(
                                    //                   'home'),
                                    //       child: Padding(
                                    //         padding: EdgeInsets.symmetric(
                                    //           vertical:
                                    //               Dimensions.paddingSizeSmall,
                                    //           horizontal: ResponsiveHelper
                                    //                   .isDesktop(context)
                                    //               ? Dimensions.paddingSizeSmall
                                    //               : 0,
                                    //         ),
                                    //         child:
                                    //             GetBuilder<LocationController>(
                                    //                 builder:
                                    //                     (locationController) {
                                    //           return Padding(
                                    //             padding:
                                    //                   EdgeInsets.symmetric(
                                    //                     horizontal: 12),
                                    //             child: Column(
                                    //               mainAxisAlignment:
                                    //                   MainAxisAlignment.start,
                                    //               crossAxisAlignment:
                                    //                   CrossAxisAlignment.start,
                                    //               children: [
                                    //                 Text("التوصيل الي"),
                                    //                 Row(
                                    //                   crossAxisAlignment:
                                    //                       CrossAxisAlignment
                                    //                           .center,
                                    //                   mainAxisAlignment:
                                    //                       MainAxisAlignment
                                    //                           .start,
                                    //                   children: [
                                    //                     // Icon(
                                    //                     //   locationController.getUserAddress()!.addressType == 'home' ? Icons.home_filled
                                    //                     //       : locationController.getUserAddress()!.addressType == 'office' ? Icons.work : Icons.location_on,
                                    //                     //   size: 20, color: Theme.of(context).textTheme.bodyLarge!.color,
                                    //                     // ),
                                    //                     // const SizedBox(width: 10),
                                    //                     Flexible(
                                    //                       child: Text(
                                    //                         locationController
                                    //                             .getUserAddress()!
                                    //                             .address!,
                                    //                         style: robotoRegular
                                    //                             .copyWith(
                                    //                           color: Theme.of(
                                    //                                   context)
                                    //                               .textTheme
                                    //                               .bodyLarge!
                                    //                               .color,
                                    //                           fontSize: Dimensions
                                    //                               .fontSizeSmall,
                                    //                         ),
                                    //                         maxLines: 1,
                                    //                         overflow:
                                    //                             TextOverflow
                                    //                                 .ellipsis,
                                    //                       ),
                                    //                     ),
                                    //                     Icon(
                                    //                       Icons
                                    //                           .keyboard_arrow_down_sharp,
                                    //                       color:
                                    //                           Theme.of(context)
                                    //                               .textTheme
                                    //                               .bodyLarge!
                                    //                               .color,
                                    //                       size: 25,
                                    //                     ),
                                    //                   ],
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           );
                                    //         }),
                                    //       ),
                                    //     )),
                                    //     InkWell(
                                    //       child: GetBuilder<
                                    //               NotificationController>(
                                    //           builder:
                                    //               (notificationController) {
                                    //         return Stack(children: [
                                    //           Padding(
                                    //             padding:
                                    //                   EdgeInsets.all(8.0),
                                    //             child: Icon(
                                    //                 IconlyLight.notification,
                                    //                 size: 25,
                                    //                 color: Theme.of(context)
                                    //                     .textTheme
                                    //                     .bodyLarge!
                                    //                     .color),
                                    //           ),
                                    //           notificationController
                                    //                   .hasNotification
                                    //               ? Positioned(
                                    //                   top: 0,
                                    //                   right: 0,
                                    //                   child: Container(
                                    //                     height: 10,
                                    //                     width: 10,
                                    //                     decoration:
                                    //                         BoxDecoration(
                                    //                       color:
                                    //                           Theme.of(context)
                                    //                               .primaryColor,
                                    //                       shape:
                                    //                           BoxShape.circle,
                                    //                       border: Border.all(
                                    //                           width: 1,
                                    //                           color: Theme.of(
                                    //                                   context)
                                    //                               .cardColor),
                                    //                     ),
                                    //                   ))
                                    //               : const SizedBox(),
                                    //         ]);
                                    //       }),
                                    //       onTap: () => Get.toNamed(RouteHelper
                                    //           .getNotificationRoute()),
                                    //     ),
                                    //   ]),
                                    // )),
                                  ],
                                ),
                              ],
                            )
                          : Center(
                              child: Padding(
                              padding:   EdgeInsets.only(
                                  top: Dimensions.paddingSizeSmall),
                              child: Text('no_module_found'.tr),
                            ))
                      : ModuleShimmer(
                          isEnabled: splashController.moduleList == null),
                ]);
          }),
        ),
        SliverToBoxAdapter(
          child: Center(
              child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: !showMobileModule
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        const CategoryView1(),

                      const ItemCampaignView1(),
                        const BestReviewedItemView(),
                      const BannerView1(isFeatured: false),

                      // const PopularStoreView1(
                      //       isPopular: true, isFeatured: false),
                        const PopularItemView1(isPopular: true),
              // const PopularStoreView1(isPopular: false, isFeatured: false),

              // Padding(
              //   padding:   EdgeInsets.fromLTRB(10, 15, 0, 5),
              //   child: Row(children: [
              //     Expanded(child: Text(
              //       Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
              //           ? 'all_restaurants'.tr : 'all_stores'.tr,
              //       style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
              //     )),
              //     const FilterView(),
              //   ]),
              // ),

              // GetBuilder<StoreController>(builder: (storeController) {
              //   return PaginatedListView(
              //     scrollController: scrollController,
              //     totalSize: storeController.storeModel != null ? storeController.storeModel!.totalSize : null,
              //     offset: storeController.storeModel != null ? storeController.storeModel!.offset : null,
              //     onPaginate: (int? offset) async => await storeController.getStoreList(offset!, false),
              //     itemView: ItemsView(
              //       isStore: true, items: null, showTheme1Store: true,
              //       stores: storeController.storeModel != null ? storeController.storeModel!.stores : null,
              //       padding: EdgeInsets.symmetric(
              //         horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall,
              //         vertical: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 0,
              //       ),
              //     ),
              //   );
              // }),
SizedBox(height: 25,)
            ]) : ModuleView(splashController: splashController),
          )),
        ),
      ],
    );
  }
}
