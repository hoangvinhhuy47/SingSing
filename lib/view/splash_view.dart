
import 'package:flutter/material.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';

class SplashView extends StatefulWidget {

  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}


class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1E2336)
          // gradient: LinearGradient(
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //     colors: [Color(0xFF233764), Color(0xFF193F93),],
          // ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 200,
              child: Column(
                children: [
                  ImageUtil.loadAssetsImage(
                    fileName: 'logo_singsing_purple.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 25),
                  ImageUtil.loadAssetsImage(
                      fileName: 'text_singsing.svg'
                  ),
                  // SizedBox(
                  //   height: 5,
                  //   width: 150,
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(2.5),
                  //     child: LinearProgressIndicator(
                  //       value: _animation.value,
                  //       backgroundColor: ColorUtil.white,
                  //       valueColor: const AlwaysStoppedAnimation<Color>(ColorUtil.textBlueColor),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            // Positioned(
            //   left: 0,
            //   bottom: 0,
            //   child: ImageUtil.loadAssetsImage(
            //     fileName: 'launch_image_logo.png',
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
