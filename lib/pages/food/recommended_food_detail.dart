import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/controllers/recommended_product_controller.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/app_column.dart';
import 'package:food_delivery/widgets/app_icon.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/expandable_text_widget.dart';
import 'package:get/get.dart';

class RecommendedFoodDetail extends StatelessWidget {
  final int pageId;
  final String page;

  const RecommendedFoodDetail(
      {Key? key, required this.pageId, required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var product = Get
        .find<RecommendedProductController>()
        .recommendedProductList[pageId];
    Get.find<RecommendedProductController>()
        .initProduct(product, Get.find<CartController>());
    return Scaffold(backgroundColor: Colors.white,
      body: Stack(
        children: [
          // background image
          Positioned(left: 0, right: 0,
            child: Container(width: double.maxFinite,
              height: Dimensions.popularFoodImgSize,
              decoration: BoxDecoration(image: DecorationImage(fit: BoxFit
                  .cover,
                image: NetworkImage(AppConstants.BASE_URL +
                    AppConstants.UPLOADS_URL + product.img!
                ),
              )),
            ),
          ),
          // icon widgets
          Positioned(top: Dimensions.height45,
              left: Dimensions.width20, right: Dimensions.width20,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [GestureDetector(
                  onTap: () {
                    if (page == 'cart-page') {
                      Get.toNamed(RouteHelper.getCartPage());
                    } else if (page == 'home') {
                      Get.toNamed(RouteHelper.getInitial());
                    }
                  },
                  child: const AppIcon(icon: Icons.arrow_back_ios),
                ),
                  GetBuilder<RecommendedProductController>(
                      builder: (controller) {
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(RouteHelper.getCartPage());
                          },
                          child: Stack(
                            children: [
                              const AppIcon(icon: Icons.shopping_cart_outlined),
                              controller.totalItems >= 1 ? Positioned(
                                top: 0, right: 0,
                                child: AppIcon(icon: Icons.circle, size: 20,
                                  iconColor: Colors.transparent,
                                  backgroundColor: AppColors.mainColor,),
                              )
                                  : Container(),
                              controller.totalItems >= 1
                                  ? Positioned(
                                  top: 3, right: 3,
                                  child: BigText(
                                    text: controller.totalItems.toString(),
                                    color: Colors.white, size: 12,)
                              )
                                  : Container()
                            ],
                          ),
                        );
                      }
                  )
                ],
              )
          ),
          // introduction of food
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: Dimensions.popularFoodImgSize - Dimensions.height20,
            child: Container(padding: EdgeInsets.only(top: Dimensions.height20,
              left: Dimensions.width20, right: Dimensions.width20,),
              decoration: BoxDecoration(borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Dimensions.radius20),
                  topLeft: Radius.circular(Dimensions.radius20)
              ),
                color: Colors.white,
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppColumn(text: product.name!,),
                  SizedBox(height: Dimensions.height20,),
                  BigText(text: "Introduce"),
                  SizedBox(height: Dimensions.height20,),
                  Expanded(child: SingleChildScrollView(
                      child: ExpandableTextWidget(
                          text: product.description!)),
                  ),
                ],
              ),
            ),
          )
          //expandable text widget
        ],
      ),
      bottomNavigationBar: GetBuilder<RecommendedProductController>(
          builder: (recommendedProducts) {
            return Container(height: Dimensions.bottomHeightBar,
              padding: EdgeInsets.symmetric(vertical: Dimensions.height30,
                  horizontal: Dimensions.width20),
              decoration: BoxDecoration(
                  color: AppColors.buttonBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radius20 * 2),
                    topRight: Radius.circular(Dimensions.radius20 * 2),
                  )
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(padding: EdgeInsets.all(Dimensions.width20),
                    decoration: BoxDecoration(color: Colors.white,
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                    ),
                    child: Row(children: [
                      GestureDetector(
                          onTap: () {
                            recommendedProducts.setQuantity(false);
                          },
                          child: Icon(Icons.remove, color: AppColors.signColor)
                      ),
                      SizedBox(width: Dimensions.height10 / 2,),
                      BigText(text: '${recommendedProducts.inCartItems}',),
                      SizedBox(width: Dimensions.height10 / 2,),
                      GestureDetector(
                          onTap: () {
                            recommendedProducts.setQuantity(true);
                          },
                          child: Icon(Icons.add, color: AppColors.signColor,)
                      ),
                    ],),
                  ),
                  Container(
                    padding: EdgeInsets.all(Dimensions.width20),
                    decoration: BoxDecoration(color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        recommendedProducts.addItem(product);
                      },
                      child: BigText(
                        text: "\$ ${product.price!.toString()} | Add to cart",
                        color: Colors.white,),
                    ),
                  )
                ],
              ),
            );
          }
      ),
    );
  }
}