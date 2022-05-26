import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sing_app/widgets/text_field_debounce.dart';

import '../config/app_localization.dart';
import '../utils/color_util.dart';
import '../utils/image_util.dart';
import '../utils/styles.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController? searchController;
  final FocusNode? searchFocus;
  final bool isVisibleClearSearch;
  final Function? onPressClear;
  final void Function(String)? onChanged;
  final void Function(String)? onChangedDebounce;
  final void Function(String)? onSubmitted;
  final Color fillColor;
  final Color themeColor;
  final int millisecondDurationDebounce;
  final Color prefixIconColor;

  const SearchTextField({
    Key? key,
    this.searchController,
    this.searchFocus,
    this.isVisibleClearSearch = true,
    this.onPressClear,
    this.onChanged,
    this.onChangedDebounce,
    this.onSubmitted,
    this.fillColor = const Color(0xFF242B43),
    this.themeColor = ColorUtil.textSecondaryColor,
    this.millisecondDurationDebounce = 500,
    this.prefixIconColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldDebounce(
      millisecondDurationDebounce: millisecondDurationDebounce,
      controller: searchController,
      focusNode: searchFocus,
      maxLines: 1,
      cursorColor: themeColor,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        fillColor: fillColor,
        filled: true,
        hintText: l('Search'),
        contentPadding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
          borderSide: BorderSide(width: 1, color: Colors.transparent),
        ),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
            borderSide: BorderSide(width: 1, color: Colors.transparent)),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        suffixIcon: Visibility(
          visible: isVisibleClearSearch,
          child: IconButton(
            onPressed: () {
              onPressClear != null ? onPressClear!() : null;
            },
            icon: const Icon(
              Icons.clear,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
        prefixIcon: IconButton(
          onPressed: () {},
          icon: ImageUtil.loadAssetsImage(
              fileName: 'ic_search_forum.svg',
              width: 12,
              height: 12,
              color: prefixIconColor),
        ),
      ),
      style: s(context, color: Colors.white, fontSize: 14),
      onChanged: (text) {
        onChanged != null ? onChanged!(text) : null;
      },
      onChangedDebounce: (text) {
        onChangedDebounce != null ? onChangedDebounce!(text) : null;
      },
      onSubmitted: (text) {
        onSubmitted != null ? onSubmitted!(text) : null;
      },
    );
  }
}
