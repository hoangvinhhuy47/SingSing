
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';


class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;

  const PasswordTextField({
    Key? key,
    required this.controller,
    this.hintText
  }) : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isShowPassword = false;
  String? _hintText = '';

  @override
  void initState() {
    _hintText = widget.hintText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        TextField(
          key: widget.key,
          style: s(context, fontSize: 16, color: Colors.white),
          controller: widget.controller,
          autocorrect: false,
          enableSuggestions: false,
          obscureText: !isShowPassword,
          obscuringCharacter: '*',
          maxLength: 255,

          // onChanged: widget.onChanged,
          // keyboardType: _inputType,
          // inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            counterText: '',
            hintText: _hintText,
            hintStyle: s(context, fontSize: 16, color: const Color(0xFF525974)),
            fillColor: ColorUtil.bgTextFieldColor,
            filled: true,
            contentPadding: const EdgeInsets.fromLTRB(18, 14, 50, 14),
            disabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(width: 1, color: ColorUtil.bgTextFieldColor),
            ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: ColorUtil.bgTextFieldColor)),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(width: 1, color: ColorUtil.bgTextFieldColor),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(width: 1, color: Color(0xFF6C34FF)),
            ),
          ),
        ),
        Positioned(
            right: 2,
            top: 2,
            bottom: 2,
            child: GestureDetector(
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  height: 20,
                  child: SvgPicture.asset(assetImg(isShowPassword ? 'ic_eye_open.svg' : 'ic_eye_close.svg')),
                ),
              ),
              onTap: () => toggleShowHidePassword(),
            )
        ),
      ],
    );
  }

  void toggleShowHidePassword() {
    setState(() {
      isShowPassword = !isShowPassword;
    });
  }
}
