import 'package:flutter/material.dart';
import 'package:ripple_fade/CirclePainter.dart';
import 'package:ripple_fade/CurveWave.dart';

class RipplesAnimation extends StatefulWidget {
  const RipplesAnimation({
    Key? key,
    this.size = 80.0,
    this.color = Colors.red,
    // required this.onPressed,
  }) : super(key: key);
  final double size;
  final Color color;
  // final VoidCallback onPressed;

  @override
  _RipplesAnimationState createState() => _RipplesAnimationState();
}

class _RipplesAnimationState extends State<RipplesAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _button() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.size),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                widget.color,
                Color.lerp(widget.color, Colors.black, .05)!
              ],
            ),
          ),
          child: ScaleTransition(
              scale: Tween(begin: 0.30, end: 1.0).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: const CurveWave(),
                ),
              ),
              child: Icon(
                Icons.speaker_phone,
                size: 44,
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Ripple Demo"),
      ),
      body: Center(
        child: CustomPaint(
          painter: CirclePainter(
            _controller,
            color: widget.color,
          ),
          child: SizedBox(
            width: widget.size * 4.125,
            height: widget.size * 4.125,
            // child: _button(),
          ),
        ),
      ),
    );
  }
}
