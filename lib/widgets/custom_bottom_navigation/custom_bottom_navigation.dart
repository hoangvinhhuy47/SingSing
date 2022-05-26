library navigation_dot_bar;

import 'package:flutter/material.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/ink_click_item.dart';

class BottomNavigationDotBar extends StatefulWidget {
  final List<BottomNavigationDotBarItem> items;
  final int selectedIndex;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final Color backgroundColor;
  final Function(int index)? onTap;
  final double fontSize;

  const BottomNavigationDotBar(
      {required this.items,
      this.selectedIndex = 0,
      this.selectedItemColor,
      this.unselectedItemColor,
      this.onTap,
      this.fontSize = 12,
      this.backgroundColor = ColorUtil.backgroundPrimary,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _BottomNavigationDotBarState();
}

class _BottomNavigationDotBarState extends State<BottomNavigationDotBar> {
  Color _color = ColorUtil.primary;
  Color _activeColor = ColorUtil.primary;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  _afterLayout(_) {
    setState(() {
      _color = widget.unselectedItemColor ?? ColorUtil.primary;
      _activeColor = widget.selectedItemColor ?? Theme.of(context).primaryColor;
    });
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          border: Border(
            top: BorderSide(
              color: ColorUtil.grey100.withAlpha(10),
              width: 2
            ),
          ),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _createNavigationIconButtonList(widget.items.asMap())),
      );

  List<Widget> _createNavigationIconButtonList(
      Map<int, BottomNavigationDotBarItem> mapItem) {
    List<Widget> children = [];
    mapItem.forEach((index, item) => children.add(Expanded(
          child: _NavigationIconButton(
            colorIcon: (index == widget.selectedIndex) ? _activeColor : _color,
            icon: index == widget.selectedIndex
                ? (item.activeIcon ?? item.icon)
                : item.icon,
            label: item.label,
            fontSize: widget.fontSize,
            onTap: () {
              if (widget.onTap != null) {
                widget.onTap!(index);
              }
            },
            isSelected: index == widget.selectedIndex,
          ),
        )));
    return children;
  }
}

typedef NavigationIconButtonTapCallback = void Function();

class _NavigationIconButton extends StatefulWidget {
  final Widget icon;
  final Color colorIcon;
  final String label;
  final bool isSelected;
  final double fontSize;
  final NavigationIconButtonTapCallback onTap;

  const _NavigationIconButton({
    Key? key,
    required this.icon,
    required this.colorIcon,
    required this.label,
    required this.onTap,
    required this.fontSize,
    required this.isSelected,
  }) : super(key: key);

  @override
  _NavigationIconButtonState createState() => _NavigationIconButtonState();
}

class _NavigationIconButtonState extends State<_NavigationIconButton> {
  @override
  Widget build(BuildContext context) => InkClickItem(
      padding: const EdgeInsets.symmetric(vertical: 8),
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        widget.onTap();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.icon,
          Text(
            widget.label,
            style:
                s(context, color: widget.colorIcon, fontSize: widget.fontSize),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Visibility(
              visible: widget.isSelected,
              child:
                  CircleAvatar(radius: 2.5, backgroundColor: widget.colorIcon),
            ),
          )
        ],
      ));
}

class BottomNavigationDotBarItem {
  final Widget icon;
  final String label;
  final Widget? activeIcon;
  final NavigationIconButtonTapCallback? onTap;

  const BottomNavigationDotBarItem(
      {required this.icon, this.onTap, this.activeIcon, this.label = ''});
}
