import 'package:get/get_connect/http/src/response/response.dart';
import 'package:customer/equipment/data/api/api_client.dart';
import 'package:customer/equipment/util/app_constants.dart';

class ParcelRepo {
  final ApiClient apiClient;
  ParcelRepo({required this.apiClient});

  Future<Response> getParcelCategory() {
    return apiClient.getData(AppConstants.parcelCategoryUri);
  }

  Future<Response> getPlaceDetails(String? placeID) async {
    return await apiClient.getData('${AppConstants.placeDetailsUri}?placeid=$placeID');
  }

}