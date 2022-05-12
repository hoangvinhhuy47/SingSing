import 'package:flutter/material.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/styles.dart';

class GradientButton extends StatelessWidget {
  final String? text;
  final double width;
  final double height;
  final List<Color>? colors;
  final double borderRadius;
  final void Function()? onPressed;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry padding;

  const GradientButton({
    Key? key,
    this.text,
    this.width = 267,
    this.height = 48,
    this.colors,
    this.borderRadius = 24,
    this.onPressed,
    this.titleStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: colors?.first?.withOpacity(0.5) ?? Colors.white,
        //     offset: const Offset(0, 8),
        //     blurRadius: 16.0,
        //   )
        // ],colors
        //[const Color(0xFFBF26E5), const Color(0xFF3C14DA)]
        gradient: colors != null && colors!.length > 1
            ? LinearGradient(colors: colors!)
            : null,
        color: colors != null && colors!.isNotEmpty ? colors!.first : null,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: padding,
          child: Text(
            text ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: titleStyle ??
                MyStyles.of(context)
                    .buttonTextStyle()
                    .copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class DefaultGradientButton extends GradientButton {
  const DefaultGradientButton({
    Key? key,
    String? text,
    TextStyle? titleStyle,
    Function()? onPressed,
    double? width,
    double? height,
  }) : super(key: key, text: text, colors: ColorUtil.defaultGradientButton, titleStyle: titleStyle, onPressed: onPressed, width: width ?? 250, height: height ?? 48);
}

class DefaultButton extends GradientButton {
  const DefaultButton({
    Key? key,
    String? text,
    TextStyle? titleStyle,
    double? width,
    double? height,
    Function()? onPressed,
  }) : super(key: key, text: text, colors: ColorUtil.defaultButton, titleStyle: titleStyle, onPressed: onPressed, width: width ?? 250, height: height ?? 48);
}