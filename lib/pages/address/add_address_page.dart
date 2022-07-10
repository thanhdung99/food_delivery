import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery/controllers/auth_controller.dart';
import 'package:food_delivery/controllers/location_controller.dart';
import 'package:food_delivery/controllers/user_controller.dart';
import 'package:food_delivery/models/address_model.dart';
import 'package:food_delivery/pages/address/pick_address_map.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/app_text_field.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({Key? key}) : super(key: key);

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactPersonNameController = TextEditingController();
  final TextEditingController _contactPersonNumberController = TextEditingController();
  late bool _isLogged;
  late LatLng _initialPosition = const LatLng(10.83721, 106.830614);
  CameraPosition _cameraPosition = const CameraPosition(
      target: LatLng(10.83721, 106.830614), zoom: 17);

  @override
  void initState() {
    super.initState();
    _isLogged = Get.find<AuthController>().userLoggedIn();
    if (_isLogged && Get.find<UserController>().userModel == null) {
      Get.find<UserController>().getUserInfo();
    }

    if (Get.find<LocationController>().addressList.isNotEmpty) {
      if (Get.find<LocationController>().getUserAddressFromLocalStorage() == "") {
        Get.find<LocationController>().saveUserAddress(Get.find<LocationController>().addressList.last);
      }
      Get.find<LocationController>().getUserAddress();
      _cameraPosition = CameraPosition(target: LatLng(
        double.parse(Get.find<LocationController>().getAddress['latitude']),
        double.parse(Get.find<LocationController>().getAddress['longitude']),
      ));
      _initialPosition = LatLng(
        double.parse(Get.find<LocationController>().getAddress['latitude']),
        double.parse(Get.find<LocationController>().getAddress['longitude']),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Address Page"),
          backgroundColor: AppColors.mainColor,),
        body: GetBuilder<UserController>(builder: (userController) {
          if (userController.userModel != null && _contactPersonNameController.text.isEmpty) {

            _contactPersonNameController.text = '${userController.userModel?.name}';
            _contactPersonNumberController.text = '${userController.userModel?.phone}';

            if (Get.find<LocationController>().addressList.isEmpty) {
              _addressController.text = Get.find<LocationController>().getUserAddress().address ?? '';
            }
          }
          return GetBuilder<LocationController>(builder: (locationController) {
            _addressController.text =
            '${locationController.placemark.name ?? ""}'
                '${locationController.placemark.locality ?? ""}'
                '${locationController.placemark.postalCode ?? ""}'
                '${locationController.placemark.country ?? ""}';
            print("address is" + _addressController.text);
            return SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 140,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: AppColors.mainColor, width: 2,),
                    ),
                    child: Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: _initialPosition, zoom: 17),
                          zoomControlsEnabled: false,
                          compassEnabled: false,
                          indoorViewEnabled: true,
                          mapToolbarEnabled: false,
                          myLocationEnabled: true,
                          onCameraIdle: () {
                            locationController.updatePosition(
                                _cameraPosition, true);
                          },
                          onCameraMove: ((position) =>
                          _cameraPosition = position),
                          onMapCreated: (GoogleMapController controller) {
                            locationController.setMapController(controller);
                          },
                          onTap: (latlng) {
                            Get.toNamed(RouteHelper.getPickAddressPage(),
                                arguments: PickAddressMap(fromSignUp: false,
                                  fromAddress: true,
                                  googleMapController: locationController
                                      .mapController,)
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: Dimensions.width20,
                      top: Dimensions.height20),
                    child: SizedBox(height: 50,
                      child: ListView.builder(shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: locationController.addressTypeList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              locationController.setAddressTypeIndex(index);
                            },
                            child: Container(padding: EdgeInsets.symmetric(
                                vertical: Dimensions.height10,
                                horizontal: Dimensions.width20),
                                margin: EdgeInsets.only(
                                    right: Dimensions.width10),
                                decoration: BoxDecoration(
                                    color: (Theme
                                        .of(context)
                                        .cardColor),
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radius20 / 4),
                                    boxShadow: [BoxShadow(spreadRadius: 1,
                                      blurRadius: 5, color: Colors.grey[200]!,)
                                    ]),
                                child: Icon(index == 0 ? Icons.home_filled
                                    : index == 1 ? Icons.work
                                    : Icons.location_on,
                                  color: locationController.addressTypeIndex ==
                                      index ? AppColors.mainColor : Theme.of(context).disabledColor,
                                )
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height20,),
                  Padding(padding: EdgeInsets.only(left: Dimensions.width20),
                    child: BigText(text: "Delivery Address"),),
                  SizedBox(height: Dimensions.height10,),
                  AppTextField(textController: _addressController,
                    icon: Icons.map, hintText: "Your address",),
                  SizedBox(height: Dimensions.height20,),
                  Padding(padding: EdgeInsets.only(left: Dimensions.width20),
                    child: BigText(text: "Contact Name"),),
                  SizedBox(height: Dimensions.height10,),
                  AppTextField(textController: _contactPersonNameController,
                    icon: Icons.person, hintText: "Your name",),
                  SizedBox(height: Dimensions.height20,),
                  Padding(padding: EdgeInsets.only(left: Dimensions.width20),
                    child: BigText(text: "Your phone number"),),
                  SizedBox(height: Dimensions.height10,),
                  AppTextField(textController: _contactPersonNumberController,
                    icon: Icons.phone, hintText: "Your phone number",),
                ],),
            );
          },);
        },),
        bottomNavigationBar: GetBuilder<LocationController>(
          builder: (locationController) {
            return Column(mainAxisSize: MainAxisSize.min,
              children: [Container(height: Dimensions.height20 * 8,
                padding: EdgeInsets.symmetric(vertical: Dimensions.height30,
                  horizontal: Dimensions.width20,),
                decoration: BoxDecoration(
                    color: AppColors.buttonBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radius20 * 2),
                      topRight: Radius.circular(Dimensions.radius20 * 2),
                    )
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [GestureDetector(onTap: () {
                    AddressModel _addressModel = AddressModel(
                        addressType: locationController.addressTypeList
                        [locationController.addressTypeIndex],
                        contactPersonName: _contactPersonNameController.text,
                        contactPersonNumber: _contactPersonNumberController
                            .text,
                        address: _addressController.text,
                        longitude: '${locationController.position.longitude}',
                        latitude: '${locationController.position.latitude}'
                    );

                    locationController.addAddress(_addressModel).then((
                        response) {
                      if (response.isSuccess) {
                        Get.toNamed(RouteHelper.getInitial());
                        Get.snackbar("Address", "Add successful");
                      } else {
                        Get.snackbar("Address", "Couldn't save address");
                      }
                    });
                  },
                    child: Container(
                      padding: EdgeInsets.all(Dimensions.width20),
                      child: BigText(text: "Save address", color: Colors.white,
                        size: Dimensions.font26,),
                      decoration: BoxDecoration(color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(
                            Dimensions.radius20),
                      ),
                    ),
                  )
                  ],
                ),
              )
              ],
            );
          },
        )
    );
  }
}