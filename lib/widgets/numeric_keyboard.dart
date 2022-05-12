import 'dart:async';

import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:sing_app/utils/number_format_util.dart';

class NumericKeyboard extends StatelessWidget
    with KeyboardCustomPanelMixin<String>
    implements PreferredSizeWidget {
  @override
  final ValueNotifier<String> notifier;
  final FocusNode focusNode;

  NumericKeyboard({
    Key? key,
    required this.notifier,
    required this.focusNode,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(300);


  String _formatValue(String value) {
    final thousandSeparator = NumberFormatUtil.getThousandSeparator();
    final updatedValue = value.replaceAll(thousandSeparator, "");
    return updatedValue;
  }

  void _onTapNumber(String? value) {
    if(value == null){
      return;
    }
    if (value == "Done") {
      focusNode.unfocus();
      return;
    }

    final currentValue = notifier.value;
    final temp = currentValue + value;
    updateValue(_formatValue(temp));
  }

  void _onTapBackspace() {
    final currentValue = notifier.value;
    if(currentValue.isEmpty){
      return;
    }
    final temp = currentValue.substring(0, currentValue.length - 1);
    updateValue(_formatValue(temp));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      color: const Color(0xFF35363F),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          children: [
            _buildButton(text: "1"),
            _buildButton(text: "2"),
            _buildButton(text: "3"),
            _buildButton(text: "4"),
            _buildButton(text: "5"),
            _buildButton(text: "6"),
            _buildButton(text: "7"),
            _buildButton(text: "8"),
            _buildButton(text: "9"),
            _buildButton(text: NumberFormatUtil.getDecimalSeparator(), color: const Color(0xFF35363F)),
            _buildButton(text: "0"),
            _buildButton(icon: Icons.backspace_outlined, color: const Color(0xFF35363F)),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    String? text,
    IconData? icon,
    Color? color,
  }) =>
      NumericButton(
        text: text,
        icon: icon,
        color: color,
        onTap: () => icon != null ? _onTapBackspace() : _onTapNumber(text),
      );
}

class NumericButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? color;

  const NumericButton({
    Key? key,
    this.text,
    this.onTap,
    this.icon,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Material(
          borderRadius: BorderRadius.circular(5.0),
          color: color ?? const Color(0xFF6E7075),
          elevation: 5,
          child: InkWell(
            onTap: onTap,
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: icon != null
                    ? Icon(
                  icon,
                  size: 6,
                  color: Colors.white,
                )
                    : Text(
                  text ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ),
        ),
    );
  }
}

class MyKeyboardActions  extends KeyboardActions {
  final FocusNode focusNode;

  const MyKeyboardActions(
      {Widget? child,
        ScrollPhysics? bottomAvoiderScrollPhysics,
        bool enable = true,
        bool autoScroll = true,
        bool isDialog = false,
        TapOutsideBehavior tapOutsideBehavior = TapOutsideBehavior.none,
        required KeyboardActionsConfig config,
        double overscroll = 12.0,
        bool disableScroll = false,
        bool keepFocusOnTappingNode = false,
        required this.focusNode,
      })
      : assert(child != null), super(
        config: config,
        child: child,
        bottomAvoiderScrollPhysics: bottomAvoiderScrollPhysics,
        enable: enable,
        autoScroll: autoScroll,
        isDialog: isDialog,
        tapOutsideBehavior: tapOutsideBehavior,
        overscroll: overscroll,
        disableScroll: disableScroll,
        keepFocusOnTappingNode: keepFocusOnTappingNode,
      );

  @override
  KeyboardActionsStateBottomed createState() => KeyboardActionsStateBottomed(focusNode);

}

class KeyboardActionsStateBottomed extends KeyboardActionstate  {

  final FocusNode _focusNode;

  KeyboardActionsStateBottomed(FocusNode fieldFocusNode): _focusNode = fieldFocusNode, super() {
    _focusNode.addListener(() {
      final bottom = WidgetsBinding.instance!.window.viewInsets.bottom;
      final mainFocusNode = FocusScope.of(context);

      if (mainFocusNode.hasFocus && bottom > 0) {
        mainFocusNode.unfocus();

         Timer( const Duration(milliseconds: 100),
                () => _focusNode.requestFocus());
      }
    });
  }

}

