import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/widgets/buttons/gradient_button.dart';

class LoginRegisterView extends StatelessWidget {
  final void Function()? onLoginPressed;
  final void Function()? onRegisterPressed;
  final void Function()? onSettingsPressed;

  const LoginRegisterView({
    Key? key,
    required this.onLoginPressed,
    required this.onRegisterPressed,
    required this.onSettingsPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 292,
        // height: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageUtil.loadAssetsImage(fileName: 'logo_singsing_purple.png', height: 80),
            const SizedBox(height: 15),
            Text(l('Hi there,'),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  color: ColorUtil.white
              ),
            ),
            const SizedBox(height: 15),
            Text(
              l('Welcome to SingSing'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: ColorUtil.white
              ),
            ),
            const SizedBox(height: 28),
            GradientButton(
              text: l("LOGIN"),
              colors: ColorUtil.defaultGradientButton,
              onPressed: onLoginPressed,
              isShadow: false,
            ),
            const SizedBox(height: 16),
            GradientButton(
              text: l("REGISTER"),
              colors: ColorUtil.defaultGradientButton,
              isShadow: false,
              onPressed: onRegisterPressed,
            ),
            const SizedBox(height: 16),
            GradientButton(
              text: l("SETTINGS"),
              colors: const [Color(0xFF33394F)],
              onPressed: onSettingsPressed
            )
          ],
        ),
      ),
    );
  }
}