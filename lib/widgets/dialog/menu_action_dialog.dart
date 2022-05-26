import 'package:flutter/material.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/constants/extension_constant.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/widgets/ink_click_item.dart';

class MenuActionDialog {
  static void show(BuildContext context,
      {required List<ActionsDialog> actions, required Function onPressed}) {
    showDialog(
        barrierColor: Colors.black12.withOpacity(0.6),
        context: context,
        builder: (ctx) {
          return _MenuActionDialogWidget(
              actions: actions, onPressed: onPressed);
        });
  }
}

class _MenuActionDialogWidget extends StatelessWidget {
  final List<ActionsDialog> actions;
  final Function onPressed;

  const _MenuActionDialogWidget(
      {required this.actions, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ColorUtil.backgroundItemColor,
        ),
        child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: _buildItemAction,
            separatorBuilder: (ctx, index) =>
                const Divider(color: ColorUtil.borderColor, height: 0),
            itemCount: actions.length),
      ),
    );
  }

  Widget _buildItemAction(BuildContext context, int index) {
    final item = actions[index];
    final Color _textColor =
        item == ActionsDialog.delete || item == ActionsDialog.report
            ? ColorUtil.textRed
            : ColorUtil.textSecondaryColor;
    return InkClickItem(
      borderRadius: index == 0
          ? const BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))
          : index == actions.length - 1
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12))
              : BorderRadius.zero,
      padding: const EdgeInsets.symmetric(vertical: 16),
      onTap: () => _onClickItem(index),
      child: Center(
          child: Text(
        actions[index].value,
        style: TextStyle(color: _textColor, fontSize: 18),
      )),
    );
  }

  _onClickItem(int index) {
    onPressed(actions[index]);
  }
}
