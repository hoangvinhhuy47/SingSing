import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sing_app/blocs/detail_nft_s2e/detail_nft_s2e_screen_bloc.dart';
import 'package:sing_app/blocs/detail_nft_s2e/detail_nft_s2e_screen_state.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/utils/theme_util.dart';
import 'package:sing_app/widgets/item_row_atttributes.dart';
import 'package:sing_app/widgets/mic/mic_box_widget.dart';
import 'package:sing_app/widgets/radius_widget.dart';
import 'package:sing_app/widgets/s2e_appbar.dart';

class DetailNftS2EScreen extends StatefulWidget {
  const DetailNftS2EScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailNftS2EScreenState();
}

class _DetailNftS2EScreenState extends State<DetailNftS2EScreen> {
  late DetailNftS2EScreenBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DetailNftS2EScreenBloc, DetailNftS2EScreenState>(
        builder: _buildBody, listener: (ctx, state) {});
  }

  Widget _buildBody(ctx, state) {
    return Scaffold(
      appBar: S2EAppBar(
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
            horizontal: MyStyles.horizontalMargin,
            vertical: MyStyles.verticalMargin),
        child: Column(
          children: [
            MicBox(
              micModel: _bloc.micModel,
              type: MicBoxType.nftDetailScreen,
              micSize: 250,
              pathIcon: '',
              textButton: 'Equip',
              onPressedButton: () {},
            ),
            const SizedBox(height: 12),
            RadiusWidget(
              borderRadius: BorderRadius.circular(4),
              color: ColorUtil.backgroundSecondary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    "Details",
                    style: s(context,
                        fontWeight: MyFontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 12),
                  _itemRow('Type:', '${_bloc.micModel?.type}'),
                  _itemRow('Quality:', '${_bloc.micModel?.quality}'),
                  _itemRow('ID:', '#${_bloc.micModel?.id}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            RadiusWidget(
              borderRadius: BorderRadius.circular(4),
              color: ColorUtil.backgroundSecondary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Attributes",
                        style: s(context,
                            fontWeight: MyFontWeight.bold, fontSize: 20),
                      ),
                      GestureDetector(
                        onTap: () {
                          Fluttertoast.showToast(msg: 'View details');
                        },
                        child: Text('View details',style: s(context,color: ColorUtil.cyan),),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  _itemRow('Durability:', '${_bloc.micModel?.durability}'),
                  _itemRow('Atrophy:', '${_bloc.micModel?.atrophy}'),
                  _itemRow('Luck:', '${_bloc.micModel?.luck}'),
                  _itemRow('Energy:', '${_bloc.micModel?.energy}'),
                  _itemRow('Earning bonus:', '${_bloc.micModel?.earningBonus}'),
                  _itemRow('Earning range:', '${_bloc.micModel?.earningRange}'),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _itemRow(String leftText, String rightText) {
    return buildItemRow(context,
        leftStyle: s(context, fontSize: 16, color: ColorUtil.grey100),
        rightStyle: s(context, fontSize: 16, color: ColorUtil.grey100),
        leftText: leftText,
        rightText: rightText);
  }
}
