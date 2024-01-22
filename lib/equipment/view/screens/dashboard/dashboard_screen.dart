import 'dart:async';

import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:iconly/iconly.dart';
import 'package:customer/equipment/controller/auth_controller.dart';
import 'package:customer/equipment/controller/location_controller.dart';
import 'package:customer/equipment/controller/order_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/data/model/response/order_model.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/view/base/cart_widget.dart';
import 'package:customer/equipment/view/base/custom_dialog.dart';
import 'package:customer/equipment/view/screens/cart/cart_screen.dart';
import 'package:customer/equipment/view/screens/checkout/widget/congratulation_dialogue.dart';
import 'package:customer/equipment/view/screens/dashboard/widget/address_bottom_sheet.dart';
import 'package:customer/equipment/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:customer/equipment/view/screens/favourite/favourite_screen.dart';
import 'package:customer/equipment/view/screens/home/home_screen.dart';
import 'package:customer/equipment/view/screens/menu/menu_screen_new.dart';
import 'package:customer/equipment/view/screens/order/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/cart_controller.dart';
import '../../base/colors.dart';
import 'widget/running_order_view_widget.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  final bool fromSplash;
  const DashboardScreen(
      {Key? key, required this.pageIndex, this.fromSplash = false})
      : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = GetPlatform.isWeb ? true : false;

  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();
  // final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();

  // void _openEndDrawer() {
  //   _drawerKey.currentState!.openEndDrawer();
  // }

  // void _closeEndDrawer() {
  //   Navigator.of(context).pop();
  // }

  late bool _isLogin;
  bool active = false;

  @override
  void initState() {
    super.initState();

    _isLogin = Get.find<EQAuthController>().isLoggedIn();

    if (_isLogin) {
      if (Get.find<EQSplashControllerEquip>().configModel!.loyaltyPointStatus ==
              1 &&
          Get.find<EQAuthController>().getEarningPint().isNotEmpty &&
          !ResponsiveHelper.isDesktop(Get.context)) {
        Future.delayed(const Duration(seconds: 1),
            () => showAnimatedDialog(context, const CongratulationDialogue()));
      }
      suggestAddressBottomSheet();
      Get.find<EQOrderController>().getRunningOrders(1);
    }

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      const HomeScreen(),
      const FavouriteScreen(),
      // const CartScreen(fromNav: true),
      const CartScreen(fromNav: true),
      const OrderScreen(),
      const MenuScreenNew()
    ];

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
  }

  Future<void> suggestAddressBottomSheet() async {
    active = await Get.find<EQLocationController>().checkLocationActive();
    if (widget.fromSplash &&
        Get.find<EQLocationController>().showLocationSuggestion &&
        active) {
      Future.delayed(const Duration(seconds: 1), () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (con) => const AddressBottomSheet(),
        ).then((value) {
          Get.find<EQLocationController>().hideSuggestedLocation();
          setState(() {});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EQOrderController>(builder: (orderController) {
      List<OrderModel> runningOrder = orderController.runningOrderModel != null
          ? orderController.runningOrderModel!.orders!
          : [];

      List<OrderModel> reversOrder = List.from(runningOrder.reversed);

      return Scaffold(
        key: _scaffoldKey,

        // endDrawer: const MenuScreenNew(),

        // floatingActionButton: ResponsiveHelper.isDesktop(context) ? null : (widget.fromSplash && Get.find<LocationController>().showLocationSuggestion && active) ? null
        //     : (orderController.showBottomSheet && orderController.runningOrderModel != null && orderController.runningOrderModel!.orders!.isNotEmpty)
        //     ? const SizedBox() : FloatingActionButton(
        //       elevation: 5,
        //       backgroundColor: _pageIndex == 2 ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
        //       onPressed: () {
        //           // _setPage(2);
        //         Get.toNamed(RouteHelper.getCartRoute());
        //       },
        //       child: CartWidget(color: _pageIndex == 2 ? Theme.of(context).cardColor : Theme.of(context).disabledColor, size: 30),
        //     ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        bottomNavigationBar: ResponsiveHelper.isDesktop(context)
            ? const SizedBox()
            : (widget.fromSplash &&
                    Get.find<EQLocationController>().showLocationSuggestion &&
                    active)
                ? const SizedBox()
                : (orderController.showBottomSheet &&
                        orderController.runningOrderModel != null &&
                        orderController.runningOrderModel!.orders!.isNotEmpty)
                    ? const SizedBox()
                    : SnakeNavigationBar.color(
// snakeShape: SnakeShape.indicator,
                        elevation: 15,
                        currentIndex: _pageIndex,
                        onTap: _setPage,
                        // backgroundColor: AppColors.primary,
                        shadowColor: Colors.black87,
                        unselectedItemColor: Theme.of(context).primaryColor,
// selectedItemColor: AppColors.white,
// unselectedItemColor: AppColors.grey2,
                        showSelectedLabels: true,
                        snakeViewColor: Theme.of(context).primaryColor,
                        showUnselectedLabels: true,
                        // selectedLabelStyle: TextStyle(color: AppColors.white,fontWeight: FontWeight.bold),
                        // unselectedLabelStyle: TextStyle(color: AppColors.white,fontWeight: FontWeight.bold),
                        items: [
                          BottomNavigationBarItem(icon: Icon(IconlyLight.home)),
                          BottomNavigationBarItem(
                              icon: Icon(IconlyLight.heart)),
                          // const Expanded(child: SizedBox()),
                          BottomNavigationBarItem(
                              icon: Stack(clipBehavior: Clip.none, children: [
                            Icon(
                              IconlyLight.buy,
                            ),
                            GetBuilder<EQCartController>(
                                builder: (cartController) {
                              return cartController.cartList.isNotEmpty
                                  ? Positioned(
                                      top: -5,
                                      right: -5,
                                      child: Container(
                                        height: 10,
                                        width: 10,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context).primaryColor,
                                          border: Border.all(
                                              width: 0.7,
                                              color:
                                                  Theme.of(context).cardColor),
                                        ),
                                        child: Text(
                                          cartController.cartList.length
                                              .toString(),
                                          // style: robotoRegular.copyWith(
                                          //   fontSize: size < 20 ? size/3 : size/3.8,
                                          //   color: fromStore ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                                          // ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox();
                            }),
                          ])),
                          BottomNavigationBarItem(
                              icon: Icon(
                            IconlyLight.bag,
                          )),
                          BottomNavigationBarItem(
                              icon: Icon(
                            IconlyLight.setting,
                          )),
                          // BottomNavItem(iconData: Icons.menu, isSelected: _pageIndex == 4, onTap: () => _openEndDrawer()),
                          // BottomNavItem(iconData: Icons.menu, isSelected: _pageIndex == 4, onTap: () {
                          //   Get.bottomSheet(const MenuScreen(), backgroundColor: Colors.transparent, isScrollControlled: true);
                          // }),
                        ],
                      ),
        // BottomAppBar(
        //       elevation: 5,
        //       notchMargin: 5,
        //       clipBehavior: Clip.antiAlias,
        //       shape: const CircularNotchedRectangle(),
        //
        //       child: Padding(
        //         padding:   EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        //         child:
        //
        //
        //
        //
        //
        //         Row(children: [
        //           BottomNavItem(iconData: Icons.home, isSelected: _pageIndex == 0, onTap: () => _setPage(0)),
        //           BottomNavItem(iconData: Icons.favorite, isSelected: _pageIndex == 1, onTap: () => _setPage(1)),
        //           const Expanded(child: SizedBox()),
        //           BottomNavItem(iconData: Icons.shopping_bag, isSelected: _pageIndex == 3, onTap: () => _setPage(3)),
        //           BottomNavItem(iconData: Icons.menu, isSelected: _pageIndex == 4, onTap: () => _setPage(4)),
        //           // BottomNavItem(iconData: Icons.menu, isSelected: _pageIndex == 4, onTap: () => _openEndDrawer()),
        //           // BottomNavItem(iconData: Icons.menu, isSelected: _pageIndex == 4, onTap: () {
        //           //   Get.bottomSheet(const MenuScreen(), backgroundColor: Colors.transparent, isScrollControlled: true);
        //           // }),
        //         ]),
        //
        //
        //       ),
        //     ),
        body: ExpandableBottomSheet(
          background: PageView.builder(
            controller: _pageController,
            itemCount: _screens.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _screens[index];
            },
          ),
          persistentContentHeight: (widget.fromSplash &&
                  Get.find<EQLocationController>().showLocationSuggestion &&
                  active)
              ? 0
              : 100,
          onIsContractedCallback: () {
            if (!orderController.showOneOrder) {
              orderController.showOrders();
            }
          },
          onIsExtendedCallback: () {
            if (orderController.showOneOrder) {
              orderController.showOrders();
            }
          },
          enableToggle: true,
          expandableContent: (widget.fromSplash &&
                  Get.find<EQLocationController>().showLocationSuggestion &&
                  active &&
                  !ResponsiveHelper.isDesktop(context))
              ? const SizedBox()
              : (ResponsiveHelper.isDesktop(context) ||
                      !_isLogin ||
                      orderController.runningOrderModel == null ||
                      orderController.runningOrderModel!.orders!.isEmpty ||
                      !orderController.showBottomSheet)
                  ? const SizedBox()
                  : Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        if (orderController.showBottomSheet) {
                          orderController.showRunningOrders();
                        }
                      },
                      child: RunningOrderViewWidget(reversOrder: reversOrder),
                    ),
        ),
      );
    });
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  Widget trackView(BuildContext context, {required bool status}) {
    return Container(
        height: 3,
        decoration: BoxDecoration(
            color: status
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault)));
  }
}
