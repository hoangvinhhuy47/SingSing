
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/widgets/buttons/gradient_button.dart';

class LoginRegisterView extends StatelessWidget {
  final void Function()? onLoginPressed;
  final void Function()? onRegisterPressed;

  const LoginRegisterView({
    Key? key,
    this.onLoginPressed,
    this.onRegisterPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 292,
        height: 300,
        child: Column(
          children: [
            ImageUtil.loadAssetsImage(fileName: 'logo_singsing.svg', height: 57),
            SizedBox.fromSize(size: const Size(0, 15),),
            Text(l('Hi there,'),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  color: ColorUtil.white
              ),
            ),
            SizedBox.fromSize(size: const Size(0, 15),),
            Text(l('Welcome to SingSing'),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: ColorUtil.white
              ),
            ),
            SizedBox.fromSize(size: const Size(0, 35),),
            Row(
              children: [
                Expanded(child: GradientButton(
                  text: l("Login".toUpperCase()),
                  colors: ColorUtil.defaultGradientButton,
                  onPressed: onLoginPressed,
                )),
                SizedBox.fromSize(size: const Size(20, 0),),
                Expanded(child: GradientButton(
                  text: l("Register".toUpperCase()),
                  colors: const [Color(0xFF4A16DB)],
                  onPressed: onRegisterPressed,
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}