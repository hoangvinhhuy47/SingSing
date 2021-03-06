
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sing_app/utils/image_util.dart';


class SSCheckbox extends StatefulWidget {
  final bool isChecked;
  final bool? isTransparentBackground;
  final Function(bool value)? onCheckedChange;

  const SSCheckbox({
    Key? key,
    this.isChecked = false,
    this.onCheckedChange,
    this.isTransparentBackground = true,
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
      onTap: _handleCheckkValueChanged,
      child: Container(
        color: (widget.isTransparentBackground ?? false) ? Colors.transparent : Colors.white,
        // padding: const EdgeInsets.all(10),
        child: _buildCheckImage(),
      ),
    );
  }

  Widget _buildCheckImage() {
    return SizedBox(
      height: 29,
      // width: 62,
      child: (isChecked)
          ? ImageUtil.loadAssetsImage(fileName: 'cb_active.png')
          : ImageUtil.loadAssetsImage(fileName: 'cb_normal.png'),
    );
  }

  _handleCheckkValueChanged() {
    setState(() {
      isChecked = !isChecked;
      if(widget.onCheckedChange != null) {
        widget.onCheckedChange!(isChecked);
      }
    });
  }
}
