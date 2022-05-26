
import 'package:flutter/material.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';

class NoInternetWidget extends StatelessWidget {

  final Function onPressedRetry;

  const NoInternetWidget({
    Key? key,
    required this.onPressedRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
              ImageUtil.loadAssetsImage(
                fileName: 'ic_no_internet.svg',
              ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(l('No internet connection!'),
              textAlign: TextAlign.center,
              style: s(context, fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white, height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          _buildButton(context),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(60 / 2),
      child: Material(
        color: ColorUtil.primary,
        child: InkWell(
          onTap: () => onPressedRetry(),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 7,
              horizontal: 14,
            ),
            child: Text(l('Retry'),
              textAlign: TextAlign.center,
              style: s(context, color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
            ),
          ),
        ),
      ),
    );
    return Container();
  }
}
