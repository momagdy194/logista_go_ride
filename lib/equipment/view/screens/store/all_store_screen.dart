import 'package:customer/equipment/controller/store_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/util/app_constants.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/view/base/custom_app_bar.dart';
import 'package:customer/equipment/view/base/footer_view.dart';
import 'package:customer/equipment/view/base/item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/equipment/view/base/menu_drawer.dart';

class AllStoreScreen extends StatefulWidget {
  final bool isPopular;
  final bool isFeatured;
  const AllStoreScreen({Key? key, required this.isPopular, required this.isFeatured}) : super(key: key);

  @override
  State<AllStoreScreen> createState() => _AllStoreScreenState();
}

class _AllStoreScreenState extends State<AllStoreScreen> {

  @override
  void initState() {
    super.initState();

    if(widget.isFeatured) {
      Get.find<EQStoreController>().getFeaturedStoreList();
    }else if(widget.isPopular) {
      Get.find<EQStoreController>().getPopularStoreList(false, 'all', false);
    }else {
      Get.find<EQStoreController>().getLatestStoreList(false, 'all', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EQStoreController>(
      builder: (storeController) {
        return Scaffold(
          appBar: CustomAppBar(
            title: widget.isFeatured ? 'featured_stores'.tr :  widget.isPopular
              ? Get.find<EQSplashControllerEquip>().configModel!.moduleConfig!.module!.showRestaurantText!
              ? 'popular_restaurants'.tr : 'popular_stores'.tr : '${'new_on'.tr} ${AppConstants.appName}',
            type: widget.isFeatured ? null : storeController.type,
            onVegFilterTap: (String type) {
              if(widget.isPopular) {
                Get.find<EQStoreController>().getPopularStoreList(true, type, true);
              }else {
                Get.find<EQStoreController>().getLatestStoreList(true, type, true);
              }
            },
          ),
          endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
          body: RefreshIndicator(
            onRefresh: () async {
              if(widget.isFeatured) {
                await Get.find<EQStoreController>().getFeaturedStoreList();
              }else if(widget.isPopular) {
                await Get.find<EQStoreController>().getPopularStoreList(
                  true, Get.find<EQStoreController>().type, false,
                );
              }else {
                await Get.find<EQStoreController>().getLatestStoreList(
                  true, Get.find<EQStoreController>().type, false,
                );
              }
            },
            child: Scrollbar(child: SingleChildScrollView(child: FooterView(child: SizedBox(
              width: Dimensions.webMaxWidth,
              child: GetBuilder<EQStoreController>(builder: (storeController) {
                return ItemsView(
                  isStore: true, items: null, isFeatured: widget.isFeatured,
                  noDataText: widget.isFeatured ? 'no_store_available'.tr : Get.find<EQSplashControllerEquip>().configModel!.moduleConfig!
                      .module!.showRestaurantText! ? 'no_restaurant_available'.tr : 'no_store_available'.tr,
                  stores: widget.isFeatured ? storeController.featuredStoreList : widget.isPopular ? storeController.popularStoreList
                      : storeController.latestStoreList,
                );
              }),
            )))),
          ),
        );
      }
    );
  }
}
