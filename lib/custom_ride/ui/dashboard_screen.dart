import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer/custom_ride/constant/constant.dart';
import 'package:customer/custom_ride/controller/dash_board_controller.dart';
import 'package:customer/custom_ride/model/user_model.dart';
import 'package:customer/custom_ride/themes/app_colors.dart';
import 'package:customer/custom_ride/themes/responsive.dart';
import 'package:customer/custom_ride/utils/DarkThemeProvider.dart';
import 'package:customer/custom_ride/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../equipment/helper/route_helper.dart';
import '../../equipment/util/images.dart';

class DashBoardScreen extends StatefulWidget {
  DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GetX<DashBoardController>(
        init: DashBoardController(),
        builder: (controller) {
          return Scaffold(

            appBar: AppBar(
              elevation: 0,
              backgroundColor: AppColors.primary,
              title: controller.selectedDrawerIndex.value != 0 && controller.selectedDrawerIndex.value != 6
                  ? Text(
                      controller.drawerItems[controller.selectedDrawerIndex.value].title,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    )
                  : const Text(""),
              leading:
                Builder(builder: (context) {
                return InkWell(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                    Scaffold.of(context).openDrawer();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 10, right: 20, top: 20, bottom: 20),
                    child: SvgPicture.asset('assets/icons/ic_humber.svg'),
                  ),
                );
              }),
              actions: [
                controller.selectedDrawerIndex.value == 0
                    ? FutureBuilder<UserModel?>(
                        future: FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Constant.loader();
                            case ConnectionState.done:
                              if (snapshot.hasError) {
                                return Text(snapshot.error.toString());
                              } else {
                                UserModel driverModel = snapshot.data!;
                                //                                  // controller.selectedDrawerIndex(8);
                                return Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          driverModel.profilePic.toString(),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Constant.loader(),
                                      errorWidget: (context, url, error) =>
                                          Image.network(
                                              Constant.userPlaceHolder),
                                    ),
                                  ),
                                );
                              }
                            default:
                              return Text('Error'.tr);
                          }
                        })
                    : Container(),
              ],
            ),
            drawer: buildAppDrawer(context, controller),
            body: WillPopScope(
                onWillPop: controller.onWillPop,
                child: controller.isLoading.value == true
                    ? Constant.loader()
                    : controller.getDrawerItemWidget(
                        controller.selectedDrawerIndex.value)),
            bottomNavigationBar:

                //    GNav(
                //   style: GnavStyle.google,
                //    rippleColor: Colors.grey[300]!,
                //    hoverColor: Colors.grey[100]!,
                //    textStyle:  GoogleFonts.cairo(fontWeight: FontWeight.w500),
                //        tabBackgroundColor: AppColors.primary.withOpacity(0.2), // selected tab background color
                //
                //        gap: 8,
                //    activeColor: Colors.black,
                //    iconSize: 24,
                //    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                //    duration: Duration(milliseconds: 400),
                //    color: Colors.black,
                //
                //    tabs: [
                //     GButton(
                //       icon: IconlyLight.home,
                //       text:controller.drawerItems[0].title,
                //
                //     ),
                //     GButton(
                //       icon: Icons.
            //       cation_city,
                //       text: controller.drawerItems[1].title,
                //     ),
                //     GButton(
                //       icon: IconlyLight.bag_2,
                //       text: controller.drawerItems[2].title,
                //     ),
                //     GButton(
                //       icon: IconlyLight.user,
                //       text: controller.drawerItems[3].title,
                //     ),
                //   ],
                //   selectedIndex: int.parse(controller.selectedDrawerIndex.value.toString()),
                //   onTabChange:(i) =>  controller.onSelectItem(i)
                // ),
                BottomAppBar(
              //bottom navigation bar on scaffold
              // color:Colors.redAccent,
              shape: CircularNotchedRectangle(),
              //shape of notch
              notchMargin: 5,
              //notche margin between floating button and bottom appbar
              child: Row(
                //children inside bottom appbar
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 100,
                    child: IconButton(
                      icon: Image.asset(Images.order,height: 20,color: AppColors.primary,),
                      onPressed: () {
                        // controller.drawerItems[2].title
                        controller.onSelectItem(0);
                      },
                    ),
                  ),
                  Container(
                    width: 100,
                    child: IconButton(
                      icon: Image.asset(Images.car,height: 20,color: AppColors.primary,),
                      onPressed: () {
                        controller.onSelectItem(1);
                      },
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              //Floating action button on Scaffold
              onPressed: () {
                Navigator.pushNamed(context, RouteHelper.getInitialRoute());
                //code to execute on button press
              },
              child:
          Image.asset(Images.buy,height: 20,color: AppColors.primary,),
            // Icon(IconlyLight.buy ,color: AppColors.primary,), //icon inside button
            ),
          );
        });}

  buildAppDrawer(BuildContext context, DashBoardController controller) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    var drawerOptions = <Widget>[];
    // drawerOptions.insert(
    //     0,
    //     InkWell(
    //       onTap: () {
    //         Navigator.pushNamed(context, RouteHelper.getInitialRoute());
    //       },
    //       child: Container(
    //         decoration: const BoxDecoration(
    //             borderRadius: BorderRadius.all(Radius.circular(10))),
    //         padding: EdgeInsets.all(5),
    //         child: Row(
    //           children: [
    //             Container(
    //               decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(5),
    //                 color: AppColors.primary,
    //               ),
    //               child: Padding(
    //                 padding: EdgeInsets.all(8.0),
    //                 child: Icon(IconlyLight.home),
    //               ),
    //             ),
    //             const SizedBox(
    //               width: 20,
    //             ),
    //             Text(
    //               "Store",
    //               style: GoogleFonts.cairo(
    //                   // color: i == controller.selectedDrawerIndex.value
    //                   //     ? themeChange.getThem()
    //                   //     ? Colors.black
    //                   //     : Colors.white
    //                   //     : themeChange.getThem()
    //                   //     ? Colors.white
    //                   //     : Colors.black,
    //                   fontWeight: FontWeight.w500),
    //             )
    //           ],
    //         ),
    //       ),
    //     )
    //
    //     //
    //     );

    for (var i = 0; i < controller.drawerItems.length; i++) {
      var d = controller.drawerItems[i];
      drawerOptions.add(InkWell(
        onTap: () {
          controller.onSelectItem(i);
        },
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: i == controller.selectedDrawerIndex.value
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.primary,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      d.icon,
                      width: 20,
                      color: i == controller.selectedDrawerIndex.value
                          ? themeChange.getThem()
                              ? Colors.black
                              : Colors.white
                          : themeChange.getThem()
                              ? Colors.white
                              : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  d.title,
                  style: GoogleFonts.cairo(
                      color: i == controller.selectedDrawerIndex.value
                          ? themeChange.getThem()
                              ? Colors.black
                              : Colors.white
                          : themeChange.getThem()
                              ? Colors.white
                              : Colors.black,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ),
      ));
    }
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: ListView(
        children: [
          DrawerHeader(
            child: FutureBuilder<UserModel?>(
                future: FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Constant.loader();
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        UserModel driverModel = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: CachedNetworkImage(
                                height: Responsive.width(20, context),
                                width: Responsive.width(20, context),
                                imageUrl: driverModel.profilePic.toString(),
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Constant.loader(),
                                errorWidget: (context, url, error) => Image.network(Constant.userPlaceHolder),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(driverModel.fullName.toString(),
                                  style: GoogleFonts.cairo(
                                      fontWeight: FontWeight.w500)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Text(
                                driverModel.email.toString(),
                                style: GoogleFonts.cairo(),
                              ),
                            )
                          ],
                        );
                      }
                    default:
                      return  Text('Error'.tr);
                  }
                }),
          ),
          Column(children: drawerOptions),
        ],
      ),
    );
  }
}
