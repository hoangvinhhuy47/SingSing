import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/wallet_s2e/transaction_history/transaction_history_screen_bloc.dart';
import 'package:sing_app/blocs/wallet_s2e/transaction_history/transaction_history_screen_event.dart';
import 'package:sing_app/blocs/wallet_s2e/transaction_history/transaction_history_screen_state.dart';
import 'package:sing_app/data/models/transaction.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/scroll_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/indicator_loadmore.dart';
import 'package:sing_app/widgets/s2e_appbar.dart';
import '../../../widgets/ink_click_item.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  late TransactionHistoryScreenBloc _bloc;
  late ScrollController _scrollController;
  late Completer _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _refreshCompleter = Completer();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      scrollPaginationListener(
          condition: _bloc.hasMore() && !_bloc.isLoading,
          scrollController: _scrollController,
          paginationFunction: () {
            _bloc.add(const GetTransactionHistoryEvent());
          });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionHistoryScreenBloc,
        TransactionHistoryScreenState>(
      builder: _buildBody,
      listener: (ctx, state) {
        if (state is GetTransactionsHistoryDoneState && state.isDone) {
          _hideRefreshIndicator();
        }
      },
    );
  }

  void _hideRefreshIndicator() {
    _refreshCompleter.complete();
    _refreshCompleter = Completer();
  }

  Widget _buildBody(BuildContext context, TransactionHistoryScreenState state) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SizedBox(
          height: double.infinity,
          child: Visibility(
            visible: true,
            replacement: const Center(child: Text('No data')),
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: MyStyles.horizontalMargin),
              shrinkWrap: true,
              itemBuilder: _buildItem,
              itemCount:
                  _bloc.transactionList.length + (_bloc.hasMore() ? 1 : 0),
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              separatorBuilder: (ctx, index) {
                return const SizedBox(height: 8);
              },
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return S2EAppBar(
      centerTitle: false,
      automaticallyImplyLeading: true,
      titleWidget: Text(
        'Transaction items history',
        style: s(context, fontSize: 16, color: ColorUtil.grey100),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${item.name}', style: s(context, fontSize: 18)),
              Text('\$${item.token}', style: s(context, fontSize: 18))
            ],
          ),
          const SizedBox(height: 4),
          Text('${item.date}',
              style:
                  MyStyles.of(context).secondaryText().copyWith(fontSize: 11)),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    _bloc.add(const GetTransactionHistoryEvent(isRefresh: true));
    return _refreshCompleter.future;
  }
}
