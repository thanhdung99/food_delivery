import 'package:flutter/material.dart';
import 'package:food_delivery/base/no_data_page.dart';
import 'package:food_delivery/base/show_custom_snackbar.dart';
import 'package:food_delivery/controllers/auth_controller.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/controllers/location_controller.dart';
import 'package:food_delivery/controllers/order_controller.dart';
import 'package:food_delivery/controllers/popular_product_controller.dart';
import 'package:food_delivery/controllers/recommended_product_controller.dart';
import 'package:food_delivery/controllers/user_controller.dart';
import 'package:food_delivery/models/place_order_model.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/app_icon.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/small_text.dart';
import 'package:get/get.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [Positioned(
        top: Dimensions.height20 * 3,
        left: Dimensions.width20, right: Dimensions.width20,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [AppIcon(icon: Icons.arrow_back_ios,
            iconColor: Colors.white,
            backgroundColor: AppColors.mainColor,
            iconSize: Dimensions.iconSize24,),
            SizedBox(width: Dimensions.width20 * 5,),
            GestureDetector(
              onTap: () {
                Get.toNamed(RouteHelper.getInitial());
              },
              child: AppIcon(icon: Icons.home_outlined, iconColor: Colors.white,
                backgroundColor: AppColors.mainColor,
                iconSize: Dimensions.iconSize24,),
            ),
            AppIcon(icon: Icons.shopping_cart,
              iconColor: Colors.white,
              backgroundColor: AppColors.mainColor,
              iconSize: Dimensions.iconSize24,),
          ],)
    ), GetBuilder<CartController>(builder: (_cartController) {
      return _cartController.getItems.length > 0 ? Positioned(bottom: 0,
          top: Dimensions.height20 * 5,
          left: Dimensions.width20,
          right: Dimensions.width20,
          child: Container(margin: EdgeInsets.only(
              top: Dimensions.height15),
            child: MediaQuery.removePadding(context: context,
              removeTop: true,
              child: GetBuilder<CartController>(builder: (cartController) {
                var _cartList = cartController.getItems;
                return ListView.builder(itemBuilder: (_, index) {
                  return Container(width: double.maxFinite,
                    height: Dimensions.height20 * 5,
                    child: Row(children: [GestureDetector(
                      onTap: () {
                        var recommendedIndex = Get
                            .find<RecommendedProductController>()
                            .recommendedProductList
                            .indexWhere((product) =>
                        product.name!.toString() == _cartList[index].name);
                        if (recommendedIndex >= 0) {
                          Get.toNamed(RouteHelper.getRecommendFood(
                              recommendedIndex, "cart-page"));
                        } else {
                          var popularIndex = Get
                              .find<PopularProductController>()
                              .popularProductList
                              .indexWhere((product) =>
                          product.name!.toString() == _cartList[index].name);
                          Get.toNamed(RouteHelper.getPopularFood(popularIndex,
                              "cart-page"));
                          if (popularIndex < 0) {
                            Get.snackbar("History product",
                                "Product review is not available for this product",
                                backgroundColor: AppColors.mainColor,
                                colorText: Colors.white
                            );
                          }
                        }
                      },
                      child: Container(width: Dimensions.width20 * 5,
                        height: Dimensions.height20 * 5,
                        margin: EdgeInsets.only(bottom: Dimensions.height10),
                        decoration: BoxDecoration(image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(AppConstants.BASE_URL +
                              AppConstants.UPLOADS_URL +
                              cartController.getItems[index].img!),
                        ),
                            borderRadius: BorderRadius.circular(
                                Dimensions.radius20),
                            color: Colors.white
                        ),
                      ),
                    ),
                      SizedBox(width: Dimensions.width10,),
                      Expanded(child: Container(height: Dimensions.height20 * 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [BigText(
                            text: cartController.getItems[index].name!,
                            color: Colors.black54,),
                            SmallText(text: "Spicy"),
                            Row(mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                              children: [
                                BigText(text: "\$ ${cartController
                                    .getItems[index].price!}",
                                  color: Colors.redAccent,),
                                Container(
                                  padding: EdgeInsets.all(Dimensions.width10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radius20),
                                    color: Colors.white,
                                  ),
                                  child: Row(children: [GestureDetector(
                                      onTap: () {
                                        cartController.addItem(
                                            _cartList[index].product!, -1);
                                      },
                                      child: Icon(Icons.remove,
                                          color: AppColors.signColor)
                                  ),
                                    SizedBox(width: Dimensions.height10 / 2,),
                                    BigText(
                                        text: '${_cartList[index].quantity!}'),
                                    SizedBox(width: Dimensions.height10 / 2,),
                                    GestureDetector(
                                        onTap: () {
                                          cartController.addItem(
                                              _cartList[index].product!, 1);
                                        },
                                        child: Icon(Icons.add,
                                          color: AppColors.signColor,)
                                    ),
                                  ]),
                                ),
                              ],
                            )
                          ],
                        ),
                      ))
                    ]),
                  );
                }, itemCount: _cartList.length,);
              }),
            ),
          )) : NoDataPage(text: "Your cart is empty!");
    })
    ],), bottomNavigationBar: GetBuilder<CartController>(
        builder: (cartController) {
          return Container(height: Dimensions.bottomHeightBar,
            padding: EdgeInsets.symmetric(vertical: Dimensions.height30,
              horizontal: Dimensions.width20,),
            decoration: BoxDecoration(color: AppColors.buttonBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.radius20 * 2),
                  topRight: Radius.circular(Dimensions.radius20 * 2),
                )
            ),
            child: cartController.getItems.length > 0 ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Container(padding: EdgeInsets.all(Dimensions.width20),
                decoration: BoxDecoration(color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                ),
                child: Row(children: [
                  SizedBox(width: Dimensions.height10 / 2,),
                  BigText(text: '\$ ${cartController.totalAmount}',),
                  SizedBox(width: Dimensions.height10 / 2,),
                ],),
              ),
                GestureDetector(
                  onTap: () {
                    if (Get.find<AuthController>().userLoggedIn()) {
                      if (Get
                          .find<LocationController>()
                          .addressList
                          .isEmpty) {
                        Get.toNamed(RouteHelper.getAddressPage());
                      } else {
                        // Get.offNamed(RouteHelper.getInitial());
                        var location = Get.find<LocationController>()
                            .getUserAddress();
                        var cart = Get.find<CartController>()
                            .getItems;
                        var user = Get.find<UserController>().userModel;
                        PlaceOrderBody _placeOrder = PlaceOrderBody(cart: cart,
                          orderAmount: 100,
                          orderNote: 'not about the food',
                          address: location.address,
                          latitude: location.latitude,
                          longitude: location.longitude,
                          contactPersonName: user!.name,
                          contactPersonNumber: user!.phone,
                          scheduleAt: '', distance: 10.0,
                        );
                        Get.find<OrderController>().placeOrder(_placeOrder,_callback);
                      }
                    } else {
                      Get.toNamed(RouteHelper.getSignInPage());
                    }
                  },
                  child: Container(padding: EdgeInsets.all(Dimensions.width20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      color: AppColors.mainColor,),
                    child: BigText(text: "Check out", color: Colors.white,),
                  ),
                )
              ],
            ) : Container(),
          );
        }),
    );
  }
  void _callback(bool isSuccess, String message, String orderID){
    if(isSuccess){
      Get.offNamed(RouteHelper.getPaymentPage(orderID,
          Get.find<UserController>().userModel!.id));
    }else{
      showCustomSnackBar(message);
    }
  }
}
