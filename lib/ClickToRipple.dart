import 'dart:math' as math show sin, pi, sqrt;

import 'package:flutter/material.dart';

class ClickToRipple extends StatefulWidget {
  const ClickToRipple({super.key});

  @override
  State<ClickToRipple> createState() => _ClickToRippleState();
}

class _ClickToRippleState extends State<ClickToRipple>
    with TickerProviderStateMixin {
  bool show = true;
  double posx = 0, posy = 0;
  late AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  void animateButton() {
    if (show) {
      _controller.forward(from: 0);
      // _controller.animateTo(1);
    } else {
      _controller.reverse(from: 1.0);
    }

    show = !show;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) => onTapDown(context, details),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.deepOrangeAccent,
        child: Stack(
          children: [
            Image.asset(
              "assets/image.jpg",
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            CustomPaint(
              painter: Ripple(show, _controller, posx: posx, posy: posy),
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }

  void onTapDown(BuildContext context, TapDownDetails details) {
    print('${details.globalPosition}');
    final RenderObject? box = context.findRenderObject();
    // final Offset localOffset = box.globalToLocal(details.globalPosition);
    setState(() {
      // posx = localOffset.dx;
      posx = details.localPosition.dx;
      posy = details.localPosition.dy;
    });

    animateButton();
  }
}

class Ripple extends CustomPainter {
  Color color = Colors.black;
  bool show;
  double posx = 0, posy = 0;

  Ripple(
    this.show,
    this._animation, {
    this.color = Colors.black,
    this.posx = 0,
    this.posy = 0,
  }) : super(repaint: _animation);
  final Animation<double> _animation;

  void circle(Canvas canvas, Rect rect, double value) {
    final Color _color = color.withOpacity(1);
    final double size = rect.height * 2.2;
    final double area = size * size;
    final double radius = math.sqrt(area * value / 4);
    final Paint paint = Paint()..color = _color;
    final Paint paint2 = Paint()..color = _color.withOpacity(.5);
    Offset _offset = Offset(posx, posy);
    canvas.drawCircle(_offset, radius, paint2);
    canvas.drawCircle(_offset, radius - 30, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0, 0, size.width, size.height);
    circle(canvas, rect, _animation.value);
  }

  @override
  bool shouldRepaint(Ripple oldDelegate) => true;
}
