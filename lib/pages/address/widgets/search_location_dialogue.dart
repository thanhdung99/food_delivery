import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:food_delivery/controllers/location_controller.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/src/places.dart';


class LocationDialogue extends StatelessWidget {
  final GoogleMapController mapController;

  const LocationDialogue({required this.mapController, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Container(padding: EdgeInsets.all(Dimensions.height10),
      alignment: Alignment.topCenter,
      child: Material(shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius20),
      ),
        child: SizedBox(
          width: Dimensions.screenWidth,
          child: TypeAheadField(textFieldConfiguration: TextFieldConfiguration(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(hintText: "search location",
                  hintStyle: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontSize: Dimensions.font16,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(style: BorderStyle.none,
                          width: 0)
                  )
              )
          ),
            onSuggestionSelected: (Prediction suggestion) async {
              Get.find<LocationController>().setLocation(
                  suggestion.placeId!, suggestion.description!, mapController
              );
              Get.back();
            },
            suggestionsCallback: (pattern) async {
              return await Get.find<LocationController>()
                  .searchLocation(context, pattern);
            },
            itemBuilder: (BuildContext context, Prediction suggestions) {
              return Padding(padding: EdgeInsets.all(Dimensions.width10),
                child: Row(children: [ Icon(Icons.location_on), Expanded(
                  child: Text(suggestions.description!, maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      fontSize: Dimensions.font20,
                    ),
                  ),
                ),

                ],),
              );
            },
          ),
        ),
      ),
    );
  }
}
