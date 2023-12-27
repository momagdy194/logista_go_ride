import 'package:customer/equipment/controller/wishlist_controller.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/view/base/footer_view.dart';
import 'package:customer/equipment/view/base/item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavItemView extends StatelessWidget {
  final bool isStore;
  final bool isSearch;
  const FavItemView({Key? key, required this.isStore, this.isSearch = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<EQWishListController>(builder: (wishController) {
        return RefreshIndicator(
          onRefresh: () async {
            await wishController.getWishList();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: FooterView(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: ItemsView(
                  isStore: isStore, items: wishController.wishItemList, stores: wishController.wishStoreList,
                  noDataText: 'no_wish_data_found'.tr, isFeatured: true,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
