import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/controllers/popular_product_controller.dart';
import 'package:food_delivery/controllers/recommended_product_controller.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/app_icon.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/expandable_text_widget.dart';
import 'package:get/get.dart';

class PopularFoodDetail extends StatelessWidget {
  final int pageId;
  final String page;

  const PopularFoodDetail({Key? key, required this.pageId, required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var popularProduct = Get
        .find<PopularProductController>()
        .popularProductList[pageId];
    Get.find<RecommendedProductController>()
        .initProduct(popularProduct, Get.find<CartController>());

    return Scaffold(backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 70,
            title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (page == 'cart-page') {
                      Get.toNamed(RouteHelper.getCartPage());
                    } else if (page == 'home') {
                      Get.toNamed(RouteHelper.getInitial());
                    }
                  },
                  child: AppIcon(icon: Icons.clear),
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
                                ? Positioned(top: 3, right: 3,
                                child: BigText(color: Colors.white, size: 12,
                                  text: controller.totalItems.toString(),)
                            )
                                : Container()
                          ],
                        ),
                      );
                    }
                )
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(Dimensions.radius20),
                      topLeft: Radius.circular(Dimensions.radius20)
                  ),
                  color: Colors.white,
                ),
                child: Center(child: BigText(
                  size: Dimensions.font26, text: popularProduct.name!,),),
                width: double.maxFinite,
                padding: EdgeInsets.only(top: 5, bottom: 10),
              ),
            ),
            pinned: true,
            expandedHeight: 300,
            backgroundColor: AppColors.yellowColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                AppConstants.BASE_URL + AppConstants.UPLOADS_URL +
                    popularProduct.img!,
                width: double.maxFinite, fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(child: ExpandableTextWidget(
                  text: popularProduct.description,),
                  margin: EdgeInsets.symmetric(horizontal: Dimensions.width20,),
                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: GetBuilder<RecommendedProductController>(
        builder: (controller) {
          return Column(mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: Dimensions.height10,
                  horizontal: Dimensions.width20 * 2.5,),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.setQuantity(false);
                      },
                      child: AppIcon(
                        icon: Icons.remove, iconSize: Dimensions.iconSize24,
                        iconColor: Colors.white,
                        backgroundColor: AppColors.mainColor,
                      ),
                    ),
                    BigText(text: "\$${popularProduct.price!}  X  ${controller
                        .inCartItems}",
                      color: AppColors.mainBlackColor,
                      size: Dimensions.font26,),
                    GestureDetector(
                      onTap: () {
                        controller.setQuantity(true);
                      },
                      child: AppIcon(
                        icon: Icons.add, iconSize: Dimensions.iconSize24,
                        iconColor: Colors.white,
                        backgroundColor: AppColors.mainColor,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: Dimensions.bottomHeightBar,
                padding: EdgeInsets.symmetric(vertical: Dimensions.height30,
                  horizontal: Dimensions.width20,),
                decoration: BoxDecoration(
                    color: AppColors.buttonBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radius20 * 2),
                      topRight: Radius.circular(Dimensions.radius20 * 2),
                    )
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(Dimensions.width20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            Dimensions.radius20), color: Colors.white,),
                      child: Icon(Icons.favorite, color: AppColors.mainColor,),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.addItem(popularProduct);
                      },
                      child: Container(
                        padding: EdgeInsets.all(Dimensions.width20),
                        decoration: BoxDecoration(color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(
                              Dimensions.radius20),),
                        child: BigText(color: Colors.white,
                          text: "\$ ${popularProduct.price!} | Add to cart",),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
