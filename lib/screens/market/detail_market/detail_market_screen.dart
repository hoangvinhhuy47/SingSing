import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/detail_market/detail_market_bloc.dart';
import 'package:sing_app/blocs/detail_market/detail_market_state.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/in_app_purchase.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/border_outline.dart';
import 'package:sing_app/widgets/ink_click_item.dart';
import 'package:sing_app/widgets/radius_widget.dart';
import 'package:sing_app/widgets/s2e_appbar.dart';

class DetailMarketScreen extends StatefulWidget {
  const DetailMarketScreen({Key? key}) : super(key: key);

  @override
  State<DetailMarketScreen> createState() => _DetailMarketScreen();
}

late DetailMarketScreenBloc _bloc;
const double radiusBox = 5.0;
const double verticalMargin = 5.0;
const imageSize = 10.0;

class _DetailMarketScreen extends State<DetailMarketScreen> {
  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DetailMarketScreenBloc, DetailMarketScreenState>(
        builder: (context, state) {
          return _buildBody();
        },
        listener: (ctx, state) {});
  }

  Future<void> onRefresh() async {}
  Widget _buildBody() {
    return RefreshIndicator(
      color: ColorUtil.primary,
      backgroundColor: ColorUtil.backgroundPrimary,
      onRefresh: onRefresh,
      child: Scaffold(
        appBar: S2EAppBar(
          automaticallyImplyLeading: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildMicItem(context),
            const SizedBox(
              height: MyStyles.verticalMargin,
            ),
            _buildBuyNow(context),
            const SizedBox(
              height: MyStyles.verticalMargin,
            ),
            _buildDetail(context),
            const SizedBox(
              height: MyStyles.verticalMargin,
            ),
            _buildAttributes(context)
          ],
        ),
      ),
    );
  }

  Widget _buildMicItem(BuildContext context) {
    return InkClickItem(
      onTap: () {},
      child: BorderOutLine(
        backgroundItem: ColorUtil.backgroundSecondary,
        borderRadius: BorderRadius.circular(radiusBox),
        width: MediaQuery.of(context).size.width - 20,
        height: 300,
        padding: const EdgeInsets.symmetric(horizontal: verticalMargin * 5),
        colorOutline: ColorUtil.lightBlue,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(
            height: verticalMargin * 5,
          ),
          ImageUtil.loadAssetsImage(
            fileName: 'ic_mic_market.png',
            width: imageSize * 22,
            height: imageSize * 22,
          ),
        ]),
      ),
    );
  }

  Widget _buildBuyNow(BuildContext context) {
    return RadiusWidget(
      height: 120,
      borderRadius: BorderRadius.circular(5),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width - 40,
      color: ColorUtil.backgroundSecondary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPrice(context),
          GestureDetector(
            onTap: () {
              requestPurchase('Gold');
            },
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width - 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: ColorUtil.primary,
                  borderRadius: BorderRadius.circular(radiusBox * 5)),
              child: Text(
                l("Buy Now"),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 16,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrice(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l('Price'),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: s(context,
              fontSize: 20,
              color: ColorUtil.white,
              fontWeight: FontWeight.bold),
        ),
        Text(
          l("100\$"),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: s(context,
              fontSize: 20, color: ColorUtil.gold, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDetail(BuildContext context) {
    return RadiusWidget(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      borderRadius: BorderRadius.circular(5),
      width: MediaQuery.of(context).size.width - 40,
      color: ColorUtil.backgroundSecondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l('Details'),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: s(context,
                fontSize: 20,
                color: ColorUtil.white,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: MyStyles.verticalMargin,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l('Type:'),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 16,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                l("Professtional"),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 16,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          const SizedBox(
            height: MyStyles.verticalMargin,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l('Quality:'),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 16,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                l("Gold"),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 16,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          const SizedBox(
            height: MyStyles.verticalMargin,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l('ID'),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 16,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                l("#650392146"),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 16,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttributes(BuildContext context) {
    return RadiusWidget(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      borderRadius: BorderRadius.circular(5),
      width: MediaQuery.of(context).size.width - 40,
      color: ColorUtil.backgroundSecondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l('Attributes'),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 20,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                l("View details"),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 14,
                    color: ColorUtil.cyan,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          const SizedBox(
            height: MyStyles.verticalMargin,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l('Durability:'),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 16,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                l("20/20"),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 16,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          const SizedBox(
            height: MyStyles.verticalMargin,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l('Atrophy:'),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 16,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                l("20/20"),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 16,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          const SizedBox(
            height: MyStyles.verticalMargin,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l('Luck:'),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 16,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                l("10"),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 16,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          const SizedBox(
            height: MyStyles.verticalMargin,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l('Energy:'),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 16,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                l("10/10"),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 16,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          const SizedBox(
            height: MyStyles.verticalMargin,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l('Earning bonus:'),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 16,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                l("10"),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 16,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          const SizedBox(
            height: MyStyles.verticalMargin,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l('Earning range:'),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 16,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                l("50 - 100"),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 16,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
