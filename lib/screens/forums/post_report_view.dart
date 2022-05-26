import 'package:flutter/material.dart';
import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/buttons/gradient_button.dart';
import 'package:sing_app/widgets/ink_click_item.dart';

import '../../config/app_localization.dart';
import '../../utils/color_util.dart';
import '../../utils/image_util.dart';
import '../../widgets/s2e_appbar.dart';

class PostReportView extends StatefulWidget {
  PostReportView({Key? key}) : super(key: key);
  final List<String> reportContent = AppConfig.instance.values.reportContents;

  @override
  State<StatefulWidget> createState() => _PostReportState();
}

class _PostReportState extends State<PostReportView> {
  String itemSelected = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(context),
      backgroundColor: ColorUtil.transparent,
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return S2EAppBar(
      title: l('Report'),
      backgroundColor: ColorUtil.backgroundItemColor,
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      actionWidgets: [
        IconButton(
          icon:
              ImageUtil.loadAssetsImage(fileName: 'ic_close_dialog_white.svg'),
          tooltip: l('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: const BoxDecoration(
        color: ColorUtil.backgroundItemColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: MyStyles.horizontalMargin),
            child: Text(l('Please select problems'),
                style: s(context, fontSize: 18)),
          ),
          Expanded(
            child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                itemBuilder: _buildItemReport,
                separatorBuilder: (ctx, index) => const Divider(
                      height: 0,
                      thickness: 1,
                      indent: MyStyles.horizontalMargin - 4,
                      endIndent: MyStyles.horizontalMargin - 4,
                      color: Color(0xff3C4D8E),
                    ),
                itemCount: widget.reportContent.length),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: MyStyles.horizontalMargin),
            child: InkClickItem(
              onTap: (){
                Navigator.pop(context,itemSelected);
              },
              child: DefaultGradientButton(
                text: l('Done'),
                width: double.infinity,
                colors: itemSelected.isEmpty?ColorUtil.buttonDisabled:ColorUtil.defaultGradientButton,
              ),
            )
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildItemReport(BuildContext context, int index) {
    final item = widget.reportContent[index];
    return InkClickItem(
      padding: const EdgeInsets.symmetric(
          vertical: 12, horizontal: MyStyles.horizontalMargin - 4),
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        setState(() {
          itemSelected = itemSelected == item ? '' : item;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item,
            style: s(context, fontWeight: FontWeight.normal, fontSize: 16),
          ),
          itemSelected == item
              ? ImageUtil.loadAssetsImage(fileName: "ic_checked.svg")
              : const SizedBox(),
        ],
      ),
    );
  }
}
