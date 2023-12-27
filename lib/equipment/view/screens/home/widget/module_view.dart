import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:customer/equipment/controller/auth_controller.dart';
import 'package:customer/equipment/controller/banner_controller.dart';
import 'package:customer/equipment/controller/location_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/data/model/response/address_model.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/custom_image.dart';
import 'package:customer/equipment/view/base/custom_loader.dart';
import 'package:customer/equipment/view/base/title_widget.dart';
import 'package:customer/equipment/view/screens/address/widget/address_widget.dart';
import 'package:customer/equipment/view/screens/home/widget/banner_view.dart';
import 'package:customer/equipment/view/screens/home/widget/popular_store_view.dart';

import '../../../../controller/localization_controller.dart';
import '../../../../controller/notification_controller.dart';
import '../../../../data/model/response/banner_model.dart';
import '../../../../helper/route_helper.dart';
import '../../../../util/images.dart';
import 'comming_soon.dart';

class ModuleView extends StatelessWidget {
  final EQSplashControllerEquip splashController;

  const ModuleView({Key? key, required this.splashController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool ltr = Get.find<EQLocalizationController>().isLtr;
    return GetBuilder<EQBannerController>(builder: (bannerController) {
      List<BannerModel1>? banars = bannerController.bannerDataModel1List;

      bannerController.getBannerList(false);
      BannerModel1 ban = (banars ?? []).firstWhere(
        (element) => (element.is_main == 1 && element.module_id == null),
        orElse: () {
          return BannerModel1();
        },
      );
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        splashController.moduleList != null
            ? splashController.moduleList!.isNotEmpty
                ? Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            color: HexColor(ban.bg_color ?? "#cab91e"),
                            // Color.fromRGBO(172, 215, 255, 0.42),
                            height: 172,
                          ),
                          Positioned(
                            left: ltr == false ? 0 : null,
                            right: ltr == false ? null : 11,
                            bottom: 0,
                            child: Padding(
                              padding:
                                    EdgeInsets.symmetric(horizontal: 17),
                              child: Image.asset(
                                // '${Get.find<SplashController>().configModel!.baseUrls!.bannerImageUrl}/${ban.image.toString()}',
                                // "assets/image/person_image.png",
                                Images.banar,

                                height: 130,
                                width: 150,
                              ),
                            ),
                          ),
                          Positioned(
                            left: ltr == true ? 11 : null,
                            right: ltr == true ? null : 0,
                            bottom: 11,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              margin:   EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeSmall),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    ban.title ?? "مرحبا بك في موتري",
                                    style: robotoMedium.copyWith(
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    ban.sub_title ??
                                        "موتري بتقدملك جميع قطع الغيار",

                                    // "What do you want to order today?".tr,
                                    style: robotoMedium.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: Container(
                                      height: 30,
                                      width: 170,
                                      padding:   EdgeInsets.symmetric(
                                          horizontal: 0),
                                      child: InkWell(
                                        onTap: () => Get.toNamed(
                                            RouteHelper.getSearchRoute()),
                                        child: Container(
                                          padding:   EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeSmall),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                    width: Dimensions
                                                        .paddingSizeExtraSmall),
                                                Expanded(
                                                    child: Text(
                                                  Get.find<EQSplashControllerEquip>()
                                                          .configModel!
                                                          .moduleConfig!
                                                          .module!
                                                          .showRestaurantText!
                                                      ? 'بتدور علي ايه'.tr
                                                      : 'search_item_or_store'
                                                          .tr,
                                                  style: robotoRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeSmall,
                                                    color: Theme.of(context)
                                                        .hintColor,
                                                  ),
                                                )),
                                                Icon(
                                                  IconlyLight.search,
                                                  size: 22,
                                                  color: Colors.black,
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                              child: Container(
                            width: Dimensions.webMaxWidth,
                            child: Row(children: [
                              (splashController.module != null &&
                                      splashController.configModel!.module ==
                                          null)
                                  ? InkWell(
                                      onTap: () =>
                                          splashController.removeModule(),
                                      child: Image.asset(Images.moduleIcon,
                                          height: 22, width: 22),
                                    )
                                  : const SizedBox(),
                              SizedBox(
                                  width: (splashController.module != null &&
                                          splashController
                                                  .configModel!.module ==
                                              null)
                                      ? Dimensions.paddingSizeExtraSmall
                                      : 0),
                              Expanded(
                                  child: InkWell(
                                onTap: () => Get.find<EQLocationController>()
                                    .navigateToLocationScreen('home'),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeSmall,
                                    horizontal:
                                        ResponsiveHelper.isDesktop(context)
                                            ? Dimensions.paddingSizeSmall
                                            : 0,
                                  ),
                                  child: GetBuilder<EQLocationController>(
                                      builder: (locationController) {
                                    return Padding(
                                      padding:   EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("delevary_to".tr),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              // Icon(
                                              //   locationController.getUserAddress()!.addressType == 'home' ? Icons.home_filled
                                              //       : locationController.getUserAddress()!.addressType == 'office' ? Icons.work : Icons.location_on,
                                              //   size: 20, color: Theme.of(context).textTheme.bodyLarge!.color,
                                              // ),
                                              // const SizedBox(width: 10),
                                              Flexible(
                                                child: Text(
                                                  locationController
                                                      .getUserAddress()!
                                                      .address!,
                                                  style: robotoRegular.copyWith(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .color,
                                                    fontSize: Dimensions
                                                        .fontSizeSmall,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Icon(
                                                Icons.keyboard_arrow_down_sharp,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color,
                                                size: 25,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              )),
                              InkWell(
                                child: GetBuilder<EQNotificationController>(
                                    builder: (notificationController) {
                                  return Stack(children: [
                                    Padding(
                                      padding:   EdgeInsets.all(8.0),
                                      child: Icon(IconlyLight.notification,
                                          size: 25,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color),
                                    ),
                                    notificationController.hasNotification
                                        ? Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Container(
                                              height: 10,
                                              width: 10,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    width: 1,
                                                    color: Theme.of(context)
                                                        .cardColor),
                                              ),
                                            ))
                                        : const SizedBox(),
                                  ]);
                                }),
                                onTap: () => Get.toNamed(
                                    RouteHelper.getNotificationRoute()),
                              ),
                            ]),
                          )),
                        ],
                      ),
                      SizedBox(
                        height: Dimensions.paddingSizeSmall,
                      ),
                      Padding(
                        padding:   EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall),
                        child:
                            TitleWidget(title: 'categories'.tr, onTap: () {}),
                      ),
                      Container(
                        height: 233,
                        child: ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(
                            width: 16,
                          ),
                          // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          //   crossAxisCount: 3, mainAxisSpacing: Dimensions.paddingSizeSmall,
                          //   crossAxisSpacing: Dimensions.paddingSizeSmall, childAspectRatio: (1/1),
                          // ),
                          scrollDirection: Axis.horizontal,
                          padding:
                                EdgeInsets.all(Dimensions.paddingSizeSmall),
                          itemCount: splashController.moduleList!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => {
                                print(splashController.moduleList![index].id
                                        .toString() +
                                    "aaaaaa"),
                                if (splashController.moduleList![index].id
                                        .toString() ==
                                    "4")
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ComingSoon(),
                                        ))
                                  }
                                else
                                  {splashController.switchModule(index, true)}
                              },
                              child: Container(
                                height: 233,
                                width: MediaQuery.of(context).size.width / 2.3,
                                margin: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusDefault),
                                ),
                                child: Stack(fit: StackFit.expand, children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusDefault),
                                    child: CustomImage(
                                      image:
                                          '${splashController.configModel!.baseUrls!.moduleImageUrl}/${splashController.moduleList![index].icon}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Text(
                                      splashController
                                          .moduleList![index].moduleName!,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: robotoMedium.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeExtraLarge,
                                          color: splashController
                                                      .moduleList![index].id ==
                                                  1
                                              ? Colors.white
                                              : null),
                                    ),
                                  ),
                                ]),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Padding(
                    padding:
                          EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                    child: Text('no_module_found'.tr),
                  ))
            : ModuleShimmer(isEnabled: splashController.moduleList == null),
        GetBuilder<EQBannerController>(builder: (bannerController) {
          return const BannerView(isFeatured: true);
        }),
        // GetBuilder<LocationController>(builder: (locationController) {
        // List<AddressModel?> addressList = [];
        // if (Get.find<AuthController>().isLoggedIn() &&
        //     locationController.addressList != null) {
        //   addressList = [];
        //   bool contain = false;
        //   if (locationController.getUserAddress()!.id != null) {
        //     for (int index = 0;
        //         index < locationController.addressList!.length;
        //         index++) {
        //       if (locationController.addressList![index].id ==
        //           locationController.getUserAddress()!.id) {
        //         contain = true;
        //         break;
        //       }
        //     }
        //   }
        //   if (contain) {
        //     addressList.add(Get.find<LocationController>().getUserAddress());
        //   }
        //   addressList.addAll(locationController.addressList!);
        // }
        // return (!Get.find<AuthController>().isLoggedIn() ||
        //         locationController.addressList != null)
        //     ? addressList.isNotEmpty
        //         ? Column(
        //             children: [
        //               const SizedBox(
        //                   height: Dimensions.paddingSizeExtraSmall),
        //               Padding(
        //                 padding:   EdgeInsets.symmetric(
        //                     horizontal: Dimensions.paddingSizeSmall),
        //                 child: TitleWidget(title: 'deliver_to'.tr),
        //               ),
        //               const SizedBox(height: Dimensions.paddingSizeLarge),
        //               SizedBox(
        //                 height: 100,
        //                 child: ListView.builder(
        //                   physics: const BouncingScrollPhysics(),
        //                   itemCount: addressList.length,
        //                   scrollDirection: Axis.horizontal,
        //                   padding:   EdgeInsets.symmetric(
        //                       horizontal: Dimensions.paddingSizeSmall),
        //                   itemBuilder: (context, index) {
        //                     return Container(
        //                       width: 300,
        //                       padding:   EdgeInsets.only(
        //                           right: Dimensions.paddingSizeSmall),
        //                       child: AddressWidget2(
        //                         address: addressList[index],
        //                         fromAddress: false,
        //                         onTap: () {
        //                           if (locationController
        //                                   .getUserAddress()!
        //                                   .id !=
        //                               addressList[index]!.id) {
        //                             Get.dialog(const CustomLoader(),
        //                                 barrierDismissible: false);
        //                             locationController.saveAddressAndNavigate(
        //                               addressList[index],
        //                               false,
        //                               null,
        //                               false,
        //                               ResponsiveHelper.isDesktop(context),
        //                             );
        //                           }
        //                         },
        //                       ),
        //                     );
        //                   },
        //                 ),
        //               ),
        //             ],
        //           )
        //         : const SizedBox()
        //       : AddressShimmer(
        //           isEnabled: Get.find<AuthController>().isLoggedIn() &&
        //               locationController.addressList == null);
        // }),
        const PopularStoreView(isPopular: false, isFeatured: true),
        const SizedBox(height: 30),
      ]);
    });
  }
}

class ModuleShimmer extends StatelessWidget {
  final bool isEnabled;

  const ModuleShimmer({Key? key, required this.isEnabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: Dimensions.paddingSizeSmall,
        crossAxisSpacing: Dimensions.paddingSizeSmall,
        childAspectRatio: (1 / 1),
      ),
      padding:   EdgeInsets.all(Dimensions.paddingSizeSmall),
      itemCount: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[Get.isDarkMode ? 700 : 200]!,
                  spreadRadius: 1,
                  blurRadius: 5)
            ],
          ),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: isEnabled,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Colors.grey[300]),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Center(
                  child: Container(
                      height: 15, width: 50, color: Colors.grey[300])),
            ]),
          ),
        );
      },
    );
  }
}

class AddressShimmer extends StatelessWidget {
  final bool isEnabled;

  const AddressShimmer({Key? key, required this.isEnabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        padding:
              EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        itemBuilder: (context, index) {
          return Container(
            width: 300,
            padding:   EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            child: Container(
              padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context)
                  ? Dimensions.paddingSizeDefault
                  : Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[Get.isDarkMode ? 800 : 200]!,
                      blurRadius: 5,
                      spreadRadius: 1)
                ],
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(
                  Icons.location_on,
                  size: ResponsiveHelper.isDesktop(context) ? 50 : 40,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(
                  child: Shimmer(
                    duration: const Duration(seconds: 2),
                    enabled: isEnabled,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: 15, width: 100, color: Colors.grey[300]),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),
                          Container(
                              height: 10, width: 150, color: Colors.grey[300]),
                        ]),
                  ),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(100, 0.0);
    path.lineTo(0, 0);
    path.lineTo(0.0, size.height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }

    final hexNum = int.parse(hexColor, radix: 16);

    if (hexNum == 0) {
      return 0xff000000;
    }

    return hexNum;
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class ColorToHex extends Color {
  ///convert material colors to hexcolor
  static int _convertColorTHex(Color color) {
    var hex = '${color.value}';
    return int.parse(
      hex,
    );
  }

  ColorToHex(final Color color) : super(_convertColorTHex(color));
}
