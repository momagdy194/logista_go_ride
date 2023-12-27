import 'dart:convert';

import 'package:customer/custom_ride/constant/constant.dart';
import 'package:customer/custom_ride/controller/dash_board_controller.dart';
import 'package:customer/custom_ride/model/airport_model.dart';
import 'package:customer/custom_ride/model/banner_model.dart';
import 'package:customer/custom_ride/model/contact_model.dart';
import 'package:customer/custom_ride/model/order/location_lat_lng.dart';
import 'package:customer/custom_ride/model/payment_model.dart';
import 'package:customer/custom_ride/model/service_model.dart';
import 'package:customer/custom_ride/themes/app_colors.dart';
import 'package:customer/custom_ride/utils/Preferences.dart';
import 'package:customer/custom_ride/utils/fire_store_utils.dart';
import 'package:customer/custom_ride/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends GetxController {


  String taxiCarId="dq6e41OEG9MKIMfj4LOR";
  String cargoShipping="veKlgXB6BDX7IRz9t78D";


  DashBoardController dashboardController = Get.put(DashBoardController());

  Rx<TextEditingController> sourceLocationController = TextEditingController().obs;
  Rx<TextEditingController> destinationLocationController = TextEditingController().obs;
  Rx<TextEditingController> offerYourRateController = TextEditingController().obs;
  Rx<ServiceModel> selectedType = ServiceModel().obs;
  Rx<ServiceModel> subCategory = ServiceModel().obs;

  Rx<LocationLatLng> sourceLocationLAtLng = LocationLatLng().obs;
  Rx<LocationLatLng> destinationLocationLAtLng = LocationLatLng().obs;

  RxString currentLocation = "".obs;
  RxBool isLoading = true.obs;
  RxBool isLoadingSubCat = true.obs;
  RxList serviceList = <ServiceModel>[].obs;
  RxList subCategoryServiceList = <ServiceModel>[].obs;
  RxList bannerList = <BannerModel>[].obs;
  final PageController pageController = PageController(viewportFraction: 0.96, keepPage: true);

  var colors = [
    AppColors.containerBackground,
    AppColors.containerBackground,
    AppColors.containerBackground,
    // AppColors.serviceColor1,
    // AppColors.serviceColor2,
    // AppColors.serviceColor3,
  ];

  @override
  void onInit() {
    // TODO: implement onInit
    // getServiceType();
    getServiceByCategory();
    getPaymentData();
    getContact();
    super.onInit();
  }

  // getServiceType() async {
  //   await FireStoreUtils.getService().then((value) {
  //     serviceList.value = value;
  //     if (serviceList.isNotEmpty) {
  //       selectedType.value = serviceList.first;
  //     }
  //   });
  //
  //   await FireStoreUtils.getBanner().then((value) {
  //     bannerList.value = value;
  //   });
  //
  //   isLoading.value = false;
  //
  //   await Utils.getCurrentLocation().then((value) {
  //     Constant.currentLocation = value;
  //   });
  //   await placemarkFromCoordinates(Constant.currentLocation!.latitude, Constant.currentLocation!.longitude).then((value) {
  //     Placemark placeMark = value[0];
  //
  //     currentLocation.value = "${placeMark.name}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.administrativeArea}, ${placeMark.postalCode}, ${placeMark.country}";
  //   }).catchError((error) {
  //     debugPrint("------>${error.toString()}");
  //   });
  // }

  getServiceByCategory() async {
    await FireStoreUtils.getServiceMainCategory().then((value) {
      serviceList.value = value;
      if (serviceList.isNotEmpty) {
        // selectedType.value = serviceList.first;
      }
    });

    await FireStoreUtils.getBanner().then((value) {
      bannerList.value = value;
    });

    isLoading.value = false;

    await Utils.getCurrentLocation().then((value) {
      Constant.currentLocation = value;
    });
    await placemarkFromCoordinates(Constant.currentLocation!.latitude, Constant.currentLocation!.longitude).then((value) {
      Placemark placeMark = value[0];

      currentLocation.value = "${placeMark.name}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.administrativeArea}, ${placeMark.postalCode}, ${placeMark.country}";
    }).catchError((error) {
      debugPrint("------>${error.toString()}");
    });
  }



  getServiceSubCategory({required parentCategoryId}) async {
    isLoadingSubCat.value=true;
    await FireStoreUtils.getServiceSubCategory(parentCategoryId:parentCategoryId ).then((value) {
      subCategoryServiceList.value = value;
      if (subCategoryServiceList.isNotEmpty) {
        // selectedType.value = serviceList.first;
      }
    });
    isLoadingSubCat.value=true;
  }



  RxString duration = "".obs;
  RxString distance = "".obs;
  RxString amount = "".obs;

  calculateAmount() async {
    if (sourceLocationLAtLng.value.latitude != null && destinationLocationLAtLng.value.latitude != null) {
      await Constant.getDurationDistance(
              LatLng(sourceLocationLAtLng.value.latitude!, sourceLocationLAtLng.value.longitude!), LatLng(destinationLocationLAtLng.value.latitude!, destinationLocationLAtLng.value.longitude!))
          .then((value) {
        if (value != null) {
          duration.value = value.rows!.first.elements!.first.duration!.text.toString();
          if (Constant.distanceType == "Km") {
            distance.value = (value.rows!.first.elements!.first.distance!.value!.toInt() / 1000).toString();
            amount.value = Constant.amountCalculate(selectedType.value.kmCharge.toString(), distance.value).toStringAsFixed(Constant.currencyModel!.decimalDigits!);
          } else {
            distance.value = (value.rows!.first.elements!.first.distance!.value!.toInt() / 1609.34).toString();
            amount.value = Constant.amountCalculate(selectedType.value.kmCharge.toString(), distance.value).toStringAsFixed(Constant.currencyModel!.decimalDigits!);
          }
        }
      });
    }
  }

  Rx<PaymentModel> paymentModel = PaymentModel().obs;

  RxString selectedPaymentMethod = "".obs;

  RxList airPortList = <AriPortModel>[].obs;

  getPaymentData() async {
    await FireStoreUtils().getPayment().then((value) {
      if (value != null) {
        paymentModel.value = value;
      }
    });
  }

  RxList<ContactModel> contactList = <ContactModel>[].obs;
  Rx<ContactModel> selectedTakingRide = ContactModel(fullName: "Myself", contactNumber: "").obs;
  Rx<AriPortModel> selectedAirPort = AriPortModel().obs;

  setContact() {
    print(jsonEncode(contactList));
    Preferences.setString(Preferences.contactList, json.encode(contactList.map<Map<String, dynamic>>((music) => music.toJson()).toList()));
    getContact();
  }

  getContact() {
    String contactListJson = Preferences.getString(Preferences.contactList);

    if (contactListJson.isNotEmpty) {
      print("---->");
      contactList.clear();
      contactList.value = (json.decode(contactListJson) as List<dynamic>).map<ContactModel>((item) => ContactModel.fromJson(item)).toList();
    }
  }
}
