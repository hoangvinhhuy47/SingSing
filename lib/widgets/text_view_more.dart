import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sing_app/widgets/ink_click_item.dart';

import '../config/app_localization.dart';

const int lengthViewMore = 180;

class TextViewMore extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;

  const TextViewMore({Key? key, required this.text, this.textStyle})
      : super(key: key);

  @override
  _TextViewMoreState createState() => _TextViewMoreState();
}

class _TextViewMoreState extends State<TextViewMore> {
  late String firstHalf;
  late String secondHalf;

  bool flag = true; // true is mean show less

  @override
  void initState() {
    super.initState();
    if (widget.text.length > lengthViewMore) {
      firstHalf = widget.text.substring(0, lengthViewMore);
      secondHalf = widget.text.substring(lengthViewMore, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RichText(
          text: TextSpan(style: widget.textStyle, children: [
            TextSpan(
              text: flag
                  ? (firstHalf + (secondHalf.isNotEmpty ? "... " : ""))
                  : (firstHalf + secondHalf + "  "),
              style: widget.textStyle,
            ),
            secondHalf.isNotEmpty
                ? WidgetSpan(
                    child: InkClickItem(
                      borderRadius: BorderRadius.circular(12),
                      child: Text(
                        l(flag ? "Show more" : "Show less"),
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                      onTap: () {
                        setState(() {
                          flag = !flag;
                        });
                      },
                    ),
                  )
                : const WidgetSpan(child: SizedBox()),
          ]),
        ),
      ],
    );
  }
}
