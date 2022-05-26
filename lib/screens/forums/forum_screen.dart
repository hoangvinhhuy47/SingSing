import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sing_app/blocs/forum/forum_screen_event.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/event_bus/event_bus_event.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/widgets/indicator_loadmore.dart';
import '../../application.dart';
import '../../blocs/forum/forum_screen_bloc.dart';
import '../../blocs/forum/forum_screen_state.dart';
import '../../blocs/root/root_bloc.dart';
import '../../blocs/root/root_event.dart';
import '../../config/app_localization.dart';
import '../../data/models/forum.dart';
import '../../utils/color_util.dart';
import '../../utils/number_format_util.dart';
import '../../utils/styles.dart';
import '../../widgets/border_gradient.dart';
import '../../widgets/login_register_view.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  late RootBloc _rootBloc;
  late ForumScreenBloc _bloc;

  final _scrollController = ScrollController();

  late Completer<void> _refreshCompleter;
  late StreamSubscription _onChangedLanguageListener;

  @override
  void initState() {
    _rootBloc = BlocProvider.of<RootBloc>(context);
    _bloc = BlocProvider.of<ForumScreenBloc>(context);
    _refreshCompleter = Completer();
    _scrollController.addListener(_pagination);
    _onChangedLanguageListener =
        App.instance.eventBus.on<EventChangedLanguage>().listen((event) {
      setState(() {});
    });
    App.instance.eventBus.on<EventBusNavigateToForumSearch>().listen((event) {
      Navigator.pushNamed(context, Routes.forumSearchScreen, arguments: {
        ForumSearchScreenArgs.initialForums: _bloc.forums,
        ForumSearchScreenArgs.initialTotal: _bloc.total
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForumScreenBloc, ForumScreenState>(
      listener: (ctx, state) {
        if (state is ForumScreenLoadDataSuccessState) {
          _refreshCompleter.complete();
          _refreshCompleter = Completer();
        }
      },
      builder: (ctx, state) {
        if (App.instance.isLoggedIn) {
          return _buildBody(ctx, state);
        } else {
          return _buildUnAuthView();
        }
      },
    );
  }

  Widget _buildBody(BuildContext ctx, ForumScreenState state) {
    if (state is ForumScreenInitialState ||
        (state is ForumScreenLoadingState && state.isLoading)) {
      return const SpinKitRing(
        color: Colors.white,
        lineWidth: 2,
        size: 32,
      );
    } else {
      return RefreshIndicator(
          backgroundColor: ColorUtil.primary,
          child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 10),
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemBuilder: (ctx, index) => _buildItemForum(ctx, index, state),
              itemCount: _bloc.forums.length +
                  (_bloc.forums.length < _bloc.total ? 1 : 0)),
          onRefresh: onRefresh);
    }
  }

  Widget _buildItemForum(ctx, index, state) {
    if (index >= _bloc.forums.length) return const IndicatorLoadMore();

    final Forum item = _bloc.forums[index];
    return InkWell(
      onTap: () => onTapItemForum(ctx, item),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          title: Text(
            item.title,
            overflow: TextOverflow.ellipsis,
            style: s(context, fontSize: 18),
          ),
          subtitle: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageUtil.loadAssetsImage(fileName: 'ic_member_forum.svg'),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  '${NumberFormatUtil.currencyFormat(item.memberCount)} SuperFans',
                  overflow: TextOverflow.ellipsis,
                  style: s(context,
                      fontSize: 14,
                      color: ColorUtil.textSecondaryColor,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
          leading: BorderGradient(
            gradientColor: const LinearGradient(
                colors: ColorUtil.gradientMemberForum,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
            borderRadius: BorderRadius.circular(55),
            borderWidth: 1.5,
            child: ImageUtil.loadNetWorkImage(
                url: item.thumb, height: 50, width: 50, fit: BoxFit.fitHeight),
          ),
        ),
      ),
    );
  }

  onTapItemForum(BuildContext context, Forum item) {
    if (item.isJoined) {
      Navigator.pushNamed(
        context,
        Routes.forumDetailScreen,
        arguments: {ForumDetailScreenArgs.forum: item},
      );
    } else {
      Fluttertoast.showToast(
        msg: l('You have not joined the group'),
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.white,
        textColor: ColorUtil.primary,
      );
    }
  }

  Future<void> onRefresh() async {
    _bloc.add(const GetForumEvent(isRefresh: true));
    return _refreshCompleter.future;
  }

  _buildUnAuthView() {
    return LoginRegisterView(
      onLoginPressed: () {
        _rootBloc.add(ShowLoginPopupEvent());
      },
      onRegisterPressed: () {
        _rootBloc.add(ShowRegistrationPopupEvent());
      },
      onSettingsPressed: () {
        Navigator.pushNamed(context, Routes.unauthSettingsScreen);
      },
    );
  }

  @override
  void dispose() {
    _bloc.close();
    _onChangedLanguageListener.cancel();
    super.dispose();
  }

  _pagination() {
    if (_scrollController.position.extentAfter < 300 &&
        (_bloc.forums.length < _bloc.total) &&
        !_bloc.isLoading) {
      _bloc.add(const GetForumEvent());
    }
  }
}
