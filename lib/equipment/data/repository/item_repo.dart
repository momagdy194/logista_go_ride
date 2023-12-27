import 'package:customer/equipment/data/api/api_client.dart';
import 'package:customer/equipment/data/model/body/review_body.dart';
import 'package:customer/equipment/util/app_constants.dart';
import 'package:get/get.dart';

class ItemRepo extends GetxService {
  final ApiClient apiClient;
  ItemRepo({required this.apiClient});

  Future<Response> getPopularItemList(String type, {year, version_id}) async {
    return await apiClient.getData(
        '${AppConstants.popularItemUri}?type=$type&year=${year ?? ""}&version_id=${version_id ?? ""}',
        query: {
          "year": year,
          "version_id": version_id,
        });
  }

  Future<Response> getReviewedItemList(String type, {year, version_id}) async {
    return await apiClient.getData(
        '${AppConstants.reviewedItemUri}?type=$type&year=${year ?? ""}&version_id=${version_id ?? ""}',
        query: {
          "year": year,
          "version_id": version_id,
        });
  }

  Future<Response> submitReview(ReviewBody reviewBody) async {
    return await apiClient.postData(
        AppConstants.reviewUri, reviewBody.toJson());
  }

  Future<Response> submitDeliveryManReview(ReviewBody reviewBody) async {
    return await apiClient.postData(
        AppConstants.deliveryManReviewUri, reviewBody.toJson());
  }

  Future<Response> getItemDetails(int? itemID) async {
    return apiClient.getData('${AppConstants.itemDetailsUri}$itemID');
  }
}
