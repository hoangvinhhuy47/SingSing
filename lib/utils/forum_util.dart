import 'package:flutter/cupertino.dart';
import 'package:sing_app/constants/extension_constant.dart';
import 'package:sing_app/data/models/user_profile.dart';

import '../constants/constants.dart';
import '../data/models/post.dart';
import '../widgets/dialog/menu_action_dialog.dart';

void onOpenPostActionDialog(
  BuildContext context, {
  UserProfile? user,
  required Post item,
  required List<Post> pinnedPosts,
  required List<Post> posts,
  required void Function(ActionsDialog actionsDialog) onPressItemAction,
}) {
  final List<ActionsDialog> actions = [];
  if (user != null ? user.isMod() : false) {
    if (pinnedPosts.indexWhere((element) => element.postId == item.postId) !=
        -1) {
      actions.add(ActionsDialog.unPin);
    } else if (posts.contains(item)) {
      actions.add(ActionsDialog.pin);
    }
  }
  if (item.user.userId == user?.userId) {
    actions.add(ActionsDialog.edit);
  }
  if (item.user.userId == user?.userId ||
      user?.type == UserType.mod.value ||
      user?.type == UserType.admin.value) {
    actions.add(ActionsDialog.delete);
  }
  if (item.user.userId != user?.userId &&
      !(user?.type == UserType.mod.value ||
          user?.type == UserType.admin.value)) {
    actions.add(ActionsDialog.report);
  }
  actions.add(ActionsDialog.cancel);

  MenuActionDialog.show(context,
      actions: actions, onPressed: onPressItemAction);
}
