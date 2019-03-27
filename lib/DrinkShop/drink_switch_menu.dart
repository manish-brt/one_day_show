import 'dart:async';
import 'dart:math';

import 'package:one_day_show/DrinkShop/models.dart';
import 'package:flutter/material.dart';

class DrinkSwitchMenu extends StatefulWidget {
  final StreamController<DrinkType> drinkTypeStream;

  DrinkSwitchMenu(this.drinkTypeStream);

  @override
  State createState() => DrinkSwitchMenuState();
}

class DrinkSwitchMenuState extends State<DrinkSwitchMenu>
    with TickerProviderStateMixin {
  AnimationController controller;

  Animation<double> drinkScaleAnim;
  Animation<double> drinkTiltAnim;
  Animation<double> drinkTranslateAnim;

  static Key frappeKey = new Key("__frappe__");
  static Key glassKey = new Key("__glass__");
  Key active = frappeKey;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    drinkScaleAnim = new Tween<double>(begin: 1.0, end: 1.5).animate(
        CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.5, curve: Curves.easeIn)));

    drinkTiltAnim = new Tween<double>(begin: 0.0, end: 40.0).animate(
        CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.5, curve: Curves.easeIn)));

    drinkTranslateAnim = new Tween<double>(begin: 0.0, end: 30.0).animate(
        CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.5, curve: Curves.easeIn)));

    drinkScaleAnim.addListener(() {
      setState(() {});
    });

    drinkTiltAnim.addListener(() {
      setState(() {});
    });

    drinkTranslateAnim.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inactiveTransform = new Matrix4.identity()
      ..translate(-10.0 - drinkTranslateAnim.value, 0.0, 0.0)
      ..scale(drinkScaleAnim.value, drinkScaleAnim.value)
      ..rotateZ(-drinkTiltAnim.value * (pi / 180));

    final activeTransform = new Matrix4.identity()
      ..translate(0.0, 10.0 + drinkTranslateAnim.value, 0.0)
      ..scale(drinkScaleAnim.value, drinkScaleAnim.value)
      ..rotateZ(drinkTiltAnim.value * (pi / 100));

    final glass = new Transform(
      key: glassKey,
      transform: active == glassKey ? activeTransform : inactiveTransform,
      origin: Offset(20.0, 20.0),
      child: Image.asset(
        "assets/images/glass.png",
        width: 35.0,
        height: 35.0,
      ),
    );

    final frappe = new Transform(
      key: frappeKey,
      transform: active == frappeKey ? activeTransform : inactiveTransform,
      origin: Offset(20.0, 20.0),
      child: Image.asset(
        "assets/images/frappe.png",
        width: 35.0,
        height: 35.0,
      ),
    );

    return GestureDetector(
      onTap: () {
        swapDrinks();
      },
      child: Container(
        child: Stack(
          children: active == glassKey ? [frappe, glass] : [glass, frappe],
        ),
      ),
    );
  }

  void swapDrinks() async{
    await controller.forward();

    widget.drinkTypeStream.add(active == frappeKey ? DrinkType.glass : DrinkType.frappe);

    await controller.reverse();

    setState(() {
      if(active == glassKey){
        active = frappeKey;
      }else if(active == frappeKey){
        active = glassKey;
      }
    });
  }
}
