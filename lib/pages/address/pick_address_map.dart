import 'package:flutter/material.dart';
import 'package:food_delivery/base/custom_button.dart';
import 'package:food_delivery/controllers/location_controller.dart';
import 'package:food_delivery/pages/address/widgets/search_location_dialogue.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickAddressMap extends StatefulWidget {
  final bool fromSignUp;
  final bool fromAddress;
  final GoogleMapController? googleMapController;

  const PickAddressMap({Key? key, required this.fromSignUp,
    required this.fromAddress, this.googleMapController}) : super(key: key);
  @override
  State<PickAddressMap> createState() => _PickAddressMapState();
}

class _PickAddressMapState extends State<PickAddressMap> {
  late LatLng _initialPosition;
  late GoogleMapController _mapController;
  late CameraPosition _cameraPosition;

  @override
  void initState() {
    super.initState();
    if (Get.find<LocationController>().addressList.isEmpty) {
      _initialPosition = const LatLng(45.51563, -122.677433);
    } else if (Get.find<LocationController>().addressList.isNotEmpty) {
      _initialPosition = LatLng(
        double.parse(Get.find<LocationController>().getAddress['latitude']),
        double.parse(Get.find<LocationController>().getAddress['longitude']),
      );
    }
    _cameraPosition = CameraPosition(target: _initialPosition, zoom: 17);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(builder: (locationController) {
      return Scaffold(
        body: SafeArea(child: Center(child: SizedBox(width: double.maxFinite,
          child: Stack(children: [
            GoogleMap(zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                  target: _initialPosition, zoom: 17
              ),
              onCameraIdle: () {
                locationController.updatePosition(_cameraPosition, false);
              },
              onCameraMove: ((position) => _cameraPosition = position),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                if(!widget.fromAddress){

                }
              },
            ),
            Center(child: locationController.loading
                ? const CircularProgressIndicator()
                : Image.asset("assets/image/pick_marker.png",
              height: 50, width: 50,),),
            Positioned(left: Dimensions.width20, right: Dimensions.width20,
              top: Dimensions.height45,
              child: InkWell(
                onTap: () =>Get.dialog(LocationDialogue(mapController: _mapController)),
                child: Container(height: 50,
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                  decoration: BoxDecoration(color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(Dimensions.radius20 / 2)
                  ),
                  child: Row(children: [
                    Icon(Icons.location_on, size: 25, color:
                    AppColors.yellowColor,),
                    Expanded(child: Text(
                      locationController.pickPlacemark.name ?? '',
                      style: TextStyle(color: Colors.white,
                          fontSize: Dimensions.font16),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    )),
                    SizedBox(width: Dimensions.width10,),
                    Icon(Icons.search, size: 25, color: AppColors.yellowColor,)
                  ],),
                ),
              ),
            ),
            Positioned(left: Dimensions.width20, right: Dimensions.width20,
                bottom: Dimensions.height20 * 4,
                child: locationController.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : CustomButton(
                  width: !locationController.inZone ? null : 200,
                  buttonText: locationController.inZone
                      ? widget.fromAddress ? 'Pick Address' : 'Pick Location'
                      : "Service is not available in your area",
                  onPressed: locationController.buttonDisabled
                      || locationController.loading ? null : () {
                    if (locationController.pickPlacemark.name != null &&
                        locationController.pickPosition.latitude != 0) {
                      if (widget.fromAddress) {
                        if (widget.googleMapController != null) {
                          widget.googleMapController!.moveCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  target: LatLng(
                                      locationController.pickPosition.latitude,
                                      locationController.pickPosition.longitude
                                  ))));
                          locationController.setAddressData();
                        }
                        Get.toNamed(RouteHelper.getAddressPage());
                      }
                    }
                  },
                )
            )
          ],),
        ),),),
      );
    });
  }
}
