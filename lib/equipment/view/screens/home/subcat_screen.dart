import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:iconly/iconly.dart';
import 'package:customer/equipment/controller/category_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/data/model/response/care_version.dart';
import 'package:customer/equipment/data/model/response/item_model.dart';
import 'package:customer/equipment/data/model/response/store_model.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/cart_widget.dart';
import 'package:customer/equipment/view/base/item_view.dart';
import 'package:customer/equipment/view/base/menu_drawer.dart';
import 'package:customer/equipment/view/base/veg_filter_widget.dart';
import 'package:customer/equipment/view/base/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base/colors.dart';
import '../../base/custom_button.dart';

int thesubIndex = 0;

class subCategoryItemScreen extends StatefulWidget {
  final String? categoryID;
  final String categoryName;

  const subCategoryItemScreen(
      {Key? key, required this.categoryID, required this.categoryName})
      : super(key: key);

  @override
  subCategoryItemScreenState createState() => subCategoryItemScreenState();
}

class subCategoryItemScreenState extends State<subCategoryItemScreen>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final ScrollController storeScrollController = ScrollController();
  TabController? _tabController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    Get.find<EQCategoryController>().getSubCategoryList(widget.categoryID);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          Get.find<EQCategoryController>().categoryItemList != null &&
          !Get.find<EQCategoryController>().isLoading) {
        int pageSize = (Get.find<EQCategoryController>().pageSize! / 10).ceil();
        if (Get.find<EQCategoryController>().offset < pageSize) {
          if (kDebugMode) {
            print('end of the page');
          }
          Get.find<EQCategoryController>().showBottomLoader();
          Get.find<EQCategoryController>().getCategoryItemList(
            Get.find<EQCategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<EQCategoryController>()
                    .subCategoryList![
                        Get.find<EQCategoryController>().subCategoryIndex]
                    .id
                    .toString(),
            Get.find<EQCategoryController>().offset + 1,
            Get.find<EQCategoryController>().type,
            false,
          );
        }
      }
    });
    storeScrollController.addListener(() {
      if (storeScrollController.position.pixels ==
              storeScrollController.position.maxScrollExtent &&
          Get.find<EQCategoryController>().categoryStoreList != null &&
          !Get.find<EQCategoryController>().isLoading) {
        int pageSize =
            (Get.find<EQCategoryController>().restPageSize! / 10).ceil();
        if (Get.find<EQCategoryController>().offset < pageSize) {
          if (kDebugMode) {
            print('end of the page');
          }
          Get.find<EQCategoryController>().showBottomLoader();
          Get.find<EQCategoryController>().getCategoryStoreList(
            Get.find<EQCategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<EQCategoryController>()
                    .subCategoryList![
                        Get.find<EQCategoryController>().subCategoryIndex]
                    .id
                    .toString(),
            Get.find<EQCategoryController>().offset + 1,
            Get.find<EQCategoryController>().type,
            false,
          );
        }
      }
    });
  }

  String? careVersionId;
  String? careYeat;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EQCategoryController>(builder: (catController) {
      List<Item>? item;
      List<Store>? stores;
      if (catController.isSearching
          ? catController.searchItemList != null
          : catController.categoryItemList != null) {
        item = [];
        if (catController.isSearching) {
          item.addAll(catController.searchItemList!);
        } else {
          item.addAll(catController.categoryItemList!);
        }
      }
      if (catController.isSearching
          ? catController.searchStoreList != null
          : catController.categoryStoreList != null) {
        stores = [];
        if (catController.isSearching) {
          stores.addAll(catController.searchStoreList!);
        } else {
          stores.addAll(catController.categoryStoreList!);
        }
      }

      return WillPopScope(
        onWillPop: () async {
          if (catController.isSearching) {
            catController.toggleSearch();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          appBar: (ResponsiveHelper.isDesktop(context)
              ? const WebMenuBar()
              : AppBar(
                  title: catController.isSearching
                      ? TextField(
                          autofocus: true,
                          textInputAction: TextInputAction.search,
                          decoration: const InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                          ),
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeLarge),
                          onSubmitted: (String query) {
                            catController.searchData(
                              query,
                              catController.subCategoryIndex == 0
                                  ? widget.categoryID
                                  : catController
                                      .subCategoryList![
                                          catController.subCategoryIndex]
                                      .id
                                      .toString(),
                              catController.type,
                            );
                          })
                      : Text(widget.categoryName,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          )),
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    onPressed: () {
                      if (catController.isSearching) {
                        catController.toggleSearch();
                      } else {
                        Get.back();
                      }
                    },
                  ),
                  backgroundColor: Theme.of(context).cardColor,
                  elevation: 0,
                )) as PreferredSizeWidget?,
          endDrawer: const MenuDrawer(),
          endDrawerEnableOpenDragGesture: false,
          body: Center(
              child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: (catController.subCategoryList != null &&
                    !catController.isSearching)
                ? Center(
                    child: Container(
                    // height: 40,
                    width: Dimensions.webMaxWidth,
                    color: Theme.of(context).cardColor,
                    padding:   EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeExtraSmall),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      key: scaffoldKey,
                      // scrollDirection: Axis.horizontal,
                      itemCount: catController.subCategoryList!.length,
                      padding:   EdgeInsets.only(
                          left: Dimensions.paddingSizeSmall),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Get.toNamed(RouteHelper.getCategoryItemRoute(
                                int.parse(widget.categoryID ?? "0"),
                                widget.categoryName));

                            catController.setSubCategoryIndex(
                                index, widget.categoryID);
                          },
                          child: Padding(
                            padding:   EdgeInsets.all(8.0),
                            child: Container(
                              padding:   EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeSmall,
                                  vertical: Dimensions.paddingSizeExtraSmall),
                              margin:   EdgeInsets.only(
                                  right: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSmall),
                                color: AppColors.light,
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      catController
                                          .subCategoryList![index].name!,
                                      style: index ==
                                              catController.subCategoryIndex
                                          ? robotoMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeDefault,
                                              color: Theme.of(context)
                                                  .primaryColor)
                                          : robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeDefault),
                                    ),
                                  ]),
                            ),
                          ),
                        );
                      },
                    ),
                  ))
                : const SizedBox(),
          )),
        ),
      );
    });
  }
}
