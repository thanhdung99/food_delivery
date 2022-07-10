import 'package:flutter/material.dart';
import 'package:food_delivery/base/custom_button.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:get/get.dart';

class OrderSuccessPage extends StatelessWidget {
  final String orderID;
  final int status;

  const OrderSuccessPage({required this.orderID, required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == 0) {
      Future.delayed(Duration(seconds: 1), () {

      });
    }
    return Scaffold(body: Center(child: SizedBox(width: Dimensions.screenWidth,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(status == 1 ? "assets/image/checked.png"
            : "assets/image/warning.png", width: 100, height: 100,),
        SizedBox(height: Dimensions.height45,),
        Text(
          status == 1 ? "You placed the order successful" : "Your order fail",
          style: TextStyle(fontSize: Dimensions.font20),),
        SizedBox(height: Dimensions.height20,),
        Padding(padding: EdgeInsets.symmetric(vertical: Dimensions.height10,
            horizontal: Dimensions.width20),
          child: Text(status == 1 ? "Successful Order " : "Order failed",
            style: TextStyle(fontSize: Dimensions.font20, color: Theme
                .of(context)
                .disabledColor,),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: Dimensions.height10,),
        Padding(padding: EdgeInsets.all(Dimensions.height10), child:
        CustomButton(buttonText: "Back to home", onPressed: () =>
            Get.offAllNamed(RouteHelper.getInitial())
          ,),)
      ],),
    ),),);
  }
}
