import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';

class PasscodeKeyboard extends StatefulWidget {
  final Function(int)? onPressedKey;

  const PasscodeKeyboard({
    Key? key,
    this.onPressedKey,
  }) : super(key: key);

  @override
  _PasscodeKeyboardState createState() => _PasscodeKeyboardState();
}

class _PasscodeKeyboardState extends State<PasscodeKeyboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: const Color(0xFF35363F), child: _buildAllKey());
  }

  Widget _buildAllKey() {
    return Column(
      children: [
        const SizedBox(height: 3),
        Row(
          children: [
            _buildKey(1),
            _buildKey(2),
            _buildKey(3),
          ],
        ),
        Row(
          children: [
            _buildKey(4),
            _buildKey(5),
            _buildKey(6),
          ],
        ),
        Row(
          children: [
            _buildKey(7),
            _buildKey(8),
            _buildKey(9),
          ],
        ),
        Row(
          children: [
            _buildEmptyKey(),
            _buildKey(0),
            _buildBackKey(),
          ],
        ),
        const SizedBox(height: 30)
      ],
    );
  }

  Widget _buildBackKey() {
    return Flexible(
      flex: 1,
      child: Material(
          borderRadius: BorderRadius.circular(5),
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (widget.onPressedKey != null) {
                widget.onPressedKey!(-1);
              }
            },
            child: SizedBox(
                height: 46,
                child: Center(
                  child: ImageUtil.loadAssetsImage(fileName: 'back_keyboard.svg'),
                )),
          )),
    );
  }

  Widget _buildEmptyKey() {
    return Flexible(
      flex: 1,
      child: Container(),
    );
  }

  Widget _buildKey(int number) {
    return Flexible(
        flex: 1,
        child: Container(
          height: 46,
          margin: const EdgeInsets.all(3),
          child: Material(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xFF6E7075),
            child: InkWell(
              onTap: () {
                if (widget.onPressedKey != null) {
                  widget.onPressedKey!(number);
                }
              },
              child: Center(
                child: Text('$number',
                    style: s(context,
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        color: Colors.white)),
              ),
            ),
          ),
        ));
  }
}
