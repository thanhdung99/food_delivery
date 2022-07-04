import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/data/repository/recommended_product_repo.dart';
import 'package:food_delivery/models/cart_model.dart';
import 'package:food_delivery/models/products_model.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:get/get.dart';

class RecommendedProductController extends GetxController {
  final RecommendedProductRepo recommendedProductRepo;

  RecommendedProductController({ required this.recommendedProductRepo});

  List<dynamic> _recommendedProductList = [];
  List<dynamic> get recommendedProductList => _recommendedProductList;

  late CartController  _cart;
  CartController get cart => _cart;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  int _quantity = 0;
  int get quantity => _quantity;

  int _inCartItems = 0;
  int get inCartItems => _inCartItems + _quantity;

  Future<void> getRecommendedProductList() async {
    Response response = await recommendedProductRepo
        .getRecommendedProductList();
    if (response.statusCode == 200) {
      _recommendedProductList = [];
      _recommendedProductList.addAll(Product
          .fromJson(response.body)
          .products);
      _isLoaded = true;
      update();
    } else {

    }
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = checkQuantity(_quantity + 1);
    } else if (!isIncrement) {
      _quantity = checkQuantity(_quantity - 1);
    }
    update();
  }

  int checkQuantity(int quantity) {
    if ((_inCartItems + quantity) < 0) {
      Get.snackbar("Item count", "You can't reduce more",
          colorText: Colors.white,
          backgroundColor: AppColors.mainColor);
      return 0 - _inCartItems;
    }
    else if ((_inCartItems + quantity) > 20) {
      Get.snackbar("Item count", "You can't add more",
          colorText: Colors.white,
          backgroundColor: AppColors.mainColor);
      return 20 - _inCartItems;
    }
    else {
      return quantity;
    }
  }

  void initProduct(ProductModel product, CartController cart) {
    _quantity = 0;
    _inCartItems = 0;
    _cart = cart;

    var exist = false;
    exist = _cart.existInCart(product);
    print("exist "+ exist.toString());
    if(exist){
      _inCartItems = cart.getQuantity(product);
    }
    print("in cart items: " + _inCartItems.toString());
  }

  void addItem(ProductModel product){
        _cart.addItem(product, _quantity);

        _quantity = 0;
        _inCartItems = _cart.getQuantity(product);
        update();
  }

  int get totalItems => _cart.totalItems;
  List<CartModel> get getItems{
    return _cart.getItems;
  }
}