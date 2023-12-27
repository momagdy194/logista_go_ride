import 'package:customer/equipment/controller/search_controller.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/view/base/footer_view.dart';
import 'package:customer/equipment/view/base/item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemView extends StatelessWidget {
  final bool isItem;
  const ItemView({Key? key, required this.isItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<EQSearchingController>(builder: (searchController) {
        return SingleChildScrollView(
          child: FooterView(
            child: SizedBox(width: Dimensions.webMaxWidth, child: ItemsView(
              isStore: isItem, items: searchController.searchItemList, stores: searchController.searchStoreList,
            )),
          ),
        );
      }),
    );
  }
}
