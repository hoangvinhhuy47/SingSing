import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sing_app/constants/assets_path.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/styles.dart';

class S2EAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double titleFontSize;
  final Widget? titleWidget;
  final Widget? leadWidget;
  final List<Widget>? actionWidgets;
  final Color? backgroundColor;
  final Color? shadowColor;
  final bool isBackNavigation;
  final PreferredSizeWidget? bottom;
  final double? titleSpacing;
  final bool centerTitle;
  final bool showShadow;
  final bool automaticallyImplyLeading;
  final VoidCallback? onBack;
  final VoidCallback? onTapTitleWidget;

  final Size barSize;
  final BorderRadius borderRadius;
  final SystemUiOverlayStyle systemOverlayStyle;

  S2EAppBar({
    Key? key,
    this.title = '',
    this.titleFontSize = 18,
    this.titleWidget,
    this.backgroundColor = ColorUtil.backgroundPrimary,
    this.shadowColor = Colors.white,
    this.isBackNavigation = false,
    this.leadWidget,
    this.actionWidgets,
    this.bottom,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.centerTitle = true,
    this.showShadow = false,
    this.automaticallyImplyLeading = true,
    this.onBack,
    this.onTapTitleWidget,
    this.borderRadius = BorderRadius.zero,
    this.systemOverlayStyle = systemUiOverlayStyle,
  })  : barSize = Size.fromHeight(
            kToolbarHeight + (bottom?.preferredSize.height ?? 0.0)),
        super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(barSize.height);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        title: _buildAppTitle(context),
        leading: _buildLeadButton(context),
        systemOverlayStyle: systemOverlayStyle,
        actions: actionWidgets,
        centerTitle: centerTitle,
        backgroundColor: backgroundColor,
        elevation: showShadow ? 2 : 0,
        shadowColor: shadowColor,
        titleSpacing: titleSpacing,
        automaticallyImplyLeading: automaticallyImplyLeading,
        bottom: bottom,
      ),
    );
  }

  Widget _buildAppTitle(BuildContext context) {
    if (titleWidget != null) {
      return GestureDetector(
        onTap: onTapTitleWidget,
        child: titleWidget,
      );
    } else {
      return Text(
        title,
        style: MyStyles.of(context)
            .valueText()
            .copyWith(color: Colors.white, fontSize: titleFontSize),
      );
    }
  }

  Widget? _buildLeadButton(BuildContext context) {
    if (isBackNavigation) {
      return IconButton(
        icon: SvgPicture.asset(AssetsPath.icBack),
        onPressed: () {
          if (onBack != null) {
            onBack!();
          } else {
            Navigator.of(context).pop();
          }
        },
      );
    } else {
      return leadWidget;
    }
  }
}
