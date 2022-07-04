import 'package:flutter/material.dart';
import 'package:food_delivery/utils/dimensions.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final bool transparent;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fontSize;
  final double radius;
  final IconData? icon;

  CustomButton({Key? key, this.onPressed, required this.buttonText, this.icon,
    this.transparent = false, this.margin, this.width, this.height,
    this.fontSize, this.radius = 5}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle _flatButton = TextButton.styleFrom(
        backgroundColor: onPressed == null
            ? Theme.of(context).disabledColor
            : transparent ? Colors.transparent : Theme.of(context).primaryColor,
        minimumSize: Size(width != null ? width! : Dimensions.screenWidth,
            height != null ? height! : 50),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius)
        )
    );
    return Center(child: SizedBox(
      width: width ?? Dimensions.screenWidth, height: height ?? 50,
      child: TextButton(
        onPressed: onPressed,
        style: _flatButton,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [icon == null ? SizedBox() : Padding(
              padding: EdgeInsets.only(right: Dimensions.width10 / 2),
              child: Icon(icon, color: transparent
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).cardColor)
          ),
            Text(buttonText, style: TextStyle(color: transparent
                ? Theme.of(context).primaryColor
                : Theme.of(context).cardColor,
                fontSize: fontSize != null ? fontSize : Dimensions.font16))
          ],
        ),
      ),
    ),);
  }
}
