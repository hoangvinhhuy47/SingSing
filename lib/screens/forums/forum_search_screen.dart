import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sing_app/blocs/forum_search/forum_search_screen_bloc.dart';
import 'package:sing_app/blocs/forum_search/forum_search_screen_event.dart.dart';
import 'package:sing_app/blocs/forum_search/forum_search_screen_state.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/number_format_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/border_gradient.dart';
import 'package:sing_app/widgets/search_text_field.dart';
import '../../config/app_localization.dart';
import '../../data/models/forum.dart';
import '../../utils/image_util.dart';
import '../../widgets/indicator_loadmore.dart';

class ForumSearchScreen extends StatefulWidget {
  const ForumSearchScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForumSearchState();
}

class _ForumSearchState extends State<ForumSearchScreen> {
  late ForumSearchScreenBloc _bloc;
  late final FocusNode _searchFocus;
  late final TextEditingController _searchController;
  bool _isVisibleClearSearch = false;

  final _scrollController = ScrollController();

  late Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _searchFocus = FocusNode();
    _searchFocus.requestFocus();
    _searchController = TextEditingController();

    _refreshCompleter = Completer();
    _scrollController.addListener(_pagination);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildBloc(),
      ),
    );
  }

  Widget _buildBloc() {
    return BlocConsumer<ForumSearchScreenBloc, ForumSearchScreenState>(
      listener: (ctx, state) {
        if (state is ForumSearchScreenLoadDataSuccessState) {
          if (!_refreshCompleter.isCompleted) {
            _refreshCompleter.complete();
            _refreshCompleter = Completer();
          }
        }
      },
      builder: (ctx, state) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: MyStyles.horizontalMargin,
            top: 24,
          ),
          child: Row(
            children: [
              Expanded(
                child: _searchTextField(),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  l('Cancel'),
                  style: s(context, fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: _bloc.forums.isNotEmpty || _bloc.isLoading,
          replacement: Expanded(
            child: Center(
              child: Text(
                l('No results'),
                style: s(context, color: ColorUtil.textSecondaryColor),
              ),
            ),
          ),
          child: Expanded(
            child: RefreshIndicator(
              child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: _buildItemForum,
                  itemCount: _bloc.forums.length +
                      (_bloc.forums.length < _bloc.total || _bloc.isLoading
                          ? 1
                          : 0)),
              onRefresh: onRefresh,
            ),
          ),
        ),
      ],
    );
  }

  void _clearSearchField() {
    _searchController.clear();
    setState(() {
      _isVisibleClearSearch = false;
    });
    _bloc.add(ForumSearchScreenInitialEvent());
  }

  Widget _searchTextField() {
    return SearchTextField(
      searchFocus: _searchFocus,
      isVisibleClearSearch: _isVisibleClearSearch,
      searchController: _searchController,
      onPressClear: () {
        _clearSearchField();
      },
      prefixIconColor: ColorUtil.mainBlue,
      onChanged: (text) {
        setState(() {
          _isVisibleClearSearch = text.isNotEmpty;
        });
      },
      onChangedDebounce: _onBlocSearchForum,
    );
  }

  void _onBlocSearchForum(String text) {
    _bloc.add(ForumSearchScreenSearchEvent(keyword: text, isSearch: true));
  }

  Widget _buildItemForum(ctx, index) {
    if (index >= _bloc.forums.length) return const IndicatorLoadMore();
    final item = _bloc.forums[index];
    return InkWell(
      onTap: () => onTapItemForum(item),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          title: Text(
            item.title,
            style: s(context, fontSize: 18),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageUtil.loadAssetsImage(fileName: 'ic_member_forum.svg'),
              const SizedBox(
                width: 4,
              ),
              Text(
                  '${NumberFormatUtil.currencyFormat(item.memberCount)} SuperFans',
                  style: s(context,
                      fontSize: 14,
                      color: ColorUtil.textSecondaryColor,
                      fontWeight: FontWeight.normal))
            ],
          ),
          leading: BorderGradient(
            gradientColor: const LinearGradient(
                colors: ColorUtil.gradientMemberForum,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
            borderRadius: BorderRadius.circular(55),
            borderWidth: 2,
            child: ImageUtil.loadNetWorkImage(
                url: item.thumb, height: 50, width: 50, fit: BoxFit.fitHeight),
          ),
        ),
      ),
    );
  }

  onTapItemForum(Forum item) {
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
    _searchFocus.unfocus();
  }

  Future<void> onRefresh() async {
    _bloc.add(const ForumSearchScreenSearchEvent(isSearch: true));
  }

  void _pagination() {
    if (_scrollController.position.extentAfter < 300 &&
        _bloc.forums.length < _bloc.total &&
        !_bloc.isLoading) {
      _bloc.add(ForumSearchScreenSearchEvent(keyword: _searchController.text));
    }
  }
}
