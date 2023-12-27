import 'package:customer/equipment/controller/search_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/screens/search/widget/filter_widget.dart';
import 'package:customer/equipment/view/screens/search/widget/item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchResultWidget extends StatefulWidget {
  final String searchText;
  const SearchResultWidget({Key? key, required this.searchText}) : super(key: key);

  @override
  SearchResultWidgetState createState() => SearchResultWidgetState();
}

class SearchResultWidgetState extends State<SearchResultWidget> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      GetBuilder<EQSearchingController>(builder: (searchController) {
        bool isNull = true;
        int length = 0;
        if(searchController.isStore) {
          isNull = searchController.searchStoreList == null;
          if(!isNull) {
            length = searchController.searchStoreList!.length;
          }
        }else {
          isNull = searchController.searchItemList == null;
          if(!isNull) {
            length = searchController.searchItemList!.length;
          }
        }
        return isNull ? const SizedBox() : Center(child: SizedBox(width: Dimensions.webMaxWidth, child: Padding(
          padding:   EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Row(children: [
            Text(
              length.toString(),
              style: robotoBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
            ),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Expanded(child: Text(
              'results_found'.tr,
              style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
            )),
            widget.searchText.isNotEmpty ? InkWell(
              onTap: () {
                List<double?> prices = [];
                if(!Get.find<EQSearchingController>().isStore) {
                  for (var product in Get.find<EQSearchingController>().allItemList!) {
                    prices.add(product.price);
                  }
                  prices.sort();
                }
                double? maxValue = prices.isNotEmpty ? prices[prices.length-1] : 1000;
                Get.dialog(FilterWidget(maxValue: maxValue, isStore: Get.find<EQSearchingController>().isStore));
              },
              child: const Icon(Icons.filter_list),
            ) : const SizedBox(),
          ]),
        )));
      }),

      Center(child: Container(
        width: Dimensions.webMaxWidth,
        color: Theme.of(context).cardColor,
        child: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          indicatorWeight: 3,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Theme.of(context).disabledColor,
          unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
          labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
          tabs: [
            Tab(text: 'item'.tr),
            Tab(text: Get.find<EQSplashControllerEquip>().configModel!.moduleConfig!.module!.showRestaurantText!
                ? 'restaurants'.tr : 'stores'.tr),
          ],
        ),
      )),

      Expanded(child: NotificationListener(
        onNotification: (dynamic scrollNotification) {
          if (scrollNotification is ScrollEndNotification) {
            Get.find<EQSearchingController>().setStore(_tabController!.index == 1);
            Get.find<EQSearchingController>().searchData(widget.searchText, false);
          }
          return false;
        },
        child: TabBarView(
          controller: _tabController,
          children: const [
            ItemView(isItem: false),
            ItemView(isItem: true),
          ],
        ),
      )),

    ]);
  }
}
