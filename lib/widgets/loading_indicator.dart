import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sing_app/utils/color_util.dart';

enum IndicatorType { spinKitWave }

class LoadingIndicator extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final double opacity;
  final Color color;
  final String text;

  const LoadingIndicator(
      {Key? key,
      required this.isLoading,
      required this.child,
      this.opacity = 0,
      this.color = Colors.grey,
      this.text = ''})
      : super(key: key);

  // final spinKit = SpinKitWave(
  //   color: ColorUtil.white,
  //   size: 30,
  // );
  final spinKit = const SpinKitRing(
    color: Colors.white,
    lineWidth: 2,
    size: 32,
  );

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetList = [];
    widgetList.add(child);

    if (isLoading) {
      final modal = Stack(
        children: [
          Opacity(
            opacity: opacity,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          Center(
            child: Container(
              width: text.isNotEmpty ? 100 : 80,
              height: text.isNotEmpty ? 100 : 80,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.5),
                //     blurRadius: 5.0, // has the effect of softening the shadow
                //     spreadRadius: 3.0, // has the effect of extending the shadow
                //     // offset: Offset(
                //     //   0.0, // horizontal, move right 10
                //     //   0.0, // vertical, move down 10
                //     // ),
                //   )
                // ],
                color: ColorUtil.mainGrey.withOpacity(0.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  spinKit,
                  Visibility(
                    visible: text.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        text,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}
