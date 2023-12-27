import 'package:iconly/iconly.dart';
import 'package:customer/equipment/controller/auth_controller.dart';
import 'package:customer/equipment/controller/banner_controller.dart';
import 'package:customer/equipment/controller/campaign_controller.dart';
import 'package:customer/equipment/controller/category_controller.dart';
import 'package:customer/equipment/controller/location_controller.dart';
import 'package:customer/equipment/controller/notification_controller.dart';
import 'package:customer/equipment/controller/item_controller.dart';
import 'package:customer/equipment/controller/parcel_controller.dart';
import 'package:customer/equipment/controller/store_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/controller/user_controller.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/theme/light_theme.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/images.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/item_view.dart';
import 'package:customer/equipment/view/base/menu_drawer.dart';
import 'package:customer/equipment/view/base/paginated_list_view.dart';
import 'package:customer/equipment/view/base/web_menu_bar.dart';
import 'package:customer/equipment/view/screens/home/theme1/theme1_home_screen.dart';
import 'package:customer/equipment/view/screens/home/web_home_screen.dart';
import 'package:customer/equipment/view/screens/home/widget/filter_view.dart';
import 'package:customer/equipment/view/screens/home/widget/popular_item_view.dart';
import 'package:customer/equipment/view/screens/home/widget/item_campaign_view.dart';
import 'package:customer/equipment/view/screens/home/widget/popular_store_view.dart';
import 'package:customer/equipment/view/screens/home/widget/banner_view.dart';
import 'package:customer/equipment/view/screens/home/widget/category_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/equipment/view/screens/home/widget/module_view.dart';
import 'package:customer/equipment/view/screens/parcel/parcel_category_screen.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static Future<void> loadData(bool reload) async {
    if (Get.find<EQSplashControllerEquip>().module != null &&
        !Get.find<EQSplashControllerEquip>()
            .configModel!
            .moduleConfig!
            .module!
            .isParcel!) {
      Get.find<EQLocationController>().syncZoneData();
      Get.find<EQBannerController>().getBannerList(reload);
      Get.find<EQCategoryController>().getCategoryList(reload);
      Get.find<EQStoreController>().getPopularStoreList(reload, 'all', false);
      Get.find<EQCampaignController>().getItemCampaignList(reload);
      Get.find<EQItemController>().getPopularItemList(reload, 'all', false);
      Get.find<EQStoreController>().getLatestStoreList(reload, 'all', false);
      Get.find<EQItemController>().getReviewedItemList(reload, 'all', false);
      Get.find<EQStoreController>().getStoreList(1, reload);
    }
    if (Get.find<EQAuthController>().isLoggedIn()) {
      Get.find<EQUserController>().getUserInfo();
      Get.find<EQNotificationController>().getNotificationList(reload);
    }
    Get.find<EQSplashControllerEquip>().getModules();
    if (Get.find<EQSplashControllerEquip>().module == null &&
        Get.find<EQSplashControllerEquip>().configModel!.module == null) {
      Get.find<EQBannerController>().getFeaturedBanner();
      Get.find<EQStoreController>().getFeaturedStoreList();
      if (Get.find<EQAuthController>().isLoggedIn()) {
        Get.find<EQLocationController>().getAddressList();
      }
    }
    if (Get.find<EQSplashControllerEquip>().module != null &&
        Get.find<EQSplashControllerEquip>()
            .configModel!
            .moduleConfig!
            .module!
            .isParcel!) {
      Get.find<EQParcelController>().getParcelCategoryList();
    }
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    HomeScreen.loadData(false).then((value) {
      setState(() {});
    });
    if (!ResponsiveHelper.isWeb()) {
      Get.find<EQLocationController>()
          .getZone(Get.find<EQLocationController>().getUserAddress()!.latitude,
              Get.find<EQLocationController>().getUserAddress()!.longitude, false,
              updateInAddress: true)
          .then((value) {
        setState(() {});
      });
      ;
    }
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EQSplashControllerEquip>(builder: (splashController) {
      bool showMobileModule =

          !ResponsiveHelper.isDesktop(context) &&
          splashController.module == null &&
          splashController.configModel!.module == null;
      bool isParcel = splashController.module != null &&
          splashController.configModel!.moduleConfig!.module!.isParcel!;
      // bool isTaxiBooking = splashController.module != null && splashController.configModel!.moduleConfig!.module!.isTaxi!;

      return Scaffold(
        appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
        endDrawer: const MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,
        backgroundColor: ResponsiveHelper.isDesktop(context)
            ? Theme.of(context).cardColor
            : splashController.module == null
                ? Theme.of(context).cardColor
                : null,
        body: /*isTaxiBooking ? const RiderHomeScreen() :*/ isParcel
            ? const ParcelCategoryScreen()
            : SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async {
                    if (Get.find<EQSplashControllerEquip>().module != null) {
                      await Get.find<EQLocationController>().syncZoneData();
                      await Get.find<EQBannerController>().getBannerList(true);
                      await Get.find<EQCategoryController>()
                          .getCategoryList(true);
                      await Get.find<EQStoreController>()
                          .getPopularStoreList(true, 'all', false);
                      await Get.find<EQCampaignController>()
                          .getItemCampaignList(true);
                      await Get.find<EQItemController>()
                          .getPopularItemList(true, 'all', false);
                      await Get.find<EQStoreController>()
                          .getLatestStoreList(true, 'all', false);
                      await Get.find<EQItemController>()
                          .getReviewedItemList(true, 'all', false);
                      await Get.find<EQStoreController>().getStoreList(1, true);
                      if (Get.find<EQAuthController>().isLoggedIn()) {
                        await Get.find<EQUserController>().getUserInfo();
                        await Get.find<EQNotificationController>()
                            .getNotificationList(true);
                      }
                    } else {
                      await Get.find<EQBannerController>().getFeaturedBanner();
                      await Get.find<EQSplashControllerEquip>().getModules();
                      if (Get.find<EQAuthController>().isLoggedIn()) {
                        await Get.find<EQLocationController>().getAddressList();
                      }
                      await Get.find<EQStoreController>().getFeaturedStoreList();
                    }
                  },
                  child: ResponsiveHelper.isDesktop(context)
                      ? WebHomeScreen(
                          scrollController: _scrollController,
                        )
                      : (Get.find<EQSplashControllerEquip>().module != null &&
                              Get.find<EQSplashControllerEquip>().module!.themeId == 2)
                          ? Theme1HomeScreen(
                              scrollController: _scrollController,
                              splashController: splashController,
                              showMobileModule: showMobileModule,
                            )
                          : CustomScrollView(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              slivers: [
                                SliverToBoxAdapter(
                                  child: Stack(children: [
                                    // App Bar
                                    (splashController.module != null)
                                        ? Center(
                                            child: Container(
                                            decoration: BoxDecoration(
                                              // gradient: LinearGradient(
                                              //   begin: Alignment.topCenter,
                                              //   end: Alignment.bottomCenter,
                                              //   stops: [0.1, 0.5, 0.7],
                                              //   colors: [
                                              //     Theme.of(context)
                                              //         .primaryColor,
                                              //     Theme.of(context)
                                              //         .primaryColor
                                              //         .withOpacity(.5),
                                              //     Theme.of(context)
                                              //         .primaryColor
                                              //         .withOpacity(.1),
                                              //   ],
                                              // ),
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                    width:
                                                        Dimensions.webMaxWidth,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                      ),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                                width: (splashController.module !=
                                                                            null &&
                                                                        splashController.configModel!.module ==
                                                                            null)
                                                                    ? Dimensions
                                                                        .paddingSizeExtraSmall
                                                                    : 0),
                                                            Expanded(
                                                              child: Center(
                                                                  child:
                                                                      Container(
                                                                width: Dimensions
                                                                    .webMaxWidth,
                                                                child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                          child:
                                                                              InkWell(
                                                                        onTap: () =>
                                                                            Get.find<EQLocationController>().navigateToLocationScreen('home'),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(
                                                                            vertical:
                                                                                Dimensions.paddingSizeSmall,
                                                                            horizontal: ResponsiveHelper.isDesktop(context)
                                                                                ? Dimensions.paddingSizeSmall
                                                                                : 0,
                                                                          ),
                                                                          child:
                                                                              GetBuilder<EQLocationController>(builder: (locationController) {
                                                                            return Padding(
                                                                              padding:   EdgeInsets.symmetric(horizontal: 0),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text("delevary_to".tr),
                                                                                  Row(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: [
                                                                                      // Icon(
                                                                                      //   locationController.getUserAddress()!.addressType == 'home' ? Icons.home_filled
                                                                                      //       : locationController.getUserAddress()!.addressType == 'office' ? Icons.work : Icons.location_on,
                                                                                      //   size: 20, color: Theme.of(context).textTheme.bodyLarge!.color,
                                                                                      // ),
                                                                                      // const SizedBox(width: 10),
                                                                                      Flexible(
                                                                                        child: Text(
                                                                                          locationController.getUserAddress()!.address!,
                                                                                          style: robotoRegular.copyWith(
                                                                                            color: Theme.of(context).textTheme.bodyLarge!.color,
                                                                                            fontSize: Dimensions.fontSizeSmall,
                                                                                          ),
                                                                                          maxLines: 1,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                      ),
                                                                                      Icon(
                                                                                        Icons.keyboard_arrow_down_sharp,
                                                                                        color: Theme.of(context).textTheme.bodyLarge!.color,
                                                                                        size: 25,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          }),
                                                                        ),
                                                                      )),
                                                                      InkWell(
                                                                        child: GetBuilder<EQNotificationController>(builder:
                                                                            (notificationController) {
                                                                          return Stack(
                                                                              children: [
                                                                                Padding(
                                                                                  padding:   EdgeInsets.all(8.0),
                                                                                  child: Icon(IconlyLight.notification, size: 25, color: Theme.of(context).textTheme.bodyLarge!.color),
                                                                                ),
                                                                                notificationController.hasNotification
                                                                                    ? Positioned(
                                                                                        top: 0,
                                                                                        right: 0,
                                                                                        child: Container(
                                                                                          height: 10,
                                                                                          width: 10,
                                                                                          decoration: BoxDecoration(
                                                                                            color: Theme.of(context).primaryColor,
                                                                                            shape: BoxShape.circle,
                                                                                            border: Border.all(width: 1, color: Theme.of(context).cardColor),
                                                                                          ),
                                                                                        ))
                                                                                    : const SizedBox(),
                                                                              ]);
                                                                        }),
                                                                        onTap: () =>
                                                                            Get.toNamed(RouteHelper.getNotificationRoute()),
                                                                      ),
                                                                    ]),
                                                              )),
                                                            ),
                                                          ]),
                                                    )),
                                                Container(
                                                  child: Stack(
                                                    clipBehavior: Clip.hardEdge,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        30)),
                                                        child: ClipPath(
                                                          clipper:
                                                              ProsteThirdOrderBezierCurve(
                                                            position:
                                                                ClipPosition
                                                                    .bottom,
                                                            list: [
                                                              ThirdOrderBezierCurveSection(
                                                                p2: Offset(
                                                                    0, 100),
                                                                p3: Offset(
                                                                    0, 50),
                                                                p1: Offset(
                                                                    context
                                                                        .width,
                                                                    50),
                                                                p4: Offset(
                                                                    context
                                                                        .width,
                                                                    100),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Center(
                                                            child: Container(
                                                          height: 50,
                                                          width: Dimensions
                                                              .webMaxWidth,
                                                          padding:   EdgeInsets
                                                                  .symmetric(
                                                              horizontal: Dimensions
                                                                  .paddingSizeSmall),
                                                          child: InkWell(
                                                            onTap: () =>
                                                                Get.toNamed(
                                                                    RouteHelper
                                                                        .getSearchRoute()),
                                                            child: Container(
                                                              padding:   EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      Dimensions
                                                                          .paddingSizeSmall),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        Dimensions
                                                                            .radiusDefault),
                                                              ),
                                                              child: Row(
                                                                  children: [
                                                                    Icon(
                                                                      IconlyLight
                                                                          .search,
                                                                      size: 20,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .hintColor,
                                                                    ),
                                                                    const SizedBox(
                                                                        width: Dimensions
                                                                            .paddingSizeExtraSmall),
                                                                    Expanded(
                                                                        child:
                                                                            Text(
                                                                      Get.find<EQSplashControllerEquip>()
                                                                              .configModel!
                                                                              .moduleConfig!
                                                                              .module!
                                                                              .showRestaurantText!
                                                                          ? 'search_food_or_restaurant'
                                                                              .tr
                                                                          : 'search_item_or_store'
                                                                              .tr,
                                                                      style: robotoRegular
                                                                          .copyWith(
                                                                        fontSize:
                                                                            Dimensions.fontSizeSmall,
                                                                        color: Theme.of(context)
                                                                            .hintColor,
                                                                      ),
                                                                    )),
                                                                    Icon(
                                                                      IconlyLight
                                                                          .filter,
                                                                      size: 20,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .hintColor,
                                                                    ),
                                                                  ]),
                                                            ),
                                                          ),
                                                        )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                )
                                              ],
                                            ),
                                          ))
                                        : SizedBox(),
                                  ]),
                                ),
                                //               // Search Button

                                SliverToBoxAdapter(
                                  child: Center(
                                      child: SizedBox(
                                    width: Dimensions.webMaxWidth,
                                    child: !showMobileModule
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                                const BannerView(
                                                    isFeatured: false),
                                                const CategoryView(),
                                                const PopularStoreView(
                                                    isPopular: true,
                                                    isFeatured: false),
                                                const ItemCampaignView(),
                                                const PopularItemView(
                                                    isPopular: true),
                                                const PopularStoreView(
                                                    isPopular: false,
                                                    isFeatured: false),
                                                const PopularItemView(
                                                    isPopular: false),
                                                Padding(
                                                  padding:
                                                        EdgeInsets.fromLTRB(
                                                          10, 15, 0, 5),
                                                  child: Row(children: [
                                                    Expanded(
                                                        child: Text(
                                                      Get.find<EQSplashControllerEquip>()
                                                              .configModel!
                                                              .moduleConfig!
                                                              .module!
                                                              .showRestaurantText!
                                                          ? 'all_restaurants'.tr
                                                          : 'all_stores'.tr,
                                                      style: robotoMedium.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeLarge),
                                                    )),
                                                    const FilterView(),
                                                  ]),
                                                ),
                                                GetBuilder<EQStoreController>(
                                                    builder: (storeController) {
                                                  return PaginatedListView(
                                                    scrollController:
                                                        _scrollController,
                                                    totalSize: storeController
                                                                .storeModel !=
                                                            null
                                                        ? storeController
                                                            .storeModel!
                                                            .totalSize
                                                        : null,
                                                    offset: storeController
                                                                .storeModel !=
                                                            null
                                                        ? storeController
                                                            .storeModel!.offset
                                                        : null,
                                                    onPaginate: (int?
                                                            offset) async =>
                                                        await storeController
                                                            .getStoreList(
                                                                offset!, false),
                                                    itemView: ItemsView(
                                                      isStore: true,
                                                      items: null,
                                                      stores: storeController
                                                                  .storeModel !=
                                                              null
                                                          ? storeController
                                                              .storeModel!
                                                              .stores
                                                          : null,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: ResponsiveHelper
                                                                .isDesktop(
                                                                    context)
                                                            ? Dimensions
                                                                .paddingSizeExtraSmall
                                                            : Dimensions
                                                                .paddingSizeSmall,
                                                        vertical: ResponsiveHelper
                                                                .isDesktop(
                                                                    context)
                                                            ? Dimensions
                                                                .paddingSizeExtraSmall
                                                            : 0,
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ])
                                        : ModuleView(
                                            splashController: splashController),
                                  )),
                                ),
                              ],
                            ),
                ),
              ),
      );
    });
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}
