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
import '../home/subcat_screen.dart';

class CategoryItemScreen extends StatefulWidget {
  final String? categoryID;
  final String categoryName;
  final String index;

  const CategoryItemScreen(
      {Key? key,
      required this.categoryID,
      required this.categoryName,
      required this.index})
      : super(key: key);

  @override
  CategoryItemScreenState createState() => CategoryItemScreenState();
}

class CategoryItemScreenState extends State<CategoryItemScreen>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final ScrollController storeScrollController = ScrollController();
  TabController? _tabController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    // Get.find<CategoryController>().getSubCategoryList(widget.categoryID);
    // Get.find<CategoryController>()
    //     .setSubCategoryIndex(thesubIndex, widget.categoryID);
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
                  actions: [
                    IconButton(
                      onPressed: () => catController.toggleSearch(),
                      icon: Icon(
                        catController.isSearching
                            ? Icons.close_sharp
                            : Icons.search,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
                      icon: CartWidget(
                          color: Theme.of(context).primaryColor, size: 25),
                    ),
                    VegFilterWidget(
                        type: catController.type,
                        fromAppBar: true,
                        onSelected: (String type) {
                          if (catController.isSearching) {
                            catController.searchData(
                              catController.subCategoryIndex == 0
                                  ? widget.categoryID
                                  : catController
                                      .subCategoryList![
                                          catController.subCategoryIndex]
                                      .id
                                      .toString(),
                              '1',
                              type,
                            );
                          } else {
                            if (catController.isStore) {
                              catController.getCategoryStoreList(
                                catController.subCategoryIndex == 0
                                    ? widget.categoryID
                                    : catController
                                        .subCategoryList![
                                            catController.subCategoryIndex]
                                        .id
                                        .toString(),
                                1,
                                type,
                                true,
                              );
                            } else {
                              catController.getCategoryItemList(
                                catController.subCategoryIndex == 0
                                    ? widget.categoryID
                                    : catController
                                        .subCategoryList![
                                            catController.subCategoryIndex]
                                        .id
                                        .toString(),
                                1,
                                type,
                                true,
                              );
                            }
                          }
                        }),
                    // if (versionSearch != null)
                    InkWell(
                      onTap: () {
                        Get.dialog(Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          backgroundColor: Colors.white,
                          child: Container(
                            height: Get.height / 2,
                            child: Center(
                              child: Padding(
                                padding:   EdgeInsets.all(15.0),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("تصفية قطع الغيار"),
                                            InkWell(
                                                onTap: () => Get.back(),
                                                child: const Icon(
                                                  IconlyLight.close_square,
                                                  color: Colors.red,
                                                ))
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      DropdownSearch<String>(
                                        dropdownButtonProps: DropdownButtonProps(
                                            icon: Icon(Icons
                                                .keyboard_arrow_down_sharp)),
                                        // filterFn: (user, filter) =>
                                        //     user,
                                        compareFn: (item1, item2) =>
                                            item1 == item2,
                                        items: [
                                          "2023",
                                          "2022",
                                          "2021",
                                          "2020",
                                          "2019",
                                          "2018",
                                          "2017",
                                          "2016",
                                          "2015",
                                          "2014",
                                          "2013",
                                          "2012",
                                          "2011",
                                          "2010",
                                          "2009",
                                          "2008",
                                          "2007",
                                          "2006",
                                          "2005",
                                          "2004",
                                          "2003",
                                          "2002",
                                          "2001",
                                          "2000",
                                        ],
                                        onChanged: (data) {
                                          careYeat = data;
                                        },

                                        dropdownDecoratorProps:
                                            DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            hintText: "سنة الصنع",
                                            filled: true,
                                            fillColor: Theme.of(context)
                                                .inputDecorationTheme
                                                .fillColor,
                                            border: InputBorder.none,
                                          ),
                                        ),

                                        popupProps: PopupProps.dialog(
                                          dialogProps: const DialogProps(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15)))),
                                          itemBuilder: (context, item,
                                                  isSelected) =>
                                              Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                                  // osAddSymmetricPaddingSpace(
                                                  //     vertical: 5,
                                                  //     horizontal: 10),
                                                  child: Row(
                                                    children: [
                                                      isSelected
                                                          ? Icon(
                                                              Icons.circle,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              size: 20,
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .circle_outlined,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              size: 20,
                                                            ),
                                                      SizedBox(width: 10),
                                                      Flexible(
                                                          child: Text(
                                                        item ?? "",
                                                        maxLines: 1,
                                                      )),
                                                    ],
                                                  )),
                                          showSearchBox: true,
                                          showSelectedItems: true,
                                          searchDelay: Duration.zero,
                                          title: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("البجث في الاصدارات"),
                                                InkWell(
                                                    onTap: () => Get.back(),
                                                    child: const Icon(
                                                      IconlyLight.close_square,
                                                      color: Colors.red,
                                                    ))
                                              ],
                                            ),
                                          ),
                                          searchFieldProps: TextFieldProps(
                                            decoration: InputDecoration(
                                                // fillColor: AppColors.lightGrey.withOpacity(.3),
                                                errorMaxLines: 1,
                                                prefixIcon: Icon(Icons.search),
                                                // suffixIcon:  Icon(Icons.close),
                                                // label:Text( label ),
                                                hintText: "Search".tr,
                                                // hintStyle: Constants.isEnglishLang
                                                //     ? GoogleFonts.poppins(
                                                //         fontSize: 14,
                                                //         color: const Color(0xffB4B4B4),
                                                //       )
                                                //     : const TextStyle(
                                                //         fontSize: 14,
                                                //         color: const Color(0xffB4B4B4),
                                                //       ),

                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                    color: AppColors.accent,
                                                    width: 0.5,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                    // color: AppColors.lightGrey,
                                                    width: 0.5,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: const BorderSide(
                                                    // color: AppColors.lightGrey,
                                                    width: 0.5,
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      DropdownSearch<CarVersion>(
                                        dropdownButtonProps: DropdownButtonProps(
                                            icon: Icon(Icons
                                                .keyboard_arrow_down_sharp)),
                                        // filterFn: (user, filter) =>
                                        //     user,
                                        compareFn: (item1, item2) =>
                                            item1.id == item2.id,
                                        asyncItems: (String filter) =>
                                            Get.find<EQCategoryController>()
                                                .getCareVersionList(
                                                    categoryID:
                                                        widget.categoryID),
                                        itemAsString: (CarVersion u) =>
                                            u.name ?? "",
                                        onChanged: (CarVersion? data) {
                                          careVersionId = data?.id.toString();
                                        },
                                        dropdownDecoratorProps:
                                            DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            hintText: "الاصدارات",
                                            filled: true,
                                            fillColor: Theme.of(context)
                                                .inputDecorationTheme
                                                .fillColor,
                                            border: InputBorder.none,
                                          ),
                                        ),

                                        popupProps: PopupProps.dialog(
                                          dialogProps: const DialogProps(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15)))),
                                          itemBuilder: (context, item,
                                                  isSelected) =>
                                              Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                                  // osAddSymmetricPaddingSpace(
                                                  //     vertical: 5,
                                                  //     horizontal: 10),
                                                  child: Row(
                                                    children: [
                                                      isSelected
                                                          ? Icon(
                                                              Icons.circle,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              size: 20,
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .circle_outlined,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              size: 20,
                                                            ),
                                                      SizedBox(width: 10),
                                                      Flexible(
                                                          child: Text(
                                                        item.name ?? "",
                                                        maxLines: 1,
                                                      )),
                                                    ],
                                                  )),
                                          showSearchBox: true,
                                          showSelectedItems: true,
                                          searchDelay: Duration.zero,
                                          title: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("البجث في سنة الصنع"),
                                                InkWell(
                                                    onTap: () => Get.back(),
                                                    child: const Icon(
                                                      IconlyLight.close_square,
                                                      color: Colors.red,
                                                    ))
                                              ],
                                            ),
                                          ),
                                          searchFieldProps: TextFieldProps(
                                            decoration: InputDecoration(
                                                errorMaxLines: 1,
                                                prefixIcon: Icon(Icons.search),
                                                hintText: "Search".tr,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                    color: AppColors.accent,
                                                    width: 0.5,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                    // color: AppColors.lightGrey,
                                                    width: 0.5,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: const BorderSide(
                                                    // color: AppColors.lightGrey,
                                                    width: 0.5,
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      CustomButton(
                                        buttonText: "Search".tr,
                                        onPressed: () {
// careVersionId
// careYeat
                                          // Get.find<CategoryController>()
                                          //     .getSubCategoryList(
                                          //         widget.categoryID);

                                          catController.getCategoryItemList(
                                              catController.subCategoryIndex ==
                                                      0
                                                  ? widget.categoryID
                                                  : catController
                                                      .subCategoryList![
                                                          catController
                                                              .subCategoryIndex]
                                                      .id
                                                      .toString(),
                                              1,
                                              "all",
                                              true,
                                              version_id: careVersionId,
                                              year: careYeat);
                                          print(
                                              "careVersionIdcareVersionIdcareVersionId ${careVersionId.runtimeType}");
                                          setState(() {});

                                          // versionSearch!({
                                          //   "id": careVersionId,
                                          //   "year": careYeat,
                                          // });
                                          Get.back();
                                        },
                                      ),
                                      Spacer(),
                                    ]),
                              ),
                            ),
                          ),
                        ));
                      },
                      child: Padding(
                        padding:   EdgeInsets.all(8.0),
                        child: Icon(
                          IconlyLight.filter,
                          color: Theme.of(Get.context!).primaryColor,
                        ),
                      ),
                    )
                  ],
                )) as PreferredSizeWidget?,
          endDrawer: const MenuDrawer(),
          endDrawerEnableOpenDragGesture: false,
          body: Center(
              child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: Column(children: [
              (catController.subCategoryList != null &&
                      !catController.isSearching)
                  ? Center(
                      child: Container(
                      height: 40,
                      width: Dimensions.webMaxWidth,
                      color: Theme.of(context).cardColor,
                      padding:   EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeExtraSmall),
                      child: ListView.builder(
                        key: scaffoldKey,
                        scrollDirection: Axis.horizontal,
                        itemCount: catController.subCategoryList!.length,
                        padding:   EdgeInsets.only(
                            left: Dimensions.paddingSizeSmall),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () => catController.setSubCategoryIndex(
                                index, widget.categoryID),
                            child: Container(
                              padding:   EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeSmall,
                                  vertical: Dimensions.paddingSizeExtraSmall),
                              margin:   EdgeInsets.only(
                                  right: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSmall),
                                color: index == catController.subCategoryIndex
                                    ? Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1)
                                    : Colors.transparent,
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
                                                  Dimensions.fontSizeSmall,
                                              color: Theme.of(context)
                                                  .primaryColor)
                                          : robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall),
                                    ),
                                  ]),
                            ),
                          );
                        },
                      ),
                    ))
                  : const SizedBox(),
              Center(
                  child: Container(
                width: Dimensions.webMaxWidth,
                color: Theme.of(context).cardColor,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Theme.of(context).primaryColor,
                  indicatorWeight: 3,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Theme.of(context).disabledColor,
                  unselectedLabelStyle: robotoRegular.copyWith(
                      color: Theme.of(context).disabledColor,
                      fontSize: Dimensions.fontSizeSmall),
                  labelStyle: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).primaryColor),
                  tabs: [
                    Tab(text: 'item'.tr),
                    Tab(
                        text: Get.find<EQSplashControllerEquip>()
                                .configModel!
                                .moduleConfig!
                                .module!
                                .showRestaurantText!
                            ? 'restaurants'.tr
                            : 'stores'.tr),
                  ],
                ),
              )),
              Expanded(
                  child: NotificationListener(
                onNotification: (dynamic scrollNotification) {
                  if (scrollNotification is ScrollEndNotification) {
                    if ((_tabController!.index == 1 &&
                            !catController.isStore) ||
                        _tabController!.index == 0 && catController.isStore) {
                      catController.setRestaurant(_tabController!.index == 1);
                      if (catController.isSearching) {
                        catController.searchData(
                          catController.searchText,
                          catController.subCategoryIndex == 0
                              ? widget.categoryID
                              : catController
                                  .subCategoryList![
                                      catController.subCategoryIndex]
                                  .id
                                  .toString(),
                          catController.type,
                        );
                      } else {
                        if (_tabController!.index == 1) {
                          catController.getCategoryStoreList(
                            catController.subCategoryIndex == 0
                                ? widget.categoryID
                                : catController
                                    .subCategoryList![
                                        catController.subCategoryIndex]
                                    .id
                                    .toString(),
                            1,
                            catController.type,
                            false,
                          );
                        } else {
                          catController.getCategoryItemList(
                            catController.subCategoryIndex == 0
                                ? widget.categoryID
                                : catController
                                    .subCategoryList![
                                        catController.subCategoryIndex]
                                    .id
                                    .toString(),
                            1,
                            catController.type,
                            false,
                          );
                        }
                      }
                    }
                  }
                  return false;
                },
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      controller: scrollController,
                      child: ItemsView(
                        isStore: false,
                        items: item,
                        stores: null,
                        noDataText: 'no_category_item_found'.tr,
                      ),
                    ),
                    SingleChildScrollView(
                      controller: storeScrollController,
                      child: ItemsView(
                        isStore: true,
                        items: null,
                        stores: stores,
                        noDataText: Get.find<EQSplashControllerEquip>()
                                .configModel!
                                .moduleConfig!
                                .module!
                                .showRestaurantText!
                            ? 'no_category_restaurant_found'.tr
                            : 'no_category_store_found'.tr,
                      ),
                    ),
                  ],
                ),
              )),
              catController.isLoading
                  ? Center(
                      child: Padding(
                      padding:
                            EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor)),
                    ))
                  : const SizedBox(),
            ]),
          )),
        ),
      );
    });
  }
}
