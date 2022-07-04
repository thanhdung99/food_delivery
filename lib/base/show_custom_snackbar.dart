import 'package:flutter/material.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:get/get.dart';

void showCustomSnackBar (String message, {bool isError=true, String title="Error"}) {
  Get.snackbar(title, message, snackPosition: SnackPosition.TOP,
      titleText: BigText(text: title, color: Colors.white),
      messageText: Text(message, style: const TextStyle(color: Colors.white,),),
      colorText: Colors.white, backgroundColor: Colors.redAccent);
}