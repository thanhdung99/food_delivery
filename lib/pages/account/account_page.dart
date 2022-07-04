import 'package:flutter/material.dart';
import 'package:food_delivery/base/custom_loader.dart';
import 'package:food_delivery/controllers/auth_controller.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/controllers/location_controller.dart';
import 'package:food_delivery/controllers/user_controller.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/account_widget.dart';
import 'package:food_delivery/widgets/app_icon.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:get/get.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (_userLoggedIn && Get
        .find<UserController>()
        .userModel == null) {
      Get.find<UserController>().getUserInfo();
      Get.find<LocationController>().getAddressList();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: BigText(text: "Profile", size: 40, color: Colors.white,),
      ),
      body: GetBuilder<UserController>(builder: (userController) {
        return _userLoggedIn
            ? (userController.isLoading ? CustomLoader() : Container(
          width: double.maxFinite,
          margin: EdgeInsets.only(top: Dimensions.height20),
          child: Column(
            children: [
              //profile icon
              AppIcon(
                icon: Icons.person,
                backgroundColor: AppColors.mainColor,
                iconColor: Colors.white,
                iconSize: Dimensions.iconSize16 * 5,
                size: Dimensions.height15 * 10,),
              Expanded(child: SingleChildScrollView(child: Column(
                children: [
                  //name
                  SizedBox(height: Dimensions.height20,),
                  AccountWidget(appIcon: AppIcon(
                    icon: Icons.person,
                    backgroundColor: AppColors.mainColor,
                    iconColor: Colors.white,
                    iconSize: Dimensions.height10 * 5 / 2,
                    size: Dimensions.height10 * 5,),
                      bigText: BigText(
                        text: '${userController.userModel?.name}',)
                  ),
                  //phone
                  SizedBox(height: Dimensions.height20,),
                  AccountWidget(appIcon: AppIcon(
                    icon: Icons.phone,
                    backgroundColor: AppColors.yellowColor,
                    iconColor: Colors.white,
                    iconSize: Dimensions.height10 * 5 / 2,
                    size: Dimensions.height10 * 5,),
                      bigText: BigText(
                        text: '${userController.userModel?.phone}',)
                  ),
                  //email
                  SizedBox(height: Dimensions.height20,),
                  AccountWidget(appIcon: AppIcon(
                    icon: Icons.email,
                    backgroundColor: AppColors.yellowColor,
                    iconColor: Colors.white,
                    iconSize: Dimensions.height10 * 5 / 2,
                    size: Dimensions.height10 * 5,),
                      bigText: BigText(
                        text: '${userController.userModel?.email}',)
                  ),
                  //address
                  SizedBox(height: Dimensions.height20,),
                  GetBuilder<LocationController>(builder: (locationController) {
                    return GestureDetector(
                      onTap: () {
                        Get.offNamed(RouteHelper.getAddressPage());
                      },
                      child: AccountWidget(appIcon: AppIcon(
                        icon: Icons.location_on,
                        backgroundColor: AppColors.yellowColor,
                        iconColor: Colors.white,
                        iconSize: Dimensions.height10 * 5 / 2,
                        size: Dimensions.height10 * 5,),
                          bigText: BigText(text:
                          locationController.addressList.isEmpty
                              ? "Fill in your address"
                              : "Your address",)
                      ),
                    );
                  }),
                  //message
                  SizedBox(height: Dimensions.height20,),
                  AccountWidget(appIcon: AppIcon(
                    icon: Icons.message_outlined,
                    backgroundColor: Colors.redAccent,
                    iconColor: Colors.white,
                    iconSize: Dimensions.height10 * 5 / 2,
                    size: Dimensions.height10 * 5,),
                      bigText: BigText(text: "Messages",)
                  ),
                  SizedBox(height: Dimensions.height20,),
                  GestureDetector(
                    onTap: () {
                      if (Get.find<AuthController>().userLoggedIn()) {
                        Get.find<AuthController>().clearSharedData();
                        Get.find<UserController>().clearData();
                        Get.find<CartController>().clear();
                        Get.find<CartController>().clearCartHistory();
                        Get.toNamed(RouteHelper.getSignInPage());
                      }
                    },
                    child: AccountWidget(
                        appIcon: AppIcon(
                          icon: Icons.logout,
                          backgroundColor: Colors.redAccent,
                          iconColor: Colors.white,
                          iconSize: Dimensions.height10 * 5 / 2,
                          size: Dimensions.height10 * 5,),
                        bigText: BigText(text: "Logout",)
                    ),
                  )
                ],),),)
            ],
          ),
        )) : Container(child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.maxFinite,
              height: Dimensions.width20 * 8,
              margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  image: DecorationImage(
                    image: AssetImage("assets/image/signintocontinue.png"),
                    fit: BoxFit.cover,
                  )
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(RouteHelper.getSignInPage());
              },
              child: Container(
                width: double.maxFinite,
                height: Dimensions.width20 * 5,
                margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                decoration: BoxDecoration(color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                ),
                child: Center(child: BigText(text: "Sign in",
                  color: Colors.white, size: Dimensions.font26,),),
              ),
            ),
          ],
        ),),);
      },),
    );
  }
}
