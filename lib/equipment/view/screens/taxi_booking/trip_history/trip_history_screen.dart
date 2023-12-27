import 'package:customer/equipment/controller/auth_controller.dart';
import 'package:customer/equipment/controller/order_controller.dart';
import 'package:customer/equipment/controller/rider_controller.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/custom_app_bar.dart';
import 'package:customer/equipment/view/base/menu_drawer.dart';
import 'package:customer/equipment/view/base/not_logged_in_screen.dart';
import 'package:customer/equipment/view/screens/order/widget/order_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/equipment/view/screens/taxi_booking/trip_history/widget/trip_history_list.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({Key? key}) : super(key: key);

  @override
  TripHistoryScreenState createState() => TripHistoryScreenState();
}

class TripHistoryScreenState extends State<TripHistoryScreen> with TickerProviderStateMixin {
  TabController? _tabController;
  bool _isLoggedIn = Get.find<EQAuthController>().isLoggedIn();

  @override
  void initState() {
    super.initState();

    initCall();
  }

  initCall(){
    if(_isLoggedIn) {
      _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
      Get.find<EQRiderController>().getRunningTripList(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    _isLoggedIn = Get.find<EQAuthController>().isLoggedIn();
    return Scaffold(
      appBar: CustomAppBar(title: 'trip_history'.tr),
      endDrawer: const MenuDrawer(), endDrawerEnableOpenDragGesture: false,
      body: _isLoggedIn ? GetBuilder<EQOrderController>(
        builder: (orderController) {
          return Column(children: [

            Center(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: TabBar(
                  padding:   EdgeInsets.symmetric(horizontal: 30),
                  controller: _tabController,
                  indicatorColor: Theme.of(context).primaryColor,
                  indicatorWeight: 3,
                  indicatorPadding:   EdgeInsets.only(bottom: 10),
                  indicatorSize: TabBarIndicatorSize.label ,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Theme.of(context).textTheme.bodyLarge!.color,
                  unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeDefault),
                  labelStyle: robotoBold.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: Dimensions.fontSizeDefault,
                  ),
                  tabs: [
                    Tab(text: 'ongoing'.tr),
                    Tab(text: 'past_trips'.tr),
                    Tab(text: 'canceled'.tr),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault,),
            Expanded(child: TabBarView(
              controller: _tabController,
              children: const [
                TripHistoryList(type: 'onGoing'),
                OrderView(isRunning: false),
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
