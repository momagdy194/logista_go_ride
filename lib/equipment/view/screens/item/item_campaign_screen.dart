import 'package:customer/equipment/controller/campaign_controller.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/view/base/custom_app_bar.dart';
import 'package:customer/equipment/view/base/footer_view.dart';
import 'package:customer/equipment/view/base/item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/equipment/view/base/menu_drawer.dart';

class ItemCampaignScreen extends StatefulWidget {
  const ItemCampaignScreen({Key? key}) : super(key: key);

  @override
  State<ItemCampaignScreen> createState() => _ItemCampaignScreenState();
}

class _ItemCampaignScreenState extends State<ItemCampaignScreen> {

  @override
  void initState() {
    super.initState();

    Get.find<EQCampaignController>().getItemCampaignList(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'campaigns'.tr),
      endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
      body: Scrollbar(child: SingleChildScrollView(child: FooterView(child: SizedBox(
        width: Dimensions.webMaxWidth,
        child: GetBuilder<EQCampaignController>(builder: (campController) {
          return ItemsView(
            isStore: false, items: campController.itemCampaignList, stores: null,
            isCampaign: true, noDataText: 'no_campaign_found'.tr,
          );
        }),
      )))),
    );
  }
}
