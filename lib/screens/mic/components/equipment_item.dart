import 'package:flutter/material.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/data/models/song_model.dart';
import 'package:sing_app/utils/alert_songdemo.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/border_outline.dart';
import 'package:sing_app/widgets/radius_widget.dart';

class EquipmentItem extends StatefulWidget {
  const EquipmentItem({
    Key? key,
    required this.onPressedChangeEquip,
  }) : super(key: key);

  @override
  State<EquipmentItem> createState() => _EquipmentItem();
  final void Function() onPressedChangeEquip;
}

class _EquipmentItem extends State<EquipmentItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMicItem(context),
        const SizedBox(height: MyStyles.verticalMargin),
        _buildAttributes(context)
      ],
    );
  }

  Widget _buildMicItem(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        BorderOutLine(
          backgroundItem: ColorUtil.backgroundSecondary,
          colorOutline: ColorUtil.lightBlue,
          height: 320,
          width: width - 40,
          borderRadius: BorderRadius.circular(0),
          alignment: Alignment.center,
          margin: const EdgeInsets.only(bottom: 24),
          child: ImageUtil.loadAssetsImage(
            fileName: 'ic_mic_market.png',
            width: 200,
            height: 200,
          ),
        ),
        _button(context),
      ],
    );
  }

  Widget _button(BuildContext context) {
    SongModel? songModel;
    return Positioned(
        bottom: 0,
        child: ActionChip(
          label: Text('Change', style: s(context, fontSize: 16)),
          backgroundColor: ColorUtil.primary,
          avatar: ImageUtil.loadAssetsImage(fileName: 'ic_exchange.svg'),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          onPressed: () {
            // widget.onPressedChangeEquip();
            alertSongDemo(context, songModel);
          },
        ));
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
