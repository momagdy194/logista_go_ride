import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/custom_ride/constant/constant.dart';
import 'package:customer/custom_ride/constant/send_notification.dart';
import 'package:customer/custom_ride/constant/show_toast_dialog.dart';
import 'package:customer/custom_ride/controller/home_controller.dart';
import 'package:customer/custom_ride/model/airport_model.dart';
import 'package:customer/custom_ride/model/banner_model.dart';
import 'package:customer/custom_ride/model/contact_model.dart';
import 'package:customer/custom_ride/model/order/location_lat_lng.dart';
import 'package:customer/custom_ride/model/order/positions.dart';
import 'package:customer/custom_ride/model/order_model.dart';
import 'package:customer/custom_ride/model/service_model.dart';
import 'package:customer/custom_ride/model/user_model.dart';
import 'package:customer/custom_ride/themes/app_colors.dart';
import 'package:customer/custom_ride/themes/button_them.dart';
import 'package:customer/custom_ride/themes/responsive.dart';
import 'package:customer/custom_ride/themes/text_field_them.dart';
import 'package:customer/custom_ride/utils/DarkThemeProvider.dart';
import 'package:customer/custom_ride/utils/fire_store_utils.dart';
import 'package:customer/custom_ride/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:place_picker/place_picker.dart';
import 'package:provider/provider.dart';

import '../../constant/constant.dart';
import '../../controller/home_controller.dart';
import '../../themes/app_colors.dart';
import '../../utils/DarkThemeProvider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<HomeController>(
        init: HomeController(),
        builder: (controller) {
          return Scaffold(
            body: Container(
              padding:   EdgeInsets.only(bottom: 30 ),

              child: Scaffold(
                backgroundColor: AppColors.primary,
                body: controller.isLoading.value
                    ? Constant.loader()
                    : Container(
                      child: Column(
                          children: [
                            SizedBox(
                              height: Responsive.width(22, context),
                              width: Responsive.width(100, context),
                              child: Padding(
                                padding:   EdgeInsets.symmetric(horizontal: 10),
                                child: FutureBuilder<UserModel?>(
                                    future: FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()),
                                    builder: (context, snapshot)
                                    {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return Constant.loader();
                                        case ConnectionState.done:
                                          if (snapshot.hasError) {
                                            return Text(snapshot.error.toString());
                                          } else {
                                            UserModel userModel = snapshot.data!;
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(userModel.fullName.toString(), style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1)),
                                                const SizedBox(
                                                  height: 1,
                                                ),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset('assets/icons/ic_location.svg', width: 16),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Expanded(child: Text(controller.currentLocation.value, style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w400),maxLines: 1,)),
                                                  ],
                                                ),
                                              ],
                                            );
                                          }
                                        default:
                                          return Text('Error'.tr);
                                      }
                                    }),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration:
                                    BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                                child: Padding(
                                  padding:   EdgeInsets.symmetric(horizontal: 10),
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding:   EdgeInsets.only(top: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Visibility(
                                            visible: controller.bannerList.isNotEmpty,
                                            child: SizedBox(
                                                height: MediaQuery.of(context).size.height * 0.20,
                                                child: PageView.builder(
                                                    padEnds: false,
                                                    itemCount: controller.bannerList.length,
                                                    scrollDirection: Axis.horizontal,
                                                     controller: controller.pageController,
                                                    itemBuilder: (context, index) {
                                                      BannerModel bannerModel = controller.bannerList[index];
                                                      return Padding(
                                                        padding:   EdgeInsets.symmetric(horizontal: 0),
                                                        child: CachedNetworkImage(
                                                          imageUrl: bannerModel.image.toString(),
                                                          imageBuilder: (context, imageProvider) => Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(20),
                                                              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                            ),
                                                          ),
                                                          color: Colors.black.withOpacity(0.5),
                                                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      );
                                                    })),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text("Where you want to go?".tr, style: GoogleFonts.cairo(fontWeight: FontWeight.w600, fontSize: 18, letterSpacing: 1)),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          controller.sourceLocationLAtLng.value.latitude == null
                                              ? InkWell(
                                                  onTap: () async {
                                                    LocationResult? result = await Utils.showPlacePicker(context);
                                                    if (result != null) {
                                                      controller.sourceLocationController.value.text = result.formattedAddress.toString();
                                                      controller.sourceLocationLAtLng.value = LocationLatLng(latitude: result.latLng!.latitude, longitude: result.latLng!.longitude);
                                                      controller.calculateAmount();
                                                    }
                                                  },
                                                  child: TextFieldThem.buildTextFiled(context, hintText: 'Enter Location'.tr, controller: controller.sourceLocationController.value, enable: false))
                                              : Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        SvgPicture.asset(themeChange.getThem() ? 'assets/icons/ic_source_dark.svg' : 'assets/icons/ic_source.svg', width: 18),
                                                        Dash(direction: Axis.vertical, length: Responsive.height(6, context), dashLength: 12, dashColor: AppColors.dottedDivider),
                                                        SvgPicture.asset(themeChange.getThem() ? 'assets/icons/ic_destination_dark.svg' : 'assets/icons/ic_destination.svg', width: 20),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 18,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          InkWell(
                                                              onTap: () async {
                                                                LocationResult? result = await Utils.showPlacePicker(context);
                                                                if (result != null) {
                                                                  controller.sourceLocationController.value.text = result.formattedAddress.toString();
                                                                  controller.sourceLocationLAtLng.value = LocationLatLng(latitude: result.latLng!.latitude, longitude: result.latLng!.longitude);
                                                                  controller.calculateAmount();
                                                                }
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: TextFieldThem.buildTextFiled(context,
                                                                        hintText: 'Enter Location'.tr, controller: controller.sourceLocationController.value, enable: false),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  // InkWell(
                                                                  //     onTap: () {
                                                                  //       ariPortDialog(context, controller, true);
                                                                  //     },
                                                                  //     child: const Icon(Icons.flight_takeoff))
                                                                ],
                                                              )),
                                                          SizedBox(height: Responsive.height(1, context)),
                                                          InkWell(
                                                              onTap: () async {
                                                                LocationResult? result = await Utils.showPlacePicker(context);
                                                                if (result != null) {
                                                                  controller.destinationLocationController.value.text = result.formattedAddress.toString();
                                                                  controller.destinationLocationLAtLng.value = LocationLatLng(latitude: result.latLng!.latitude, longitude: result.latLng!.longitude);
                                                                  controller.calculateAmount();
                                                                }
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: TextFieldThem.buildTextFiled(context,
                                                                        hintText: 'Enter destination Location'.tr, controller: controller.destinationLocationController.value, enable: false),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  // InkWell(
                                                                  //     onTap: () {
                                                                  //       ariPortDialog(context, controller, false);
                                                                  //     },
                                                                  //     child: const Icon(Icons.flight_takeoff))
                                                                ],
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text("Select Vehicle".tr, style: GoogleFonts.cairo(fontWeight: FontWeight.w500, letterSpacing: 1)),
                                          const SizedBox(
                                            height: 05,
                                          ),
                                          SizedBox(
                                            height: Responsive.height(18, context),
                                            child: ListView.builder(
                                              itemCount: controller.serviceList.length,
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                ServiceModel mainCategory = controller.serviceList[index];
                                                return Obx(
                                                  () => InkWell(
                                                    onTap: () async{
                                                      if(mainCategory.id==controller.taxiCarId||
                                                          mainCategory.id== controller.cargoShipping){
                                                        controller.selectedType.value = mainCategory;

                                                      }else{
                                                        showLoadingIndicator(text: "Get vehicle category");
                                                        await   controller.getServiceSubCategory(parentCategoryId: mainCategory.id);
                                                        hideOpenDialog();
                                                        subCategoryDialogDialog(context, controller,mainCategory);

                                                      }
                                                      controller.calculateAmount();

                                                    },
                                                    child: Padding(
                                                      padding:   EdgeInsets.all(6.0),
                                                      child: Container(
                                                        width: Responsive.width(28, context),
                                                        decoration: BoxDecoration(
                                                            color: controller.selectedType.value == mainCategory
                                                                ? themeChange.getThem()
                                                                    ? AppColors.darkModePrimary
                                                                    : AppColors.primary
                                                                : themeChange.getThem()
                                                                    ? AppColors.darkService
                                                                    : controller.colors[index % controller.colors.length],
                                                            borderRadius: const BorderRadius.all(
                                                              Radius.circular(10),
                                                            )),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  color: Theme.of(context).colorScheme.background,
                                                                  borderRadius: const BorderRadius.all(
                                                                    Radius.circular(10),
                                                                  )),
                                                              child: Padding(
                                                                padding:   EdgeInsets.all(8.0),
                                                                child: CachedNetworkImage(
                                                                  imageUrl: mainCategory.image.toString(),
                                                                  fit: BoxFit.contain,
                                                                  height: Responsive.height(8, context),
                                                                  width: Responsive.width(18, context),
                                                                  placeholder: (context, url) => Constant.loader(),
                                                                  errorWidget: (context, url, error) => Image.network(Constant.userPlaceHolder),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(mainCategory.title.toString(),
                                                                style: GoogleFonts.cairo(
                                                                    color: controller.selectedType.value == mainCategory
                                                                        ? themeChange.getThem()
                                                                            ? Colors.black
                                                                            : Colors.white
                                                                        : themeChange.getThem()
                                                                            ? Colors.white
                                                                            : Colors.black)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Obx(
                                            () => controller.sourceLocationLAtLng.value.latitude != null && controller.destinationLocationLAtLng.value.latitude != null && controller.amount.value.isNotEmpty
                                                ? Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Padding(
                                                        padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                        child: Container(
                                                          width: Responsive.width(100, context),
                                                          decoration: const BoxDecoration(color: AppColors.gray, borderRadius: BorderRadius.all(Radius.circular(10))),
                                                          child: Padding(
                                                              padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                              child: Center(
                                                                child: controller.selectedType.value.offerRate == true
                                                                    ? RichText(
                                                                        text: TextSpan(
                                                                          text:
                                                                              '${"Recommended Price is".tr} ${Constant.amountShow(amount: controller.amount.value)}. "${"Approx time".tr}" ${controller.duration}. "${"Approx distance".tr}" ${double.parse(controller.distance.value).toStringAsFixed(Constant.currencyModel!.decimalDigits!)} ${Constant.distanceType}'
                                                                                  .tr,
                                                                          style: GoogleFonts.cairo(color: Colors.black),
                                                                        ),
                                                                      )
                                                                    : RichText(
                                                                        text: TextSpan(
                                                                            text:
                                                                                '${"Your Price is".tr} ${Constant.amountShow(amount: controller.amount.value)}. "${"Approx time".tr}" ${controller.duration}. "${"Approx distance".tr}" ${double.parse(controller.distance.value).toStringAsFixed(Constant.currencyModel!.decimalDigits!)} ${Constant.distanceType}'
                                                                                    ,
                                                                            style: GoogleFonts.cairo(color: Colors.black)),
                                                                      ),
                                                              )),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Container(),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Visibility(
                                            visible: controller.selectedType.value.offerRate == true,
                                            child: TextFieldThem.buildTextFiledWithPrefixIcon(
                                              context,
                                              hintText: "Enter your offer rate".tr,
                                              controller: controller.offerYourRateController.value,
                                              prefix: Padding(
                                                padding:   EdgeInsets.only(right: 10),
                                                child: Text(Constant.currencyModel!.symbol.toString()),
                                              ),
                                            ),
                                          ),




                                         ( controller.selectedType.value.id==controller.taxiCarId|| controller.selectedType.value.id==controller.cargoShipping) ?   Column(children: [
                                           const SizedBox(
                                             height: 5,
                                           ),
                                          Text(
                                            "The recipient".tr,
                                            style: GoogleFonts.cairo(),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              someOneTakingDialog(context, controller);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                                                border: Border.all(color: AppColors.textFieldBorder, width: 1),
                                              ),
                                              child: Padding(
                                                padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.person),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                          controller.selectedTakingRide.value.fullName == "Myself" ? "Myself".tr : controller.selectedTakingRide.value.fullName.toString(),
                                                          style: GoogleFonts.cairo(),
                                                        )),
                                                    const Icon(Icons.arrow_drop_down_outlined)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],)
                                       :SizedBox(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              paymentMethodDialog(context, controller);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                                                border: Border.all(color: AppColors.textFieldBorder, width: 1),
                                              ),
                                              child: Padding(
                                                padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/icons/ic_payment.svg',
                                                      width: 26,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                      controller.selectedPaymentMethod.value.isNotEmpty ? controller.selectedPaymentMethod.value : "Select Payment type".tr,
                                                      style: GoogleFonts.cairo(),
                                                    )),
                                                    const Icon(Icons.arrow_drop_down_outlined)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ButtonThem.buildButton(
                                            context,
                                            title: "Book Ride".tr,
                                            btnWidthRatio: Responsive.width(100, context),
                                            onPress: () async {
                                              bool isPaymentNotCompleted = await FireStoreUtils.paymentStatusCheck();
                                              if (controller.selectedPaymentMethod.value.isEmpty) {
                                                ShowToastDialog.showToast("Please select Payment Method".tr);
                                              } else if (controller.sourceLocationController.value.text.isEmpty) {
                                                ShowToastDialog.showToast("Please select source location".tr);
                                              } else if (controller.destinationLocationController.value.text.isEmpty) {
                                                ShowToastDialog.showToast("Please select destination location".tr);
                                              } else if (double.parse(controller.distance.value) <= 2) {
                                                ShowToastDialog.showToast("Please select more than two ${Constant.distanceType} location".tr);
                                              } else if (controller.selectedType.value.offerRate == true && controller.offerYourRateController.value.text.isEmpty) {
                                                ShowToastDialog.showToast("Please Enter offer rate".tr);
                                              } else if (isPaymentNotCompleted) {
                                                showAlertDialog(context);
                                                // showDialog(context: context, builder: (BuildContext context) => warningDailog());
                                              } else {
                                                // ShowToastDialog.showLoader("Please wait");
                                                OrderModel orderModel = OrderModel();
                                                orderModel.id = Constant.getUuid();
                                                orderModel.userId = FireStoreUtils.getCurrentUid();
                                                orderModel.sourceLocationName = controller.sourceLocationController.value.text;
                                                orderModel.destinationLocationName = controller.destinationLocationController.value.text;
                                                orderModel.sourceLocationLAtLng = controller.sourceLocationLAtLng.value;
                                                orderModel.destinationLocationLAtLng = controller.destinationLocationLAtLng.value;
                                                orderModel.distance = controller.distance.value;
                                                orderModel.distanceType = Constant.distanceType;
                                                orderModel.offerRate = controller.selectedType.value.offerRate == true ? controller.offerYourRateController.value.text : controller.amount.value;
                                                orderModel.serviceId = controller.selectedType.value.id;
                                                GeoFirePoint position =
                                                    GeoFlutterFire().point(latitude: controller.sourceLocationLAtLng.value.latitude!, longitude: controller.sourceLocationLAtLng.value.longitude!);

                                                orderModel.position = Positions(geoPoint: position.geoPoint, geohash: position.hash);
                                                orderModel.createdDate = Timestamp.now();
                                                orderModel.status = Constant.ridePlaced;
                                                orderModel.paymentType = controller.selectedPaymentMethod.value;
                                                orderModel.paymentStatus = false;
                                                orderModel.service = controller.selectedType.value;
                                                orderModel.adminCommission =
                                                    controller.selectedType.value.adminCommission!.isEnabled == false ? controller.selectedType.value.adminCommission! : Constant.adminCommission;
                                                orderModel.otp = Constant.getReferralCode();
                                                orderModel.taxList = Constant.taxList;
                                                if (controller.selectedTakingRide.value.fullName != "Myself") {
                                                  orderModel.someOneElse = controller.selectedTakingRide.value;
                                                }

                                                // FireStoreUtils().startStream();
                                                FireStoreUtils().sendOrderData(orderModel).listen((event) {
                                                  event.forEach((element) async {
                                                    if (element.fcmToken != null) {
                                                      Map<String, dynamic> playLoad = <String, dynamic>{"type": "city_order", "orderId": orderModel.id};
                                                      await SendNotification.sendOneNotification(
                                                          token: element.fcmToken.toString(),
                                                          title: 'New Ride Available'.tr,
                                                          body: 'A customer has placed an ride near your location.'.tr,
                                                          payload: playLoad);
                                                    }
                                                  });
                                                  FireStoreUtils().closeStream();
                                                });
                                                await FireStoreUtils.setOrder(orderModel).then((value) {
                                                  ShowToastDialog.showToast("Ride Placed successfully".tr);
                                                  controller.dashboardController.selectedDrawerIndex(1);
                                                  ShowToastDialog.closeLoader();
                                                });
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ),
              ),
            ),
          );
        });
  }

  paymentMethodDialog(BuildContext context, HomeController controller) {
    return showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context1) {
          final themeChange = Provider.of<DarkThemeProvider>(context1);

          return FractionallySizedBox(
            heightFactor: 0.9,
            child: StatefulBuilder(builder: (context1, setState) {
              return Obx(
                () => Padding(
                  padding:   EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding:   EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(Icons.arrow_back_ios)),
                            const Expanded(
                                child: Center(
                                    child: Text(
                              "Select Payment Method",
                            ))),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Visibility(
                                visible: controller.paymentModel.value.cash!.enable == true,
                                child: Obx(
                                  () => Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.selectedPaymentMethod.value = controller.paymentModel.value.cash!.name.toString();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            border: Border.all(
                                                color: controller.selectedPaymentMethod.value == controller.paymentModel.value.cash!.name.toString()
                                                    ? themeChange.getThem()
                                                        ? AppColors.darkModePrimary
                                                        : AppColors.primary
                                                    : AppColors.textFieldBorder,
                                                width: 1),
                                          ),
                                          child: Padding(
                                            padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 40,
                                                  width: 80,
                                                  decoration: const BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Icon(Icons.money, color: Colors.black),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    controller.paymentModel.value.cash!.name.toString(),
                                                    style: GoogleFonts.cairo(),
                                                  ),
                                                ),
                                                Radio(
                                                  value: controller.paymentModel.value.cash!.name.toString(),
                                                  groupValue: controller.selectedPaymentMethod.value,
                                                  activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                                  onChanged: (value) {
                                                    controller.selectedPaymentMethod.value = controller.paymentModel.value.cash!.name.toString();
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: controller.paymentModel.value.wallet!.enable == true,
                                child: Obx(
                                  () => Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.selectedPaymentMethod.value = controller.paymentModel.value.wallet!.name.toString();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            border: Border.all(
                                                color: controller.selectedPaymentMethod.value == controller.paymentModel.value.wallet!.name.toString()
                                                    ? themeChange.getThem()
                                                        ? AppColors.darkModePrimary
                                                        : AppColors.primary
                                                    : AppColors.textFieldBorder,
                                                width: 1),
                                          ),
                                          child: Padding(
                                            padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 40,
                                                  width: 80,
                                                  decoration: const BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                  child: Padding(
                                                    padding:   EdgeInsets.all(8.0),
                                                    child: SvgPicture.asset('assets/icons/ic_wallet.svg', color: AppColors.primary),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    controller.paymentModel.value.wallet!.name.toString(),
                                                    style: GoogleFonts.cairo(),
                                                  ),
                                                ),
                                                Radio(
                                                  value: controller.paymentModel.value.wallet!.name.toString(),
                                                  groupValue: controller.selectedPaymentMethod.value,
                                                  activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                                  onChanged: (value) {
                                                    controller.selectedPaymentMethod.value = controller.paymentModel.value.wallet!.name.toString();
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: controller.paymentModel.value.strip!.enable == true,
                                child: Obx(
                                  () => Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.selectedPaymentMethod.value = controller.paymentModel.value.strip!.name.toString();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            border: Border.all(
                                                color: controller.selectedPaymentMethod.value == controller.paymentModel.value.strip!.name.toString()
                                                    ? themeChange.getThem()
                                                        ? AppColors.darkModePrimary
                                                        : AppColors.primary
                                                    : AppColors.textFieldBorder,
                                                width: 1),
                                          ),
                                          child: Padding(
                                            padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 40,
                                                  width: 80,
                                                  decoration: const BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                  child: Padding(
                                                    padding:   EdgeInsets.all(8.0),
                                                    child: Image.asset('assets/images/stripe.png'),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    controller.paymentModel.value.strip!.name.toString(),
                                                    style: GoogleFonts.cairo(),
                                                  ),
                                                ),
                                                Radio(
                                                  value: controller.paymentModel.value.strip!.name.toString(),
                                                  groupValue: controller.selectedPaymentMethod.value,
                                                  activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                                  onChanged: (value) {
                                                    controller.selectedPaymentMethod.value = controller.paymentModel.value.strip!.name.toString();
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: controller.paymentModel.value.paypal!.enable == true,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.selectedPaymentMethod.value = controller.paymentModel.value.paypal!.name.toString();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(
                                              color: controller.selectedPaymentMethod.value == controller.paymentModel.value.paypal!.name.toString()
                                                  ? themeChange.getThem()
                                                      ? AppColors.darkModePrimary
                                                      : AppColors.primary
                                                  : AppColors.textFieldBorder,
                                              width: 1),
                                        ),
                                        child: Padding(
                                          padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 80,
                                                decoration: const BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                child: Padding(
                                                  padding:   EdgeInsets.all(8.0),
                                                  child: Image.asset('assets/images/paypal.png'),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.paymentModel.value.paypal!.name.toString(),
                                                  style: GoogleFonts.cairo(),
                                                ),
                                              ),
                                              Radio(
                                                value: controller.paymentModel.value.paypal!.name.toString(),
                                                groupValue: controller.selectedPaymentMethod.value,
                                                activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                                onChanged: (value) {
                                                  controller.selectedPaymentMethod.value = controller.paymentModel.value.paypal!.name.toString();
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: controller.paymentModel.value.payStack!.enable == true,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.selectedPaymentMethod.value = controller.paymentModel.value.payStack!.name.toString();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(
                                              color: controller.selectedPaymentMethod.value == controller.paymentModel.value.payStack!.name.toString()
                                                  ? themeChange.getThem()
                                                      ? AppColors.darkModePrimary
                                                      : AppColors.primary
                                                  : AppColors.textFieldBorder,
                                              width: 1),
                                        ),
                                        child: Padding(
                                          padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 80,
                                                decoration: const BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                child: Padding(
                                                  padding:   EdgeInsets.all(8.0),
                                                  child: Image.asset('assets/images/paystack.png'),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.paymentModel.value.payStack!.name.toString(),
                                                  style: GoogleFonts.cairo(),
                                                ),
                                              ),
                                              Radio(
                                                value: controller.paymentModel.value.payStack!.name.toString(),
                                                groupValue: controller.selectedPaymentMethod.value,
                                                activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                                onChanged: (value) {
                                                  controller.selectedPaymentMethod.value = controller.paymentModel.value.payStack!.name.toString();
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: controller.paymentModel.value.mercadoPago!.enable == true,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.selectedPaymentMethod.value = controller.paymentModel.value.mercadoPago!.name.toString();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(
                                              color: controller.selectedPaymentMethod.value == controller.paymentModel.value.mercadoPago!.name.toString()
                                                  ? themeChange.getThem()
                                                      ? AppColors.darkModePrimary
                                                      : AppColors.primary
                                                  : AppColors.textFieldBorder,
                                              width: 1),
                                        ),
                                        child: Padding(
                                          padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 80,
                                                decoration: const BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                child: Padding(
                                                  padding:   EdgeInsets.all(8.0),
                                                  child: Image.asset('assets/images/mercadopago.png'),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.paymentModel.value.mercadoPago!.name.toString(),
                                                  style: GoogleFonts.cairo(),
                                                ),
                                              ),
                                              Radio(
                                                value: controller.paymentModel.value.mercadoPago!.name.toString(),
                                                groupValue: controller.selectedPaymentMethod.value,
                                                activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                                onChanged: (value) {
                                                  controller.selectedPaymentMethod.value = controller.paymentModel.value.mercadoPago!.name.toString();
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: controller.paymentModel.value.flutterWave!.enable == true,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.selectedPaymentMethod.value = controller.paymentModel.value.flutterWave!.name.toString();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(
                                              color: controller.selectedPaymentMethod.value == controller.paymentModel.value.flutterWave!.name.toString()
                                                  ? themeChange.getThem()
                                                      ? AppColors.darkModePrimary
                                                      : AppColors.primary
                                                  : AppColors.textFieldBorder,
                                              width: 1),
                                        ),
                                        child: Padding(
                                          padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 80,
                                                decoration: const BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                child: Padding(
                                                  padding:   EdgeInsets.all(8.0),
                                                  child: Image.asset('assets/images/flutterwave.png'),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.paymentModel.value.flutterWave!.name.toString(),
                                                  style: GoogleFonts.cairo(),
                                                ),
                                              ),
                                              Radio(
                                                value: controller.paymentModel.value.flutterWave!.name.toString(),
                                                groupValue: controller.selectedPaymentMethod.value,
                                                activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                                onChanged: (value) {
                                                  controller.selectedPaymentMethod.value = controller.paymentModel.value.flutterWave!.name.toString();
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: controller.paymentModel.value.payfast!.enable == true,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.selectedPaymentMethod.value = controller.paymentModel.value.payfast!.name.toString();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(
                                              color: controller.selectedPaymentMethod.value == controller.paymentModel.value.payfast!.name.toString()
                                                  ? themeChange.getThem()
                                                      ? AppColors.darkModePrimary
                                                      : AppColors.primary
                                                  : AppColors.textFieldBorder,
                                              width: 1),
                                        ),
                                        child: Padding(
                                          padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 80,
                                                decoration: const BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                child: Padding(
                                                  padding:   EdgeInsets.all(8.0),
                                                  child: Image.asset('assets/images/payfast.png'),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.paymentModel.value.payfast!.name.toString(),
                                                  style: GoogleFonts.cairo(),
                                                ),
                                              ),
                                              Radio(
                                                value: controller.paymentModel.value.payfast!.name.toString(),
                                                groupValue: controller.selectedPaymentMethod.value,
                                                activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                                onChanged: (value) {
                                                  controller.selectedPaymentMethod.value = controller.paymentModel.value.payfast!.name.toString();
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: controller.paymentModel.value.paytm!.enable == true,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.selectedPaymentMethod.value = controller.paymentModel.value.paytm!.name.toString();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(
                                              color: controller.selectedPaymentMethod.value == controller.paymentModel.value.paytm!.name.toString()
                                                  ? themeChange.getThem()
                                                      ? AppColors.darkModePrimary
                                                      : AppColors.primary
                                                  : AppColors.textFieldBorder,
                                              width: 1),
                                        ),
                                        child: Padding(
                                          padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 80,
                                                decoration: const BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                child: Padding(
                                                  padding:   EdgeInsets.all(8.0),
                                                  child: Image.asset('assets/images/paytam.png'),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.paymentModel.value.paytm!.name.toString(),
                                                  style: GoogleFonts.cairo(),
                                                ),
                                              ),
                                              Radio(
                                                value: controller.paymentModel.value.paytm!.name.toString(),
                                                groupValue: controller.selectedPaymentMethod.value,
                                                activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                                onChanged: (value) {
                                                  controller.selectedPaymentMethod.value = controller.paymentModel.value.paytm!.name.toString();
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: controller.paymentModel.value.razorpay!.enable == true,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.selectedPaymentMethod.value = controller.paymentModel.value.razorpay!.name.toString();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(
                                              color: controller.selectedPaymentMethod.value == controller.paymentModel.value.razorpay!.name.toString()
                                                  ? themeChange.getThem()
                                                      ? AppColors.darkModePrimary
                                                      : AppColors.primary
                                                  : AppColors.textFieldBorder,
                                              width: 1),
                                        ),
                                        child: Padding(
                                          padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 80,
                                                decoration: const BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                child: Padding(
                                                  padding:   EdgeInsets.all(8.0),
                                                  child: Image.asset('assets/images/razorpay.png'),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.paymentModel.value.razorpay!.name.toString(),
                                                  style: GoogleFonts.cairo(),
                                                ),
                                              ),
                                              Radio(
                                                value: controller.paymentModel.value.razorpay!.name.toString(),
                                                groupValue: controller.selectedPaymentMethod.value,
                                                activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                                onChanged: (value) {
                                                  controller.selectedPaymentMethod.value = controller.paymentModel.value.razorpay!.name.toString();
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ButtonThem.buildButton(
                        context,
                        title: "Pay",
                        onPress: () async {
                          Get.back();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }

  someOneTakingDialog(BuildContext context, HomeController controller) {
    return showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context1) {
          final themeChange = Provider.of<DarkThemeProvider>(context1);

          return StatefulBuilder(builder: (context1, setState) {
            return Obx(
              () => Container(
                constraints: BoxConstraints(maxHeight: Responsive.height(90, context)),
                child: Padding(
                  padding:   EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Someone else taking this ride?".tr,
                          style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Choose a contact and share a code to conform that ride.".tr,
                          style: GoogleFonts.cairo(),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            controller.selectedTakingRide.value = ContactModel(fullName: "Myself", contactNumber: "");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                  color: controller.selectedTakingRide.value.fullName == "Myself"
                                      ? themeChange.getThem()
                                          ? AppColors.darkModePrimary
                                          : AppColors.primary
                                      : AppColors.textFieldBorder,
                                  width: 1),
                            ),
                            child: Padding(
                              padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.person, color: Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Myself".tr,
                                      style: GoogleFonts.cairo(),
                                    ),
                                  ),
                                  Radio(
                                    value: "Myself",
                                    groupValue: controller.selectedTakingRide.value.fullName,
                                    activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                    onChanged: (value) {
                                      controller.selectedTakingRide.value = ContactModel(fullName: "Myself", contactNumber: "");
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        ListView.builder(
                          itemCount: controller.contactList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            ContactModel contactModel = controller.contactList[index];
                            return Padding(
                              padding:   EdgeInsets.symmetric(vertical: 5),
                              child: InkWell(
                                onTap: () {
                                  controller.selectedTakingRide.value = contactModel;
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        color: controller.selectedTakingRide.value.fullName == contactModel.fullName
                                            ? themeChange.getThem()
                                                ? AppColors.darkModePrimary
                                                : AppColors.primary
                                            : AppColors.textFieldBorder,
                                        width: 1),
                                  ),
                                  child: Padding(
                                    padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(Icons.person, color: Colors.black),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            contactModel.fullName.toString(),
                                            style: GoogleFonts.cairo(),
                                          ),
                                        ),
                                        Radio(
                                          value: contactModel.fullName.toString(),
                                          groupValue: controller.selectedTakingRide.value.fullName,
                                          activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                          onChanged: (value) {
                                            controller.selectedTakingRide.value = contactModel;
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            final FullContact contact = await FlutterContactPicker.pickFullContact();
                            ContactModel contactModel = ContactModel();
                            contactModel.fullName = "${contact.name!.firstName ?? ""} ${contact.name!.middleName ?? ""} ${contact.name!.lastName ?? ""}";
                            contactModel.contactNumber = contact.phones[0].number;

                            if (!controller.contactList.contains(contactModel)) {
                              controller.contactList.add(contactModel);
                              controller.setContact();
                            }
                          },
                          child: Padding(
                            padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.contacts, color: Colors.black),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    "Choose another contact",
                                    style: GoogleFonts.cairo(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ButtonThem.buildButton(
                          context,
                          title: "${"Book for".tr} ${controller.selectedTakingRide.value.fullName}",
                          onPress: () async {
                            Get.back();
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  ariPortDialog(BuildContext context, HomeController controller, bool isSource) {
    return showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (context1) {
          final themeChange = Provider.of<DarkThemeProvider>(context1);

          return StatefulBuilder(builder: (context1, setState) {
            return Container(
              constraints: BoxConstraints(maxHeight: Responsive.height(90, context)),
              child: Padding(
                padding:   EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Do you want to travel for AirPort?".tr,
                        style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Choose a single AirPort",
                        style: GoogleFonts.cairo(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        itemCount: Constant.airaPortList!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          AriPortModel airPortModel = Constant.airaPortList![index];
                          return Obx(
                            () => Padding(
                              padding:   EdgeInsets.symmetric(vertical: 5),
                              child: InkWell(
                                onTap: () {
                                  controller.selectedAirPort.value = airPortModel;
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        color: controller.selectedAirPort.value.id == airPortModel.id
                                            ? themeChange.getThem()
                                                ? AppColors.darkModePrimary
                                                : AppColors.primary
                                            : AppColors.textFieldBorder,
                                        width: 1),
                                  ),
                                  child: Padding(
                                    padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(Icons.airplanemode_active, color: Colors.black),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            airPortModel.airportName.toString(),
                                            style: GoogleFonts.cairo(),
                                          ),
                                        ),
                                        Radio(
                                          value: airPortModel.id.toString(),
                                          groupValue: controller.selectedAirPort.value.id,
                                          activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                          onChanged: (value) {
                                            controller.selectedAirPort.value = airPortModel;
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ButtonThem.buildButton(
                        context,
                        title: "Book",
                        onPress: () async {
                          if (controller.selectedAirPort.value.id != null) {
                            if (isSource) {
                              controller.sourceLocationController.value.text = controller.selectedAirPort.value.airportName.toString();
                              controller.sourceLocationLAtLng.value = LocationLatLng(
                                  latitude: double.parse(controller.selectedAirPort.value.airportLat.toString()), longitude: double.parse(controller.selectedAirPort.value.airportLng.toString()));
                              controller.calculateAmount();
                            } else {
                              controller.destinationLocationController.value.text = controller.selectedAirPort.value.airportName.toString();
                              controller.destinationLocationLAtLng.value = LocationLatLng(
                                  latitude: double.parse(controller.selectedAirPort.value.airportLat.toString()), longitude: double.parse(controller.selectedAirPort.value.airportLng.toString()));
                              controller.calculateAmount();
                            }
                            Get.back();
                          } else {
                            ShowToastDialog.showToast("Please select one airport",position: EasyLoadingToastPosition.center);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Warning"),
      content: const Text("You are not able book new ride please complete previous ride payment"),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

// warningDailog() {
//   return Dialog(
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
//     child: SizedBox(
//       height: 300.0,
//       width: 300.0,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           const Padding(
//             padding: EdgeInsets.all(15.0),
//             child: Text(
//               'Warning!',
//               style: TextStyle(color: Colors.red),
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.all(15.0),
//             child: Text(
//               'You are not able book new ride please complete previous ride payment',
//               style: TextStyle(color: Colors.red),
//             ),
//           ),
//           const Padding(padding: EdgeInsets.only(top: 50.0)),
//           TextButton(
//               onPressed: () {
//                 Get.back();
//               },
//               child: const Text(
//                 'Ok',
//                 style: TextStyle(color: Colors.purple, fontSize: 18.0),
//               ))
//         ],
//       ),
//     ),
//   );
// }

  subCategoryDialogDialog(BuildContext context, HomeController controller,ServiceModel mainCategory) {
    return showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context1) {
          final themeChange = Provider.of<DarkThemeProvider>(context1);
          //                                                controller.selectedType.value = servicesModel;
          return StatefulBuilder(builder: (context1, setState) {
            return Obx(
                  () => Container(
                constraints: BoxConstraints(maxHeight: Responsive.height(90, context)),
                child: Padding(
                  padding:   EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                "Which vehicle is suitable for you?".tr,
                                style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(Icons.close)),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          itemCount: controller.subCategoryServiceList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            ServiceModel subcategoryModel = controller.subCategoryServiceList[index];
                            return Obx(
                                  () => Padding(
                                padding:   EdgeInsets.symmetric(vertical: 5),
                                child: InkWell(
                                  onTap: () {
                                    controller.selectedType.value = mainCategory;
                                    controller.subCategory.value = subcategoryModel;
                                    controller.calculateAmount();
                                    Get.back();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: controller.subCategory.value.id == subcategoryModel.id
                                              ? themeChange.getThem()
                                              ? AppColors.darkModePrimary
                                              : AppColors.primary
                                              : AppColors.textFieldBorder,
                                          width: 1),
                                    ),
                                    child: Padding(
                                      padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: subcategoryModel.image.toString(),
                                            fit: BoxFit.contain,
                                            height: Responsive.height(6, context),
                                            width: Responsive.width(18, context),
                                            placeholder: (context, url) => Constant.loader(),
                                            errorWidget: (context, url, error) => Image.network(Constant.userPlaceHolder),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  subcategoryModel.title.toString(),
                                                  style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w600),
                                                ),
                                                // Text(
                                                //   subcategoryModel.description.toString(),
                                                //   style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w400),
                                                // ),
                                                // const SizedBox(
                                                //   height: 5,
                                                // ),
                                                // Container(
                                                //   decoration:
                                                //   BoxDecoration(color: themeChange.getThem() ? AppColors.darkGray : AppColors.gray, borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                //   child: Padding(
                                                //       padding:   EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                                //       child: Row(
                                                //         mainAxisAlignment: MainAxisAlignment.start,
                                                //         crossAxisAlignment: CrossAxisAlignment.start,
                                                //         children: [
                                                //           // Text(
                                                //           //   "📦 len/wid/hgt :",
                                                //           //   style: GoogleFonts.cairo(fontWeight: FontWeight.w500),
                                                //           // ),
                                                //           // const SizedBox(
                                                //           //   width: 8,
                                                //           // ),
                                                //           // Text(
                                                //           //   "${freightModel.length}/${freightModel.width}/${freightModel.height}m",
                                                //           //   style: GoogleFonts.cairo(fontWeight: FontWeight.w500),
                                                //           // ),
                                                //         ],
                                                //       )),
                                                // )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }
}
void showLoadingIndicator({required String  text}) {
  showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))
            ),
            backgroundColor: Colors.black87,
            content:Container(
                padding: EdgeInsets.all(16),
                color: Colors.black87,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                          child: Container(
                              child: CircularProgressIndicator(
                                  strokeWidth: 3
                              ),
                              width: 32,
                              height: 32
                          ),
                          padding: EdgeInsets.only(bottom: 16)
                      ),
                      Padding(
                          child: Text(
                            'Please wait …',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16
                            ),
                            textAlign: TextAlign.center,
                          ),
                          padding: EdgeInsets.only(bottom: 4)
                      ),
                      Text(
                        text,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14
                        ),
                        textAlign: TextAlign.center,
                      )
                    ]
                )
            ),
          )
      );
    },
  );
}
void hideOpenDialog() {
  Navigator.of(Get.context!).pop();
}