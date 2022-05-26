import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/forum_member/forum_member_screen_event.dart';
import 'package:sing_app/data/models/user_profile.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/border_gradient.dart';
import 'package:sing_app/widgets/indicator_loadmore.dart';
import 'package:sing_app/widgets/search_text_field.dart';
import 'package:sing_app/widgets/s2e_appbar.dart';

import '../../blocs/forum_member/forum_member_screen_bloc.dart';
import '../../blocs/forum_member/forum_member_screen_state.dart';
import '../../config/app_localization.dart';
import '../../constants/constants.dart';

const double borderListMember = 22;

class ForumMemberScreen extends StatefulWidget {
  const ForumMemberScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForumMemberState();
}

class _ForumMemberState extends State<ForumMemberScreen> {
  late ForumMemberScreenBloc _bloc;

  final _scrollController = ScrollController();
  late Completer<void> _refreshCompleter;

  bool _isSearching = false;
  bool _isExpandTopMember = true;
  late final FocusNode _searchFocus;
  late final TextEditingController _searchController;
  bool _isVisibleClearSearch = false;

  @override
  void initState() {
    _bloc = BlocProvider.of<ForumMemberScreenBloc>(context);
    _searchFocus = FocusNode();
    _searchController = TextEditingController();
    _refreshCompleter = Completer();
    _scrollController.addListener(_forumMembersPagination);

    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    _searchFocus.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: _buildAppBar(context),
          body: SafeArea(
            child: _buildBloc(),
          ),
        ),
        onWillPop: () async {
          if (_isSearching) {
            _cancelSearch(isDelayed: false);
            return false;
          }
          return true;
        });
  }

  Future _cancelSearch({bool isDelayed = false}) async {
    _searchFocus.unfocus();
    _searchController.clear();
    _bloc.add(ForumMemberScreenInitialEvent());
    await Future.delayed(Duration(milliseconds: isDelayed ? 1000 : 0));
    setState(() {
      _isSearching = false;
      _isExpandTopMember = _scrollController.offset <= 10;
    });
  }

  S2EAppBar _buildAppBar(BuildContext context) {
    return S2EAppBar(
      systemOverlayStyle: orangeUiOverlayStyle,
      backgroundColor: ColorUtil.orange,
      automaticallyImplyLeading: !_isSearching,
      titleWidget: AnimatedSwitcher(
        duration: const Duration(milliseconds: Constants.longAnimationDuration),
        child: _isSearching
            ? SearchTextField(
                fillColor: const Color(0xffCA7800),
                themeColor: ColorUtil.white,
                searchFocus: _searchFocus,
                searchController: _searchController,
                isVisibleClearSearch: _isVisibleClearSearch,
                onPressClear: () {
                  _clearSearchTextField();
                },
                onChanged: (text) {
                  setState(() {
                    _isVisibleClearSearch = text.isNotEmpty;
                  });
                },
                onChangedDebounce: _onBlocSearchMember)
            : Text(
                l('Top Fans'),
                style: s(context, fontWeight: FontWeight.normal, fontSize: 18),
              ),
      ),
      actionWidgets: [
        _isSearching
            ? TextButton(
                onPressed: () {
                  _cancelSearch(isDelayed: _searchFocus.hasFocus);
                },
                child: Text(
                  l('Cancel'),
                  style: s(context, color: Colors.white),
                ))
            : IconButton(
                onPressed: () async {
                  setState(() {
                    _isSearching = true;
                  });
                  await Future.delayed(
                      const Duration(milliseconds: Constants.longAnimationDuration));
                  _searchFocus.requestFocus();
                },
                icon:
                    ImageUtil.loadAssetsImage(fileName: 'ic_search_forum.svg'))
      ],
    );
  }

  void _clearSearchTextField() {
    _searchController.clear();
    setState(() {
      _isVisibleClearSearch = false;
    });
    _bloc.add(ForumMemberScreenInitialEvent());
  }

  Widget _buildBloc() {
    return BlocConsumer<ForumMemberScreenBloc, ForumMemberScreenState>(
      listener: (ctx, state) {
        if (state is ForumMemberScreenLoadDataSuccessState) {
          _hideRefreshIndicator();
        }
      },
      builder: (ctx, state) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    final UserProfile? top1Member =
        _bloc.forumMembers.isNotEmpty ? _bloc.forumMembers[0] : null;
    final UserProfile? top2Member =
        _bloc.forumMembers.length >= 2 ? _bloc.forumMembers[1] : null;
    final UserProfile? top3Member =
        _bloc.forumMembers.length >= 3 ? _bloc.forumMembers[2] : null;
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Container(
        color: ColorUtil.orange,
        child: Column(
          children: [
            AnimatedContainer(
              height: _isSearching
                  ? 0
                  : _isExpandTopMember
                      ? 300
                      : 180,
              duration: const Duration(milliseconds: Constants.longAnimationDuration),
              curve: Curves.fastOutSlowIn,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: Constants.shortAnimationDuration),
                child: _isExpandTopMember
                    ? _buildTopFanExpand(top3Member, top2Member, top1Member)
                    : _buildTopFanCollapse(top3Member, top2Member, top1Member),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: ColorUtil.primary,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(borderListMember),
                    topLeft: Radius.circular(borderListMember),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(borderListMember),
                    topLeft: Radius.circular(borderListMember),
                  ),
                  child: Visibility(
                    visible: _bloc.isLoading ||
                        (_isSearching
                            ? _bloc.forumMembersSearching.isNotEmpty
                            : _bloc.forumMembers.isNotEmpty),
                    replacement: Center(child: Text(l("No results"))),
                    child: ListView.separated(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemBuilder: _buildItemMember,
                      separatorBuilder: (ctx, index) =>
                          const Divider(height: 0, color: ColorUtil.primary),
                      itemCount:  (_isSearching
                              ? _bloc.forumMembersSearching.length
                              : (_bloc.forumMembers.length > 3
                                  ? _bloc.forumMembers.length - 3
                                  : 0)) +
                          (((_isSearching
                                      ? _bloc.forumMembersSearching.length <
                                          _bloc.totalSearch
                                      : _bloc.forumMembers.length <
                                          _bloc.total) ||
                                  _bloc.isLoading)
                              ? 1
                              : 0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopFanCollapse(UserProfile? top3Member, UserProfile? top2Member,
      UserProfile? top1Member) {
    return Stack(
        key: const ValueKey(0),
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          ImageUtil.loadAssetsImage(
              fileName: 'bg_light_top1_member.png', fit: BoxFit.fitHeight),
          top3Member != null
              ? Positioned(
                  right: -20,
                  left: 210,
                  bottom: 30,
                  child: _itemAvatarTopMember(index: 2))
              : const SizedBox(),
          top2Member != null
              ? Positioned(
                  left: -20,
                  right: 210,
                  bottom: 30,
                  child: _itemAvatarTopMember(index: 1),
                )
              : const SizedBox(),
          top1Member != null
              ? Positioned(
                  left: 0,
                  right: 0,
                  bottom: 170,
                  child: ImageUtil.loadAssetsImage(
                      width: 26,
                      height: 22,
                      fileName: 'ic_crown.svg',
                      fit: BoxFit.contain),
                )
              : const SizedBox(),
          top1Member != null
              ? Positioned(
                  left: 0,
                  right: 0,
                  bottom: 55,
                  child: _itemAvatarTopMember(index: 0),
                )
              : const SizedBox(),
          Visibility(
            child: Positioned(
              bottom: 5,
              left: 45,
              child: _itemTopMemberCoin(top2Member),
            ),
            visible: top2Member != null,
          ),
          Visibility(
            child: Positioned(
              bottom: 5,
              child: _itemTopMemberCoin(top1Member),
            ),
            visible: top1Member != null,
          ),
          Visibility(
            child: Positioned(
              right: 45,
              bottom: 5,
              child: _itemTopMemberCoin(top3Member),
            ),
            visible: top3Member != null,
          ),
        ]);
  }

  Widget _buildTopFanExpand(UserProfile? top3Member, UserProfile? top2Member,
      UserProfile? top1Member) {
    return Stack(
      key: const ValueKey(1),
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      // fit: StackFit.expand,
      children: [
        ImageUtil.loadAssetsImage(fileName: 'bg_podium_awards.png'),
        top3Member != null
            ? Positioned(
                right: -20,
                left: 210,
                bottom: 110,
                child: _itemAvatarTopMember(index: 2))
            : const SizedBox(),
        top2Member != null
            ? Positioned(
                left: -20,
                right: 210,
                bottom: 110,
                child: _itemAvatarTopMember(index: 1),
              )
            : const SizedBox(),
        top1Member != null
            ? Positioned(
                left: 0,
                right: 0,
                bottom: 270,
                child: ImageUtil.loadAssetsImage(
                    width: 26,
                    height: 22,
                    fileName: 'ic_crown.svg',
                    fit: BoxFit.contain),
              )
            : const SizedBox(),
        top1Member != null
            ? Positioned(
                left: 0,
                right: 0,
                bottom: 155,
                child: _itemAvatarTopMember(index: 0),
              )
            : const SizedBox(),
        Visibility(
          child: Positioned(
            bottom: 5,
            left: 5,
            child: _itemTopMemberCoin(top2Member),
          ),
          visible: top2Member != null,
        ),
        Visibility(
          child: Positioned(
            bottom: 5,
            child: _itemTopMemberCoin(top1Member),
          ),
          visible: top1Member != null,
        ),
        Visibility(
          child: Positioned(
            right: 5,
            bottom: 5,
            child: _itemTopMemberCoin(top3Member),
          ),
          visible: top3Member != null,
        ),
      ],
    );
  }

  Widget _itemTopMemberCoin(UserProfile? item) {
    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: const Color(0x30000000)),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageUtil.loadAssetsImage(
                fileName: 'ic_sing_coin.png', width: 15, height: 15),
            Flexible(
                child: Text(
              ' ${item?.amount}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: s(context,
                  fontSize: 12,
                  color: ColorUtil.white,
                  fontWeight: FontWeight.normal),
            )),
          ],
        ),
      ),
    );
  }

  Widget _itemAvatarTopMember({required int index}) {
    final color = Color(
      index == 0
          ? 0xffFFD735
          : index == 1
              ? 0xffB5C4FE
              : 0xffE1672A,
    );
    final item = _bloc.forumMembers[index];
    final double size = index == 0 ? 90 : 70;
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: color, width: 3),
                borderRadius: BorderRadius.circular(100)),
            child: ClipRRect(
                child: ImageUtil.loadNetWorkImage(
                  url: item.avatar,
                  height: size,
                  width: size,
                  fit: BoxFit.cover,
                  placeHolder: assetImg('ic_user_profile.svg'),
                ),
                borderRadius: BorderRadius.circular(100)),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 100,
            child: Text(
              item.getFullName(),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16),
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItemMember(BuildContext context, int indexNumber) {
    final index = indexNumber + (_isSearching ? 0 : 3);
    if (index >=
        (_isSearching
            ? _bloc.forumMembersSearching.length
            : _bloc.forumMembers.length)) return const IndicatorLoadMore();
    final item = _isSearching
        ? _bloc.forumMembersSearching[index]
        : _bloc.forumMembers[index];
    return Container(
      padding: EdgeInsets.only(top: indexNumber == 0 ? 10 : 5, bottom: 5),
      decoration: BoxDecoration(
        color: index % 2 == 0 ? const Color(0xff212b52) : Colors.transparent,
      ),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 12),
            Text('${index + 1}',
                style: s(context, color: ColorUtil.white, fontSize: 16)),
            const SizedBox(width: 24),
            BorderGradient(
              color: _avatarBorderColor(index),
              borderRadius: BorderRadius.circular(50),
              borderWidth: 1.5,
              child: ImageUtil.loadNetWorkImage(
                url: item.avatar,
                width: 50,
                height: 50,
                placeHolder: assetImg('ic_user_profile.svg'),
              ),
            ),
          ],
        ),
        title: Text(
          item.getFullName(),
          style: s(context, fontSize: 18),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Row(
          children: [
            ImageUtil.loadAssetsImage(
                fileName: 'ic_sing_coin.png', width: 15, height: 15),
            Flexible(
              child: Text(
                '  ${item.amount} ${item.symbol}',
                style: s(context,
                    fontSize: 14,
                    color: ColorUtil.textSecondaryColor,
                    fontWeight: FontWeight.normal),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }

  Color? _avatarBorderColor(int index) => index == 0
      ? ColorUtil.gold
      : index == 1
          ? ColorUtil.textSecondaryColor
          : index == 2
              ? ColorUtil.bronze
              : null;

  _forumMembersPagination() {
    if (_scrollController.position.extentAfter < 300 && !_bloc.isLoading) {
      if (_isSearching) {
        if (_bloc.forumMembersSearching.length < _bloc.totalSearch) {
          _bloc.add(ForumMemberScreenGetMemberEvent(
              isSearch: true, keyword: _searchController.text));
        }
      } else {
        if (_bloc.forumMembers.length < _bloc.total) {
          _bloc.add(const ForumMemberScreenGetMemberEvent());
        }
      }
    }
    if (!_isSearching) {
      setState(() {
        _isExpandTopMember = _scrollController.offset < 10;
      });
    }
  }

  Future<void> _onRefresh() {
    _bloc.add(ForumMemberScreenGetMemberEvent(
        isRefresh: true,
        keyword: _isSearching ? _searchController.text : '',
        isSearch: _isSearching));
    return _refreshCompleter.future;
  }

  void _hideRefreshIndicator() {
    if (!_refreshCompleter.isCompleted) {
      _refreshCompleter.complete();
      _refreshCompleter = Completer();
    }
  }

  void _onBlocSearchMember(String text) {
    return _bloc.add(ForumMemberScreenGetMemberEvent(
        keyword: text, isSearch: true, isRefresh: true));
  }
}
