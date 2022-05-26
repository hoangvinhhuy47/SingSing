import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sing_app/blocs/market/market_screen_bloc.dart';
import 'package:sing_app/blocs/market/market_screen_state.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/screens/market/components/micmarket_item.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/styles.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  late MarketScreenBloc _bloc;
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MarketScreenBloc, MarketScreenState>(
        builder: (ctx, state) {
          return _buildBody(context);
        },
        listener: (ctx, state) {});
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: MyStyles.horizontalMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: MyStyles.horizontalMargin,
          ),
          Text(
            l('Mic'),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: s(context,
                fontSize: 22,
                color: ColorUtil.white,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: MyStyles.horizontalMargin,
          ),
          Expanded(
            flex: 1,
            child: Visibility(
                child: AlignedGridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              itemCount: _bloc.marketModel.length,
              itemBuilder: (context, index) {
                final obj = _bloc.marketModel[index];
                return MicMarKetItem(
                  marketModel: obj,
                );
              },
            )),
          ),
        ],
      ),
    );
  }
}
