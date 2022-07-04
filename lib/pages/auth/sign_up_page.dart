import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/base/custom_loader.dart';
import 'package:food_delivery/base/show_custom_snackbar.dart';
import 'package:food_delivery/controllers/auth_controller.dart';
import 'package:food_delivery/models/sign_up_body_model.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/app_text_field.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:get/get.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    var signUpImages = [
      "t.png",
      "f.png",
      "g.png",
    ];
    void _registration(AuthController authController) {
      String name = nameController.text.trim();
      String phone = phoneController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if (name.isEmpty) {
        showCustomSnackBar("Type in your name", title: "Name");
      } else if (phone.isEmpty) {
        showCustomSnackBar("Type in your phone number", title: "Phone number");
      } else if (email.isEmpty) {
        showCustomSnackBar("Type in your email address",
            title: "Email address");
      } else if (!GetUtils.isEmail(email)) {
        showCustomSnackBar("Type in a valid email address",
            title: "Valid email address");
      } else if (password.isEmpty) {
        showCustomSnackBar("Type in your password", title: "Password");
      } else if (password.length < 6) {
        showCustomSnackBar("Password can not be less than six characters",
            title: "Password");
      } else {
        SignUpBody signUpBody = SignUpBody(
            email: email, name: name, password: password, phone: phone);
        authController.registation(signUpBody).then((status) {
          if (status.isSuccess) {
            Get.offNamed(RouteHelper.getInitial());
          } else {
            showCustomSnackBar(status.message);
          }
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(builder: (_authController) {
        return _authController.isLoading
            ? CustomLoader()
            : SingleChildScrollView(physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: Dimensions.screenHeight * 0.075,),
              // app logo
              Container(
                child: Center(
                  child: CircleAvatar(backgroundColor: Colors.white,
                    radius: Dimensions.radius20 * 4,
                    backgroundImage: AssetImage("assets/image/logo part 1.png"),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height20,),
              //your email
              AppTextField(textController: emailController,
                  hintText: "Email",
                  icon: Icons.email),
              SizedBox(height: Dimensions.height20,),
              //your password
              AppTextField(textController: passwordController, isObsecure: true,
                  hintText: "Password ",
                  icon: Icons.password_sharp),
              SizedBox(height: Dimensions.height20,),
              // your phone
              AppTextField(textController: phoneController,
                  hintText: "Phone",
                  icon: Icons.phone),
              SizedBox(height: Dimensions.height20,),
              // your name
              AppTextField(textController: nameController,
                  hintText: "Name",
                  icon: Icons.person),
              SizedBox(height: Dimensions.height20 * 2,),
              // signup button
              GestureDetector(
                onTap: () {
                  _registration(_authController);
                },
                child: Container(
                  width: Dimensions.screenWidth / 2,
                  height: Dimensions.screenHeight / 13,
                  decoration: BoxDecoration(color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                  ),
                  child: Center(
                    child: BigText(text: "Sign up", color: Colors.white,
                      size: Dimensions.font20 + Dimensions.font20 / 2,),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10,),
              // tag line
              RichText(
                text: TextSpan(text: "Have an account already?",
                    style: TextStyle(color: Colors.grey[500],
                      fontSize: Dimensions.font20,),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.back()
                ),
              ),
              SizedBox(height: Dimensions.screenHeight * 0.05,),
              // sign up options
              RichText(
                text: TextSpan(style: TextStyle(color: Colors.grey[500],
                  fontSize: Dimensions.font16,),
                  text: "Sign up using one of the following methods",
                ),
              ),
              Wrap(
                children: List.generate(3, (index) =>
                    Padding(padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: Dimensions.radius30,
                        backgroundImage: AssetImage(
                            "assets/image/${signUpImages[index]}"
                        ),
                      ),
                    ),
                ),
              )
            ],
          ),
        );
      },),
    );
  }
}
