import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/routes.dart';

import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/widgets/indicator_loadmore.dart';
import 'package:sing_app/widgets/sing/item_song.dart';

import '../../application.dart';
import '../../blocs/sing/sing_screen/sing_screen_bloc.dart';
import '../../blocs/sing/sing_screen/sing_screen_event.dart';
import '../../blocs/sing/sing_screen/sing_screen_state.dart';
import '../../data/event_bus/event_bus_event.dart';
import '../../utils/styles.dart';

class SingScreen extends StatefulWidget {
  const SingScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SingScreenState();
}

class _SingScreenState extends State<SingScreen> {
  late SingScreenBloc _bloc;
  final _scrollController = ScrollController();
  late StreamSubscription _onChangedLanguageListener;
  late Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _scrollController.addListener(_pagination);
    _onChangedLanguageListener =
        App.instance.eventBus.on<EventChangedLanguage>().listen((event) {
      setState(() {});
    });
    _refreshCompleter = Completer();
    if(!_bloc.isLoading){
      _bloc.add(const SingScreenGetSongsEvent());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _onChangedLanguageListener.cancel();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SingScreenBloc, SingScreenState>(builder: (ctx, state) {
      return _buildBody();
    }, listener: (ctx, state) {
      if (state is SingScreenGetSongsSuccessState) {
        _hideRefreshIndicator();
      }
    });
  }

  void _hideRefreshIndicator() {
    if (!_refreshCompleter.isCompleted) {
      _refreshCompleter.complete();
      _refreshCompleter = Completer();
    }
  }

  Widget _buildBody() {
    return RefreshIndicator(
        color: ColorUtil.primary,
        backgroundColor: ColorUtil.appBackground,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          controller: _scrollController,
          itemCount: _bloc.songList.length + (_bloc.isHasMore() ? 1 : 0),
          padding:
              const EdgeInsets.symmetric(horizontal: MyStyles.horizontalMargin),
          itemBuilder: _buildSingItem,
        ),
        onRefresh: onRefresh);
  }

  Widget _buildSingItem(BuildContext context, int index) {
    if (index >= _bloc.songList.length) {
      return const IndicatorLoadMore();
    }
    final item = _bloc.songList[index];
    return ItemSong(
      item: item,
      isBottomBorder: index < _bloc.songList.length - 1,
      onTap: () {
        Navigator.pushNamed(context, Routes.songDetailScreen,
            arguments: {SongDetailScreenArgs.songModel: item});
      },
    );
  }

  Future<void> onRefresh() async {
    if(_bloc.isLoading){
      return;
    }
    _bloc.add(const SingScreenGetSongsEvent(isRefresh: true));
    return _refreshCompleter.future;
  }

  void _pagination() {
    if (_scrollController.position.extentAfter < 300 &&
        _bloc.isHasMore() &&
        !_bloc.isLoading) {
      _bloc.add(const SingScreenGetSongsEvent());
    }
  }
}
