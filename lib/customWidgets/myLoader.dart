import 'package:flutter/material.dart';
import 'dart:math';

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation_rotation;
  Animation<double> animation_radius_in;
  Animation<double> animation_radius_out;

  final double initalrF = 40.0;
  double rF = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 5));

    animation_rotation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.0, 1.0, curve: Curves.linear)));

    animation_radius_in = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.75, 1.0, curve: Curves.elasticIn)));

    animation_radius_out = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.00, 0.25, curve: Curves.elasticOut)));

    animationController.addListener(() {
      setState(() {
        if (animationController.value >= 0.75 &&
            animationController.value <= 1.0) {
          rF = animation_radius_in.value * initalrF;
        } else if (animationController.value >= 0.0 &&
            animationController.value <= 0.25) {
          rF = animation_radius_out.value * initalrF;
        }
      });
    });
    animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 100.0,
      height: 100.0,
      child: RotationTransition(
        turns: animation_rotation,
        child: Center(
          child: Stack(
            children: <Widget>[
              Dot(
                radius: 35.0,
                color: Colors.black54,
              ),
              Transform.translate(
                offset: Offset(rF * cos(pi / 4), rF * sin(pi / 4)),
                child: Dot(
                  radius: 7.0,
                  color: Colors.red,
                ),
              ),
              Transform.translate(
                offset: Offset(rF * cos(2 * pi / 4), rF * sin(2 * pi / 4)),
                child: Dot(
                  radius: 5.0,
                  color: Colors.greenAccent,
                ),
              ),
              Transform.translate(
                offset: Offset(rF * cos(3 * pi / 4), rF * sin(3 * pi / 4)),
                child: Dot(
                  radius: 7.0,
                  color: Colors.blue,
                ),
              ),
              Transform.translate(
                offset: Offset(rF * cos(4 * pi / 4), rF * sin(4 * pi / 4)),
                child: Dot(
                  radius: 5.0,
                  color: Colors.purpleAccent,
                ),
              ),
              Transform.translate(
                offset: Offset(rF * cos(5 * pi / 4), rF * sin(5 * pi / 4)),
                child: Dot(
                  radius: 7.0,
                  color: Colors.pinkAccent,
                ),
              ),
              Transform.translate(
                offset: Offset(rF * cos(6 * pi / 4), rF * sin(6 * pi / 4)),
                child: Dot(
                  radius: 5.0,
                  color: Colors.black26,
                ),
              ),
              Transform.translate(
                offset: Offset(rF * cos(7 * pi / 4), rF * sin(7 * pi / 4)),
                child: Dot(
                  radius: 7.0,
                  color: Colors.brown,
                ),
              ),
              Transform.translate(
                offset: Offset(rF * cos(8 * pi / 4), rF * sin(8 * pi / 4)),
                child: Dot(
                  radius: 5.0,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;

  Dot({this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Container(
//        child: Text('M', style: TextStyle(
//          fontSize: this.radius,
//          color: this.color
//        ),),
        width: this.radius,
        height: this.radius,
        decoration: BoxDecoration(
          color: this.color,
          shape: BoxShape.rectangle,
        ),
      ),
    );
  }
}
