import 'dart:convert';

import 'package:food_delivery/data/api/api_client.dart';
import 'package:food_delivery/models/address_model.dart';
import 'package:food_delivery/models/response_model.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  LocationRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getAddressFromGeocode(LatLng latLng) async {
    Response response = await apiClient.getData('${AppConstants.GEOCODE_URI}'
        '?lat=${latLng.latitude}&lng=${latLng.longitude}');
    print('URI: ${AppConstants.GEOCODE_URI}?lat=${latLng.latitude}&lng=${latLng.longitude}');
    print('response: ${response.body["results"][0]["formatted_address"]}');
    return response;
  }

  String getUserAddress() {
    AddressModel address = AddressModel(
      address: "S802 Vinhomes Grand Park, Long Thạnh Mỹ, Quận 9, Thành phố Hồ Chí Minh, Vietnam",
      longitude: '10.8372192', latitude: '106.8306147', addressType: "home");
    if (!sharedPreferences.containsKey(AppConstants.USER_ADDRESS)) {
      sharedPreferences.setString(
          AppConstants.USER_ADDRESS, jsonEncode(address));
    }
    return sharedPreferences.getString(AppConstants.USER_ADDRESS)??"";
  }

  Future<Response> addAddress(AddressModel addressModel) async {
    return await apiClient.postData(AppConstants.ADD_USER_ADDRESS,
        addressModel.toJson());
  }

  Future<Response> getAllAddress() async {
    return await apiClient.getData(AppConstants.ADDRESS_LIST_URI);
  }

  Future<bool> saveUserAddress(String address) async {
    apiClient.updateHeader(sharedPreferences.getString(AppConstants.TOKEN)!);
    return await sharedPreferences.setString(
        AppConstants.USER_ADDRESS, address);
  }

  Future<Response> getZone(String lat, String lng) async {
    return await apiClient.getData(
        '${AppConstants.ZONE_URI}?lat=$lat&lng=$lng');
  }
}