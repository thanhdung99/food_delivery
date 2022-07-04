import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Container( alignment: Alignment.center,
      height: Dimensions.height20 * 5,
      width: Dimensions.width20 * 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius20 * 5/2),
        color: AppColors.mainColor
      ),
      child: CircularProgressIndicator(),
    ));
  }
}
