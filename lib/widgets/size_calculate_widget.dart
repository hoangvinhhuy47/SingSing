import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

class SizeCalculateWidget extends StatefulWidget {
  final Widget child;
  final void Function(Size size) onChange;

  const SizeCalculateWidget({
    Key? key,
    required this.onChange,
    required this.child,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SizeCalculateState();

}

class _SizeCalculateState extends State<SizeCalculateWidget> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    return Container(
      key: widgetKey,
      child: widget.child,
    );
  }

  var widgetKey = GlobalKey();
  Size? oldSize;

  void postFrameCallback(_) {
    var context = widgetKey.currentContext;
    if (context == null) return;
    var newSize = context.size;
    if (oldSize == newSize || newSize == null) return;
    oldSize = newSize;
    widget.onChange(newSize);
  }
}