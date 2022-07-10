import 'dart:convert';
import 'dart:core';

import 'package:flutter/widgets.dart';
import 'package:food_delivery/data/api/api_checker.dart';
import 'package:food_delivery/data/repository/location_repo.dart';
import 'package:food_delivery/models/address_model.dart';
import 'package:food_delivery/models/response_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/src/places.dart';

class LocationController extends GetxController implements GetxService {
  LocationRepo locationRepo;

  LocationController({required this.locationRepo});

  bool _loading = false;
  bool get loading => _loading;

  // for service zone
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // whether the user is in the zone or not
  bool _inZone = false;
  bool get inZone => _inZone;

  // showing and hiding button
  bool _buttonDisabled = false;
  bool get buttonDisabled => _buttonDisabled;

  // save the google maps suggestions for address
  List<Prediction> _predictionList = [];
  List<Prediction> get predictionList => _predictionList;

  late Position _position;
  Position get position => _position;

  late Position _pickPosition;
  Position get pickPosition => _pickPosition;

  late Map<String, dynamic> _getAddress;
  Map get getAddress => _getAddress;

  Placemark _placemark = Placemark();
  Placemark get placemark => _placemark;

  Placemark _pickPlacemark = Placemark();
  Placemark get pickPlacemark => _pickPlacemark;

  List<AddressModel> _addressList = [];
  List<AddressModel> get addressList => _addressList;

  late List<AddressModel> _allAddressList;
  List<AddressModel> get allAddressList => _allAddressList;

  List<String> _addressTypeList = ["home", "office", "others"];
  List<String> get addressTypeList => _addressTypeList;


  bool _updateAddressData = true;
  bool _changeAddress = true;

  int _addressTypeIndex = 0;
  int get addressTypeIndex => _addressTypeIndex;

  late GoogleMapController _mapController;
  GoogleMapController get mapController => _mapController;

  Future<void> getCurrentLocation(bool fromAddress,
  {required GoogleMapController mapController, LatLng? defaultLatLng,
    bool notify = true}) async {
    _mapController = mapController;
    try{
      Position myPosition = await Geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (fromAddress) {
        _position = Position(timestamp: DateTime.now(),
            longitude: myPosition.longitude, latitude: myPosition.latitude,
            accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
      } else {
        _pickPosition = Position(timestamp: DateTime.now(),
            longitude: myPosition.longitude, latitude: myPosition.latitude,
            accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
      }
    }catch(e) {
      print(e.toString());
    }
  }

  void setMapController(GoogleMapController mapController){
    _mapController = mapController;
  }
  Future<void> updatePosition(CameraPosition position, bool fromAddress) async {
    if(_updateAddressData){
      _loading = true;
      try {
        if (fromAddress) {
          _position = Position(longitude: position.target.longitude,
              latitude: position.target.latitude,
              timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1,
              speed: 1, speedAccuracy: 1);
        } else {
          _pickPosition = Position(longitude: position.target.longitude,
              latitude: position.target.latitude,
              timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1,
              speed: 1, speedAccuracy: 1);
        }
        ResponseModel _responseModel = await getZone(
            position.target.latitude.toString(),
            position.target.latitude.toString(), false);
        _buttonDisabled = _responseModel.isSuccess;

        if (_changeAddress) {
          String _address = await getAddressFromGeocode(
              LatLng(position.target.latitude, position.target.longitude)
          );
          fromAddress ? _placemark = Placemark(name: _address)
              : _pickPlacemark = Placemark(name: _address);
        } else {
          _changeAddress = true;
        }
      }catch(e){
        print(e.toString());
      }
      _loading = false;
      update();
    } else{
      _updateAddressData = true;
    }
  }

  Future<String> getAddressFromGeocode(LatLng latLng) async {
    String _address = "Unknown Location Found";
    Response response  = await locationRepo.getAddressFromGeocode(latLng);
    if(response.body['status'] == "OK"){
      _address = response.body["results"][0]["formatted_address"];
      print("address: " + _address);
    }else{
      print("error");
    }
    update();
    return _address;
  }

  AddressModel getUserAddress() {
    late AddressModel _addressModel;
    _getAddress = jsonDecode(locationRepo.getUserAddress());
    try {
      _addressModel =
          AddressModel.fromJson(jsonDecode(locationRepo.getUserAddress()));
    } catch (e) {
      print(e);
    }
    return _addressModel;
  }

  void setAddressTypeIndex(int index){
    _addressTypeIndex = index;
    update();
  }

  Future<ResponseModel> addAddress(AddressModel addressModel) async {
    _loading = true;
    update();
    Response response = await locationRepo.addAddress(addressModel);
    ResponseModel responseModel;
    if(response.statusCode == 200){
      await getAddressList();
      String message = response.body['message'];
      responseModel = ResponseModel(true, message);
      await saveUserAddress(addressModel);
    } else{
      responseModel = ResponseModel(false, response.statusText!);
    }
    _loading = false;
    update();
    return responseModel;
  }

  Future<void> getAddressList() async {
    Response response = await locationRepo.getAllAddress();
    if(response.statusCode == 200){
      _addressList =[];
      _allAddressList = [];
      response.body.forEach((address){
        _addressList.add(AddressModel.fromJson(address));
        _allAddressList.add(AddressModel.fromJson(address));
      });
    } else{
      _addressList =[];
      _allAddressList = [];
    }
    update();
  }
  Future<bool> saveUserAddress(AddressModel addressModel) async {
    String userAddress = jsonEncode(addressModel.toJson());
    print("Saved address is " + userAddress);
    return await locationRepo.saveUserAddress(userAddress);
  }
  String getUserAddressFromLocalStorage(){
    return locationRepo.getUserAddress();
  }
  void setAddressData(){
    _position = _pickPosition;
    _placemark = _pickPlacemark;
    _updateAddressData = false;
    update();
  }
  getZone(String lat, String lng, bool markerLoad) async {
    late ResponseModel _responseModel;
    if(markerLoad){
      _loading == true;
    } else {
      _isLoading =true;
    }
    update();

    Response response = await locationRepo.getZone(lat, lng);
    if(response.statusCode == 200){
      _inZone = true;
      _responseModel = ResponseModel(false, response.body['zone_id'].toString());
    } else{
      _inZone = false;
      _responseModel = ResponseModel(false, response.statusText!);
    }

    if(markerLoad){
      _loading == false;
    } else {
      _isLoading =false;
    }
    update();
    return _responseModel;
  }
  Future<List<Prediction>> searchLocation(BuildContext context, String text) async {
    if(text.isNotEmpty){
      Response response = await locationRepo.searchLocation(text);
      if(response.statusCode==200 && response.body['status'] == 'OK'){
        _predictionList =[];
        response.body['predictions'].forEach((prediction) =>
            _predictionList.add(Prediction.fromJson(prediction)));
      }else{
        ApiChecker.checkApi(response);
      }
    }
    return _predictionList;
  }
  Future<void> setLocation(String placeID, String address, GoogleMapController mapController) async{
   _loading = true;
   update();
   PlacesDetailsResponse detail;
   Response response = await locationRepo.setLocation(placeID);
   if(response.statusCode==200 && response.body['status'] == 'OK'){
     detail = PlacesDetailsResponse.fromJson(response.body);
     _pickPosition = Position(timestamp: DateTime.now(),
         longitude: detail.result.geometry!.location.lng,
         latitude: detail.result.geometry!.location.lat,
         accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
     _pickPlacemark = Placemark(name: address);
     _changeAddress = false;
     if(!mapController.isNull) {
       mapController.animateCamera(CameraUpdate.newCameraPosition(
           CameraPosition(target: LatLng(
             detail.result.geometry!.location.lat,
             detail.result.geometry!.location.lng,
           ), zoom: 17)));
     }
   }else{
     ApiChecker.checkApi(response);
   }
   _loading = false;
   update();
  }
}