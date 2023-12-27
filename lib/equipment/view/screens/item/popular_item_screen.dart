import 'package:customer/equipment/controller/item_controller.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/view/base/custom_app_bar.dart';
import 'package:customer/equipment/view/base/footer_view.dart';
import 'package:customer/equipment/view/base/item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/equipment/view/base/menu_drawer.dart';

class PopularItemScreen extends StatefulWidget {
  final bool isPopular;
  const PopularItemScreen({Key? key, required this.isPopular})
      : super(key: key);

  @override
  State<PopularItemScreen> createState() => _PopularItemScreenState();
}

class _PopularItemScreenState extends State<PopularItemScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    if (widget.isPopular) {
      Get.find<EQItemController>().getPopularItemList(
          true, Get.find<EQItemController>().popularType, false);
    } else {
      Get.find<EQItemController>().getReviewedItemList(
          true, Get.find<EQItemController>().reviewType, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EQItemController>(builder: (itemController) {
      return Scaffold(
        appBar: CustomAppBar(
          key: scaffoldKey,
          title: widget.isPopular
              ? 'popular_items_nearby'.tr
              : 'best_reviewed_item'.tr,
          showCart: true,
          type: widget.isPopular
              ? itemController.popularType
              : itemController.reviewType,
          onVegFilterTap: (String type) {
            if (widget.isPopular) {
              itemController.getPopularItemList(
                true,
                type,
                true,
              );
            } else {
              itemController.getReviewedItemList(
                true,
                type,
                true,
              );
            }
          },
          versionSearch: (value) {
            if (widget.isPopular) {
              print("getReviewedItemList222000");

              itemController.getPopularItemList(true, "all", true,
                  version_id: value["id"], year: value["year"]);
            } else {
              print("getReviewedItemList222");
              itemController.getReviewedItemList(true, "all", true,
                  version_id: value["id"], year: value["year"]);
            }
            // print(value);
          },

          // Get.find<CategoryController>().getCareVersionList(categoryID: widget.categoryID)
        ),
        endDrawer: const MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,
        body: Scrollbar(
            child: SingleChildScrollView(
                child: FooterView(
                    child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: ItemsView(
            isStore: false,
            stores: null,
            items: widget.isPopular
                ? itemController.popularItemList
                : itemController.reviewedItemList,
          ),
        )))),
      );
    });
  }
}
