import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PinchZoomWidget extends StatefulWidget {
  final Widget child;
  final double minScale;
  final double maxScale;
  final bool resizeOnInteractionEnd;

  const PinchZoomWidget(
      {Key? key,
      required this.child,
      this.minScale = 1,
      this.maxScale = 3,
      this.resizeOnInteractionEnd = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PinchZoomWidgetState();
}

class _PinchZoomWidgetState extends State<PinchZoomWidget>
    with SingleTickerProviderStateMixin {
  late TransformationController controller;
  late AnimationController animationController;
  Animation<Matrix4>? animation;

  @override
  void initState() {
    super.initState();
    controller = TransformationController();

    if(widget.resizeOnInteractionEnd){
      animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      )..addListener(() => controller.value = animation!.value);
    }

  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InteractiveViewer(
        transformationController: controller,
        clipBehavior: Clip.none,
        onInteractionEnd: (details) {
          if(widget.resizeOnInteractionEnd){
            resetAnimation();

          }
        },
        minScale: widget.minScale,
        maxScale: widget.maxScale,
        child: widget.child,
      ),
    );
  }

  void resetAnimation() {
    animation = Matrix4Tween(
      begin: controller.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(parent: animationController, curve: Curves.ease));

    animationController.forward(from: 0);
  }

}
