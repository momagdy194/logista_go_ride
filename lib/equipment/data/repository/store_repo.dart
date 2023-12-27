
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:customer/equipment/controller/localization_controller.dart';
import 'package:customer/equipment/controller/location_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/data/api/api_client.dart';
import 'package:customer/equipment/data/model/response/address_model.dart';
import 'package:customer/equipment/util/app_constants.dart';

class StoreRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  StoreRepo({required this.sharedPreferences, required this.apiClient});

  Future<Response> getStoreList(int offset, String filterBy) async {
    return await apiClient.getData('${AppConstants.storeUri}/$filterBy?offset=$offset&limit=10');
  }

  Future<Response> getPopularStoreList(String type) async {
    return await apiClient.getData('${AppConstants.popularStoreUri}?type=$type');
  }

  Future<Response> getLatestStoreList(String type) async {
    return await apiClient.getData('${AppConstants.latestStoreUri}?type=$type');
  }

  Future<Response> getFeaturedStoreList() async {
    return await apiClient.getData('${AppConstants.storeUri}/all?featured=1&offset=1&limit=50');
  }

  Future<Response> getStoreDetails(String storeID, bool fromCart) async {
    Map<String, String>? header ;
    if(fromCart){
      AddressModel? addressModel = Get.find<EQLocationController>().getUserAddress();
      header = apiClient.updateHeader(
        sharedPreferences.getString(AppConstants.token), addressModel?.zoneIds, addressModel?.areaIds,
        Get.find<EQLocalizationController>().locale.languageCode,
        Get.find<EQSplashControllerEquip>().module == null ? Get.find<EQSplashControllerEquip>().cacheModule!.id : Get.find<EQSplashControllerEquip>().module!.id,
        addressModel?.latitude, addressModel?.longitude, setHeader: false,
      );
    }
    return await apiClient.getData('${AppConstants.storeDetailsUri}$storeID', headers: header);
  }

  Future<Response> getStoreItemList(int? storeID, int offset, int? categoryID, String type) async {
    return await apiClient.getData(
      '${AppConstants.storeItemUri}?store_id=$storeID&category_id=$categoryID&offset=$offset&limit=10&type=$type',
    );
  }

  Future<Response> getStoreSearchItemList(String searchText, String? storeID, int offset, String type) async {
    return await apiClient.getData(
      '${AppConstants.searchUri}items/search?store_id=$storeID&name=$searchText&offset=$offset&limit=10&type=$type',
    );
  }

  Future<Response> getStoreReviewList(String? storeID) async {
    return await apiClient.getData('${AppConstants.storeReviewUri}?store_id=$storeID');
  }
  
  Future<Response> getStoreRecommendedItemList(int? storeId) async {
    return await apiClient.getData('${AppConstants.storeRecommendedItemUri}?store_id=$storeId&offset=1&limit=50');
  }

  Future<Response> getCartStoreSuggestedItemList(int? storeId) async {
    AddressModel? addressModel = Get.find<EQLocationController>().getUserAddress();
    Map<String, String> header = apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.token), addressModel?.zoneIds, addressModel?.areaIds,
      Get.find<EQLocalizationController>().locale.languageCode,
      Get.find<EQSplashControllerEquip>().module == null ? Get.find<EQSplashControllerEquip>().cacheModule!.id : Get.find<EQSplashControllerEquip>().module!.id,
      addressModel?.latitude, addressModel?.longitude, setHeader: false,
    );
    return await apiClient.getData('${AppConstants.cartStoreSuggestedItemsUri}?recommended=1&store_id=$storeId&offset=1&limit=50', headers: header);
  }

}