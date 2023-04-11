import 'package:flutter/material.dart';
import 'package:on_retouch/core/app_colors.dart';
import 'package:on_retouch/core/app_text_styles.dart';
import 'package:on_retouch/widgets/app_indicator.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.color,
    this.textColor,
    this.height,
    this.isLoading = false,
    this.width,
    this.radius = 10,
    this.isGradient = false,
    this.icon,
  }) : super(key: key);
  final String text;
  final String? icon;
  final GestureTapCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final double? height;
  final double? width;
  final bool isLoading;
  final double radius;
  final bool isGradient;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: !isGradient ? color ?? AppColors.color5CC8E4BlueGrey : null,
          gradient: isGradient
              ? const LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Color(0xff00AEF0),
                    Color(0xff0089F1),
                  ],
                )
              : null,
        ),
        height: height ?? 56,
        width: width ?? MediaQuery.of(context).size.width,
        child: isLoading
            ? const AppIndicator(color: Colors.white)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon != null
                      ? Image.asset(
                          icon!,
                          width: 32,
                        )
                      : SizedBox(),
                  SizedBox(width: icon != null ? 12 : 0),
                  Text(
                    text,
                    style: AppTextStyles.s19W700(
                      color: textColor ?? Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
