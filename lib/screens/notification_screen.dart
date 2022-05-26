import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/notification_info.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/date_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/dialog/mark_all_notifications_as_read_dialog.dart';
import 'package:sing_app/widgets/ink_click_item.dart';
import 'package:sing_app/widgets/loading_indicator.dart';
import 'package:sing_app/widgets/s2e_appbar.dart';
import 'package:sing_app/widgets/tiles/load_more_tile.dart';

import '../blocs/notification/notification_screen_bloc.dart';
import '../blocs/notification/notification_screen_event.dart';
import '../blocs/notification/notification_screen_state.dart';
import '../config/app_localization.dart';
import '../routes.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationScreenBloc _bloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _bloc = BlocProvider.of<NotificationScreenBloc>(context);
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBloc(context);
  }

  _buildBloc(ctx) {
    return BlocConsumer<NotificationScreenBloc, NotificationScreenState>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return _buildScreen(ctx, state);
      },
    );
  }

  _buildScreen(BuildContext context, NotificationScreenState state) {
    return Scaffold(
        appBar: S2EAppBar(
          title: l('Notification'),
          isBackNavigation: true,
          actionWidgets: [
            InkClickItem(
              padding: const EdgeInsets.symmetric(
                  horizontal: MyStyles.horizontalMargin),
              borderRadius: BorderRadius.circular(15),
              onTap: _onPressReadAll,
              child: Center(
                  child: Text(
                '${l('Read all')} (${_bloc.unreadNotifications.length})',
                style: TextStyle(color: _bloc.unreadNotifications.isNotEmpty ? ColorUtil.white : ColorUtil.mainBlue),
              )),
            ),
          ],
        ),
        body: SafeArea(
          child: _buildBody(context, state),
        ));
  }

  Widget _buildBody(ctx, state) {
    final bool isLoading =
        (state is NotificationScreenStateLoading && state.showLoading);
    return LoadingIndicator(
      isLoading: isLoading,
      child: RefreshIndicator(
          child: ListView.separated(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              itemBuilder: _itemNotification,
              itemCount: _bloc.notifications.length < _bloc.total ? _bloc.notifications.length + 1 : _bloc.notifications.length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 2);
              },
          ),
          onRefresh: _onRefresh),
    );
  }

  Widget _itemNotification(BuildContext context, int index) {
    if(index < _bloc.notifications.length) {
      final notification = _bloc.notifications[index];

      var _dateTime = DateFormat(isoFormat).parse(notification.createdAt, true).toLocal();
      DateTime currentPhoneDate = DateTime.now();
      final difference = currentPhoneDate.millisecondsSinceEpoch -
          _dateTime.millisecondsSinceEpoch;
      final differenceHumanReadable = difference.toHumanReadable();
      return InkClickItem(
          onTap: () => _onTapNotification(notification),
          child: ListTile(
            tileColor: notification.isRead == 0 ? const Color(0xFF1F2C44) : Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(
                vertical: 8, horizontal: MyStyles.horizontalMargin),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: ImageUtil.loadNetWorkImage(
                  url: notification.image, height: 55, width: 55),
            ),
            title: Text(notification.title),
            subtitle: Text(
              differenceHumanReadable,
              style: s(context, color: ColorUtil.mainBlue),
            ),
            // trailing: notification.isRead == 0
            //     ? ImageUtil.loadAssetsImage(
            //         fileName: 'ic_notification_unread.svg')
            //     : const SizedBox(),
          ));
    } else {
      return const LoadMoreTile();
    }

  }

  _onTapNotification(NotificationInfo notification) {

    if(notification.action == NotificationInfo.actionLikePost || notification.action == NotificationInfo.actionCommentPost) {
      if(notification.isRead == 0) { // update notification state from 0 to 1
        _bloc.add(ReadNotification(notificationId: notification.id));
      }

      Navigator.pushNamed(context, Routes.postDetailScreen, arguments: {
          PostDetailScreenArgs.isOpenGallery: false,
          PostDetailScreenArgs.post: null,
          PostDetailScreenArgs.forum: null,
          PostDetailScreenArgs.postId: notification.targetId,
        }
      );
    }

  }

  _onPressReadAll() {
    if(_bloc.unreadNotifications.isNotEmpty) {
      MarkAllNotificationsAsReadDialog.show(context, onPressed: () {
        _bloc.add(ReadAllNotifications());
      });
    }

  }

  Future<void> _onRefresh() async {}


  /// LISTENER

  void _onScroll() {
    final currentScroll = _scrollController.position.pixels;
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (currentScroll == maxScroll && _bloc.notifications.length < _bloc.total) {
      _bloc.add(NotificationScreenLoadMoreEvent());
    }
  }
}
