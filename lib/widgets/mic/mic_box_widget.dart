import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/constants/extension_constant.dart';
import 'package:sing_app/data/models/mic_model.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/border_outline.dart';

import '../../utils/theme_util.dart';
import '../item_row_atttributes.dart';

enum MicBoxType { micDetailSongScreen, nftDetailScreen,micScreen }

class MicBox extends StatefulWidget {
  const MicBox(
      {Key? key,
      required this.micModel,
      required this.onPressedButton,
      this.onPressedItem,
      this.micSize = 120,
      this.textButton = 'Change',
      this.pathIcon = 'ic_exchange.svg',
      this.type = MicBoxType.micScreen})
      : super(key: key);

  @override
  State<MicBox> createState() => _MicBox();
  final MicModel? micModel;
  final void Function()? onPressedButton;
  final void Function()? onPressedItem;
  final double micSize;
  final String textButton;
  final String pathIcon;
  final MicBoxType type;
}

class _MicBox extends State<MicBox> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        BorderOutLine(
          width: double.infinity,
          backgroundItem: ColorUtil.backgroundSecondary,
          colorOutline: ColorUtil.lightBlue,
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.only(bottom: 48),
          borderRadius: BorderRadius.circular(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              ImageUtil.loadAssetsImage(
                fileName: 'ic_mic.png',
                width: widget.micSize,
                height: widget.micSize,
              ),
              Visibility(
                  visible: widget.type == MicBoxType.micScreen,
                  child: Column(
                    children: [
                      const SizedBox(height: MyStyles.verticalMargin),
                      Chip(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        label: Text(
                          l('#${widget.micModel?.id}'),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: s(context,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: ColorUtil.cyan),
                        ),
                        backgroundColor: ColorUtil.deepPurple,
                      ),
                      const SizedBox(height: 8),
                      _attributes(context),
                    ],
                  )),
            ],
          ),
        ),
        _button(context),
      ],
    );
  }

  Widget _attributes(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            buildItemRow(context,
                leftText: 'Attributes',
                rightText: '',
                leftStyle:
                    s(context, fontSize: 20, fontWeight: MyFontWeight.bold),
                rightStyle:
                    s(context, fontSize: 20, fontWeight: MyFontWeight.bold),
                padding: EdgeInsets.zero),
            const SizedBox(height: 8),
            _itemAttributes(context,
                type: MicAttributeType.durability,
                rightText: '${widget.micModel?.durability}'),
            _itemAttributes(context,
                type: MicAttributeType.luck,
                rightText: '+${widget.micModel!.luck}'),
          ],
        ));
  }

  Widget _itemAttributes(BuildContext context,
      {required MicAttributeType type, String rightText = ""}) {
    return buildItemRow(
      context,
      leftText: type.attributes,
      rightText: rightText,
      pathIconRight: type.pathMicAttributeIcon,
      rightStyle: s(context, fontSize: 16),
    );
  }

  Widget _button(BuildContext context) {
    return Positioned(
        bottom: 0,
        child: ActionChip(
          label: Text(widget.textButton, style: s(context, fontSize: 16)),
          backgroundColor: ColorUtil.primary,
          avatar: widget.pathIcon.isNotEmpty
              ? ImageUtil.loadAssetsImage(fileName: widget.pathIcon)
              : null,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          onPressed: () {
            widget.onPressedButton!();
          },
        ));
  }
}
