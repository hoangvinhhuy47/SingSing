import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFieldDebounce extends StatefulWidget {
  final TextEditingController? controller;
  final int millisecondDurationDebounce;
  final void Function(String)? onChanged;
  final void Function(String)? onChangedDebounce;
  final void Function(String)? onSubmitted;
  final TextStyle? style;
  final InputDecoration? decoration;
  final int? maxLines;
  final int? minLines;
  final FocusNode? focusNode;
  final Color? cursorColor;
  final TextInputAction? textInputAction;

  const TextFieldDebounce(
      {Key? key,
      this.controller,
      this.millisecondDurationDebounce = 500,
      this.onChanged,
      this.onChangedDebounce,
      this.onSubmitted,
      this.style,
      this.decoration,
      this.focusNode,
      this.cursorColor,
      this.textInputAction,
      this.maxLines,
      this.minLines})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TextFiledDebounceState();
}

class _TextFiledDebounceState extends State<TextFieldDebounce> {
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: widget.textInputAction,
      cursorColor: widget.cursorColor,
      focusNode: widget.focusNode,
      controller: widget.controller,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      onChanged: (String s) {
        widget.onChanged != null ? widget.onChanged!(s) : null;
        if (widget.onChangedDebounce != null) {
          if (_debounce?.isActive ?? false) _debounce?.cancel();
          _debounce = Timer(
              Duration(milliseconds: widget.millisecondDurationDebounce), () {
            widget.onChangedDebounce!(s);
          });
        }
      },
      onSubmitted: widget.onSubmitted,
      style: widget.style,
      decoration: widget.decoration,
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
