import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/wallet_s2e/in_game_wallet/points/points_tab_bloc.dart';
import 'package:sing_app/blocs/wallet_s2e/in_game_wallet/points/points_tab_event.dart';
import 'package:sing_app/blocs/wallet_s2e/in_game_wallet/points/points_tab_state.dart';
import 'package:sing_app/data/models/transaction.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/number_format_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/utils/theme_util.dart';
import 'package:sing_app/widgets/indicator_loadmore.dart';
import 'package:sing_app/widgets/ink_click_item.dart';

import '../../../utils/image_util.dart';

class PointsTab extends StatefulWidget {
  const PointsTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PointsTabState();
}

class _PointsTabState extends State<PointsTab> {
  late PointsTabBloc _bloc;
  late Completer _refreshCompleter;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _refreshCompleter = Completer();
    _scrollController = ScrollController();
    _scrollController.addListener(_transactionsPagination);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PointsTabBloc, PointsTabState>(
        builder: _buildBody,
        listener: (BuildContext context, state) {
          if (state is PointsTabGetTransactionDoneState && state.isDone) {
            _hideRefreshIndicator();
          }
        });
  }

  void _hideRefreshIndicator() {
    _refreshCompleter.complete();
    _refreshCompleter = Completer();
  }

  Widget _buildBody(BuildContext context, state) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding:
            const EdgeInsets.symmetric(horizontal: MyStyles.horizontalMargin),
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummary(),
            Text('Transaction Points history',
                style: MyStyles.of(context)
                    .secondaryText()
                    .copyWith(fontSize: 16)),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: _buildItem,
              itemCount: _bloc.transactionList.length +
                  (_bloc.isHasMoreTransactions() ? 1 : 0),
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (ctx, index) {
                return const SizedBox(height: 8);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.transactionHistoryScreen);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xffBF26E5), Color(0xff3C14DA)]),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Text(
              'Your Points',
              style: MyStyles.of(context).secondaryText(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      '12123',
                      overflow: TextOverflow.ellipsis,
                      style: s(context,
                          fontSize: 48, fontWeight: MyFontWeight.bold),
                    ),
                  ),
                  ImageUtil.loadAssetsImage(
                      fileName: 'logo_singsing.svg',
                      width: 36,
                      height: 36,
                      color: ColorUtil.yellow500),
                ],
              ),
            ),
            Text(
              '\u{2248} \$${NumberFormatUtil.tokenFormat(123.0000123123123123123)}',
              style: MyStyles.of(context).secondaryText(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index >= _bloc.transactionList.length) {
      return const IndicatorLoadMore();
    }
    final TransactionModel item = _bloc.transactionList[index];
    return InkClickItem(
      onTap: () {},
      color: ColorUtil.backgroundSecondary,
      borderRadius: BorderRadius.circular(4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${item.date}',
                  style: MyStyles.of(context)
                      .secondaryText()
                      .copyWith(fontSize: 11)),
              Text('Earned',
                  style: MyStyles.of(context)
                      .secondaryText()
                      .copyWith(fontSize: 11)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Text(
                '${item.name}',
                style: s(context, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              )),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: '${item.token} ', style: s(context, fontSize: 16)),
                WidgetSpan(
                    child: ImageUtil.loadAssetsImage(
                        fileName: 'logo_singsing.svg',
                        width: 18,
                        height: 18,
                        color: ColorUtil.yellow500))
              ]))
            ],
          ),
        ],
      ),
    );
  }

  Widget itemSendReceive(BuildContext context) {
    return InkClickItem(
      onTap: () {},
      color: ColorUtil.backgroundSecondary,
      borderRadius: BorderRadius.circular(4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Send', style: s(context, fontSize: 16)),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: '- 1.268.234 ', style: s(context, fontSize: 18)),
                WidgetSpan(
                    child: ImageUtil.loadAssetsImage(
                        fileName: 'logo_singsing.svg',
                        width: 18,
                        height: 18,
                        color: ColorUtil.yellow500))
              ]))
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('25-4-2022',
                  style: MyStyles.of(context)
                      .secondaryText()
                      .copyWith(fontSize: 11)),
              Text('-\$123456.123',
                  style: MyStyles.of(context)
                      .secondaryText()
                      .copyWith(fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    _bloc.add(const PointTabGetPointTransactionEvent(isRefresh: true));
    return _refreshCompleter.future;
  }

  void _transactionsPagination() {
    LoggerUtil.printLog(message: '_scrollController.position.extentAfter ${_scrollController.position.extentAfter}');
    if (_scrollController.position.extentAfter < 300 &&
        _bloc.isHasMoreTransactions() &&
        !_bloc.isLoadingTransaction) {
      _bloc.add(const PointTabGetPointTransactionEvent());
    }
  }
}
