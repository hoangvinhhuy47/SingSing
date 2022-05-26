import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sing_app/blocs/wallet_s2e/in_game_wallet/items/items_tab_bloc.dart';
import 'package:sing_app/blocs/wallet_s2e/in_game_wallet/items/items_tab_state.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/mic_model.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/ink_click_item.dart';
import 'package:sing_app/widgets/item_row_atttributes.dart';

import '../../../utils/image_util.dart';
import '../../../widgets/radius_widget.dart';

const heightItem = 300;
const crossAxisSpacing = 12.0;
const borderItem = 4.0;

class ItemsTab extends StatefulWidget {
  const ItemsTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemsTabState();
}

class _ItemsTabState extends State<ItemsTab> {
  late ItemsTabBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemsTabBloc, ItemsTabState>(
      builder: (ctx, state) {
        return _buildBody();
      },
      listener: (ctx, state) {},
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: AlignedGridView.count(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
            vertical: 16, horizontal: MyStyles.horizontalMargin),
        crossAxisCount: 2,
        itemCount: _bloc.micList.length,
        // childAspectRatio: _childAspectRatio(size),
        crossAxisSpacing: crossAxisSpacing,
        itemBuilder: _buildItem,
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return _itemNft(micModel: _bloc.micList[index]);
  }

  Widget _itemNft({required MicModel micModel}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        border: Border.all(color: ColorUtil.cyan),
        borderRadius: BorderRadius.circular(borderItem),
      ),
      child: InkClickItem(
        onTap: () {
          Navigator.pushNamed(context, Routes.detailNftS2EScreen, arguments: {
            DetailNftS2EScreenArgs.micModel: micModel,
            DetailNftS2EScreenArgs.superPassModel: null,
          });
        },
        borderRadius: BorderRadius.circular(borderItem),
        color: ColorUtil.backgroundSecondary,
        padding:
            const EdgeInsets.symmetric(horizontal: MyStyles.horizontalMargin),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: ImageUtil.loadAssetsImage(
                  fileName: 'ic_mic.png', height: 200),
            ),
            RadiusWidget(
              child: Center(
                child: Text(
                  "ID: #${micModel.id}",
                  style: s(context, fontSize: 16),
                ),
              ),
              color: ColorUtil.deepPurple,
            ),
            const SizedBox(height: 8),
            buildItemRow(context,
                leftText: 'Type:',
                rightText: '${micModel.type}',
                flexLeft: 0,
                padding: EdgeInsets.zero,
                leftStyle: s(context, fontSize: 14)),
            buildItemRow(context,
                leftText: 'Quality:',
                flexLeft: 0,
                rightText: '${micModel.quality}',
                leftStyle: s(context, fontSize: 14)),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {}
}
