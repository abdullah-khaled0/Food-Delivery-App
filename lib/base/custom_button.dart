import 'package:flutter/material.dart';
import 'package:food_delivery/utils/dimensions.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPress;
  final String buttonText;
  final bool transparent;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fontSize;
  final double radius;
  final IconData? icon;

  const CustomButton({Key? key,
    this.onPress,
    required this.buttonText,
    this.transparent = false,
    this.margin,
    this.height,
    this.width,
    this.fontSize,
    this.radius = 5.0,
    this.icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = TextButton.styleFrom(
      backgroundColor: onPress == null ? Theme.of(context).disabledColor : transparent ? Colors.transparent : Theme.of(context).primaryColor,
      maximumSize: Size(
          width == null ? Dimensions.screeenWidth : width!,
          height != null ? height! : 50,
      ),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius)
      ),
    );

    return Center(
      child: SizedBox(
        width: width ?? Dimensions.screeenWidth,
        height: height ?? 50,
        child: TextButton(
          onPressed: onPress,
          style: buttonStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon != null ? Padding(
                  padding: EdgeInsets.only(right: Dimensions.width10 / 2),
                  child: Icon(icon, color: transparent ? Theme.of(context).primaryColor : Theme.of(context).cardColor,),
              ) : const SizedBox(),
              Text(
                buttonText,
                style: TextStyle(
                  fontSize: fontSize != null ? fontSize : Dimensions.font16,
                  color: transparent ? Theme.of(context).primaryColor : Theme.of(context).cardColor,),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
