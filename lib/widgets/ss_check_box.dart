
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sing_app/utils/image_util.dart';


class SSCheckbox extends StatefulWidget {
  final bool isChecked;
  final bool? isTransparentBackground;
  final Function(bool value)? onCheckedChange;
  final String checkedImage;
  final String uncheckImage;
  final double width;
  final double height;

  const SSCheckbox({
    Key? key,
    this.isChecked = false,
    this.onCheckedChange,
    this.isTransparentBackground = true,
    this.checkedImage = 'cb_active.png',
    this.uncheckImage = 'cb_normal.png',
    this.width = 29,
    this.height = 29,
  }) : super(key: key);

  @override
  _SSCheckboxState createState() => _SSCheckboxState();
}

class _SSCheckboxState extends State<SSCheckbox> {
  bool isChecked = false;

  @override
  void initState() {
    isChecked = widget.isChecked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleCheckValueChanged,
      child: Container(
        color: (widget.isTransparentBackground ?? false) ? Colors.transparent : Colors.white,
        // padding: const EdgeInsets.all(10),
        child: _buildCheckImage(),
      ),
    );
  }

  Widget _buildCheckImage() {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: (isChecked)
          ? ImageUtil.loadAssetsImage(fileName: widget.checkedImage)
          : ImageUtil.loadAssetsImage(fileName: widget.uncheckImage),
    );
  }

  _handleCheckValueChanged() {
    setState(() {
      isChecked = !isChecked;
      if(widget.onCheckedChange != null) {
        widget.onCheckedChange!(isChecked);
      }
    });
  }
}
