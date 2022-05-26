import 'package:flutter/material.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/data/models/market.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/in_app_purchase.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/border_outline.dart';
import 'package:sing_app/widgets/ink_click_item.dart';

const double radiusBox = 5.0;
const double verticalMargin = 5.0;
const imageSize = 128.0;

class MicMarKetItem extends StatelessWidget {
  const MicMarKetItem({
    Key? key,
    required this.marketModel,
  }) : super(key: key);
  final MarketModel? marketModel;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2;
    return InkClickItem(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.marketDetailScreen,
        );
      },
      child: BorderOutLine(
        backgroundItem: ColorUtil.backgroundSecondary,
        padding: const EdgeInsets.only(left: 10, right: 10),
        borderRadius: BorderRadius.circular(radiusBox),
        width: width - 30,
        height: 300,
        colorOutline: ColorUtil.lightBlue,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(
            height: verticalMargin,
          ),
          ImageUtil.loadAssetsImage(
            fileName: 'ic_mic_market.png',
            width: imageSize,
            height: imageSize,
          ),
          const SizedBox(
            height: verticalMargin * 2,
          ),
          _buildType(context),
          const SizedBox(
            height: verticalMargin * 2,
          ),
          _buildQuality(context),
          const SizedBox(
            height: verticalMargin * 2,
          ),
          _buildQuantity(context),
          const SizedBox(
            height: verticalMargin * 2,
          ),
          _buildPrice(context),
          const SizedBox(
            height: verticalMargin * 2,
          ),
          _buildBuyNow(context)
        ]),
      ),
    );
  }

  Widget _buildType(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l('Type:'),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: s(context,
              fontSize: 14,
              color: ColorUtil.white,
              fontWeight: FontWeight.w400),
        ),
        Text(
          l(marketModel!.type),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: s(context,
              fontSize: 13,
              color: ColorUtil.white,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _buildQuality(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l('Quality:'),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: s(context,
              fontSize: 14,
              color: ColorUtil.white,
              fontWeight: FontWeight.w400),
        ),
        Text(
          l(marketModel!.quality),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: s(context,
              fontSize: 13,
              color: ColorUtil.white,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _buildQuantity(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l('Quantity:'),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: s(context,
              fontSize: 14,
              color: ColorUtil.white,
              fontWeight: FontWeight.w400),
        ),
        Text(
          l(marketModel!.quantity),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: s(context,
              fontSize: 13,
              color: ColorUtil.white,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _buildPrice(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l('Price:'),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: s(context,
              fontSize: 14,
              color: ColorUtil.white,
              fontWeight: FontWeight.w400),
        ),
        Text(
          l(marketModel!.price + "\$"),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: s(context,
              fontSize: 14, color: ColorUtil.gold, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _buildBuyNow(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2;
    return GestureDetector(
      onTap: () {
        _paymentMicOnApple(context, marketModel!.quality);
      },
      child: Container(
        height: 32,
        width: width - 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: ColorUtil.formItemFocusedBorder,
            borderRadius: BorderRadius.circular(radiusBox * 5)),
        child: Text(
          l("Buy Now"),
          maxLines: 1,
          style: s(context,
              fontSize: 16,
              color: ColorUtil.white,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  void _paymentMicOnApple(BuildContext context, String tier) {
    requestPurchase(tier);
  }
}
