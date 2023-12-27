import 'package:customer/equipment/controller/auth_controller.dart';
import 'package:customer/equipment/controller/order_controller.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/custom_app_bar.dart';
import 'package:customer/equipment/view/base/menu_drawer.dart';
import 'package:customer/equipment/view/base/not_logged_in_screen.dart';
import 'package:customer/equipment/view/screens/order/widget/order_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  OrderScreenState createState() => OrderScreenState();
}

class OrderScreenState extends State<OrderScreen> with TickerProviderStateMixin {
  TabController? _tabController;
  bool _isLoggedIn = Get.find<EQAuthController>().isLoggedIn();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    initCall();
  }

  void initCall(){
    if(Get.find<EQAuthController>().isLoggedIn()) {
      Get.find<EQOrderController>().getRunningOrders(1);
      Get.find<EQOrderController>().getHistoryOrders(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    _isLoggedIn = Get.find<EQAuthController>().isLoggedIn();
    return Scaffold(
      appBar: CustomAppBar(title: 'my_orders'.tr, backButton: ResponsiveHelper.isDesktop(context)),
      endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
      body: _isLoggedIn ? GetBuilder<EQOrderController>(
        builder: (orderController) {
          return Column(children: [

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
                  unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                  labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                  tabs: [
                    Tab(text: 'running'.tr),
                    Tab(text: 'history'.tr),
                  ],
                ),
              ),
            ),

            Expanded(child: TabBarView(
              controller: _tabController,
              children: const [
                OrderView(isRunning: true),
                OrderView(isRunning: false),
              ],
            )),

          ]);
        },
      ) : NotLoggedInScreen(callBack: (value){
        initCall();
        setState(() {});
      }),
    );
  }
}
