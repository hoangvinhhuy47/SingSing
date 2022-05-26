import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils/color_util.dart';
import '../utils/styles.dart';

class IndicatorLoadMore extends StatelessWidget {
  final EdgeInsets? padding;

  const IndicatorLoadMore({Key? key, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(vertical: MyStyles.verticalMargin),
      child: const SpinKitRing(
        color: ColorUtil.primary,
        lineWidth: 2,
        size: 22,
      ),
    );
  }
}
