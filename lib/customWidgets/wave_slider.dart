import 'dart:ui';

import 'package:flutter/material.dart';

class WaveSlider extends StatefulWidget {
  final double width, height;
  final Color color;

  final ValueChanged<double> onChanged;

  WaveSlider({
    this.width,
    this.height,
    this.color,
    @required this.onChanged,
  });

  @override
  _WaveSliderState createState() => _WaveSliderState();
}

class _WaveSliderState extends State<WaveSlider>
    with SingleTickerProviderStateMixin {
  double _dragPosition = 0;
  double _dragPercentage = 0;

  WaveSliderController _sliderController;

  @override
  void initState() {
    _sliderController = WaveSliderController(vsync: this)
      ..addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _sliderController.dispose();
    super.dispose();
  }

  void _updateDragPosition(Offset val) {
    double newDragPos = 0;

    if (val.dx <= 0) {
      newDragPos = 0;
    } else if (val.dx >= widget.width) {
      newDragPos = widget.width;
    } else {
      newDragPos = val.dx;
    }

    setState(() {
      _dragPosition = newDragPos;
      _dragPercentage = newDragPos / widget.width;
    });
  }

  _handleChangeStart(double value){
    assert(widget.onChanged != null);
    widget.onChanged(value);
  }

  void _onDragUpdate(BuildContext context, DragUpdateDetails update) {
    RenderBox box = context.findRenderObject();
    Offset offset = box.globalToLocal(update.globalPosition);
    _sliderController.setStateToSliding();
    _updateDragPosition(offset);
    _handleChangeStart(_dragPercentage);
  }

  void _onDragStart(BuildContext context, DragStartDetails update) {
    RenderBox box = context.findRenderObject();
    Offset offset = box.globalToLocal(update.globalPosition);
    _sliderController.setStateToStarting();
    _updateDragPosition(offset);
  }

  void _onDragEnd(BuildContext context, DragEndDetails update) {
    _sliderController.setStateToStopping();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        child: Container(
            width: widget.width,
            height: widget.height,
//            color: Colors.red,
            child: CustomPaint(
              painter: WavePainter(
                sliderPosition: _dragPosition,
                dragPercentage: _dragPercentage,
                color: widget.color,
                sliderState: _sliderController.state,
                animProgress: _sliderController.progress,
              ),
            )),
        onHorizontalDragUpdate: (DragUpdateDetails updates) =>
            _onDragUpdate(context, updates),
        onHorizontalDragStart: (DragStartDetails start) =>
            _onDragStart(context, start),
        onHorizontalDragEnd: (DragEndDetails end) => _onDragEnd(context, end),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double sliderPosition;
  final double dragPercentage;
  final Color color;
  final Paint fillPainter;
  final Paint slidePainter;

  double _previousSliderPos = 0;

  final SliderState sliderState;
  final double animProgress;

  WavePainter({
    @required this.sliderPosition,
    @required this.dragPercentage,
    @required this.color,
    @required this.animProgress,
    @required this.sliderState,
  })  : fillPainter = Paint()
          ..color = color
          ..style = PaintingStyle.fill,
        slidePainter = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5;

  @override
  void paint(Canvas canvas, Size size) {
    _paintThumb(canvas, size);
//    _paintLine(canvas, size);
//    _paintIndicator(canvas, size);
//    _paintWaveLine(canvas, size);

    switch (sliderState) {
      case SliderState.starting:
        _paintStartupWave(canvas, size);
        break;
      case SliderState.sliding:
        _paintSlidingWave(canvas, size);
        break;
      case SliderState.resting:
        _paintRestingWave(canvas, size);
        break;
      case SliderState.stopping:
        _paintStoppingWave(canvas, size);
        break;

      default:
        _paintRestingWave(canvas, size);
        break;
    }
  }

  _paintStartupWave(Canvas canvas, Size size) {
    WaveCurveDefinition curveDefinition = _calculateWaveLineDefinition(size);

    double waveHeight = lerpDouble(size.height, curveDefinition.controlHeight,
        Curves.elasticOut.transform(animProgress));
    curveDefinition.controlHeight = waveHeight;
    _paintWaveLine(canvas, size, curveDefinition);
  }

  _paintRestingWave(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    canvas.drawPath(path, slidePainter);
  }

  _paintSlidingWave(Canvas canvas, Size size) {
    WaveCurveDefinition waveCurveDefinition =
        _calculateWaveLineDefinition(size);
    _paintWaveLine(canvas, size, waveCurveDefinition);
  }

  _paintStoppingWave(Canvas canvas, Size size) {
    WaveCurveDefinition curveDefinition = _calculateWaveLineDefinition(size);

    double waveHeight = lerpDouble(curveDefinition.controlHeight, size.height,
        Curves.elasticOut.transform(animProgress));
    curveDefinition.controlHeight = waveHeight;
    _paintWaveLine(canvas, size, curveDefinition);
  }

  _paintThumb(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(0, size.height), 5.0, fillPainter);
    canvas.drawCircle(Offset(size.width, size.height), 5.0, fillPainter);
  }

  _paintIndicator(Canvas canvas, Size size) {
    Rect sliderRect =
        Offset(sliderPosition, size.height - 5.0) & Size(3.0, 10.0);
    canvas.drawRect(sliderRect, fillPainter);
  }

  WaveCurveDefinition _calculateWaveLineDefinition(Size size) {
    double minWaveHeight = size.height * 0.2;
    double maxWaveHeight = size.height * 0.8;

    double controlHeight =
        (size.height - minWaveHeight) - (maxWaveHeight * dragPercentage);

    double centerPoint = sliderPosition;
    centerPoint = (centerPoint > size.width) ? size.width : centerPoint;

    double bendWidth = 20 + 20 * dragPercentage;
    double bezierWidth = 20 + 20 * dragPercentage;

    double startOfBend = sliderPosition - bendWidth / 2;
    double startOfBezier = startOfBend - bezierWidth;
    double endOfBend = sliderPosition + bendWidth / 2;
    double endOfBezier = endOfBend + bezierWidth;

    startOfBend = (startOfBend <= 0.0) ? 0.0 : startOfBend;
    startOfBezier = (startOfBezier <= 0.0) ? 0.0 : startOfBezier;
    endOfBend = (endOfBend >= size.width) ? size.width : endOfBend;
    endOfBezier = (endOfBezier > size.width) ? size.width : endOfBezier;

    double leftControlP1 = startOfBend;
    double leftControlP2 = startOfBend;
    double rightControlP1 = endOfBend;
    double rightControlP2 = endOfBend;

    double bendability = 25;
    double maxSlideDiff = 20.0;

    double slideDifference = (sliderPosition - _previousSliderPos).abs();

    slideDifference = slideDifference > maxSlideDiff
        ? slideDifference = maxSlideDiff
        : slideDifference;

    bool moveLeft = sliderPosition < _previousSliderPos;

    double bend = lerpDouble(0.0, bendability, slideDifference / maxSlideDiff);

    bend = moveLeft ? -bend : bend;

    leftControlP1 += bend;
    leftControlP2 -= bend;
    rightControlP1 -= bend;
    rightControlP2 += bend;
    centerPoint -= bend;

    WaveCurveDefinition waveCurveDefinition = WaveCurveDefinition(
      centerPoint: centerPoint,
      controlHeight: controlHeight,
      startOfBend: startOfBend,
      startOfBezier: startOfBezier,
      endOfBend: endOfBend,
      endOfBezier: endOfBezier,
      leftControlP1: leftControlP1,
      leftControlP2: leftControlP2,
      rightControlP1: rightControlP1,
      rightControlP2: rightControlP2,
    );
    return waveCurveDefinition;
  }

  _paintWaveLine(Canvas canvas, Size size, WaveCurveDefinition waveCurve) {
    WaveCurveDefinition waveCurve = _calculateWaveLineDefinition(size);

    Path path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(waveCurve.startOfBezier, size.height);
    path.cubicTo(
        waveCurve.leftControlP1,
        size.height,
        waveCurve.leftControlP2,
        waveCurve.controlHeight,
        waveCurve.centerPoint,
        waveCurve.controlHeight);
    path.cubicTo(
        waveCurve.rightControlP1,
        waveCurve.controlHeight,
        waveCurve.rightControlP2,
        size.height,
        waveCurve.endOfBezier,
        size.height);
    path.lineTo(size.width, size.height);
    canvas.drawPath(path, slidePainter);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    _previousSliderPos = oldDelegate.sliderPosition;
    return true;
  }
}

class WaveCurveDefinition {
  final double startOfBend;
  final double startOfBezier;
  final double endOfBend;
  final double endOfBezier;
  final double leftControlP1;
  final double leftControlP2;
  final double rightControlP1;
  final double rightControlP2;
  double controlHeight;
  final double centerPoint;

  WaveCurveDefinition(
      {this.startOfBend,
      this.startOfBezier,
      this.endOfBend,
      this.endOfBezier,
      this.leftControlP1,
      this.leftControlP2,
      this.rightControlP1,
      this.rightControlP2,
      this.controlHeight,
      this.centerPoint});
}

class WaveSliderController extends ChangeNotifier {
  final AnimationController animController;
  SliderState _state = SliderState.resting;

  WaveSliderController({@required TickerProvider vsync})
      : animController = AnimationController(vsync: vsync) {
    animController
      ..addListener(_onProgressUpdate)
      ..addStatusListener(_onStatusUpdate);
  }

  double get progress => animController.value;

  SliderState get state => _state;

  void _onProgressUpdate() {
    notifyListeners();
  }

  dynamic _onStatusUpdate(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _onTransitionCompleted();
    }
  }

  void _onTransitionCompleted() {
    if (_state == SliderState.stopping) {
      setStateToResting();
    }
  }

  void _startAnimation() {
    animController.duration = Duration(milliseconds: 500);
    animController.forward(from: 0.0);
    notifyListeners();
  }

  void setStateToResting() {
    _state = SliderState.resting;
  }

  void setStateToStarting() {
    _startAnimation();
    _state = SliderState.starting;
  }

  void setStateToStopping() {
    _startAnimation();
    _state = SliderState.stopping;
  }

  void setStateToSliding() {
    _state = SliderState.sliding;
  }
}

enum SliderState {
  starting,
  resting,
  sliding,
  stopping,
}
