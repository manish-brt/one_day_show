import'package:flutter/material.dart';
import 'package:one_day_show/DrinkShop/colors.dart';
import 'package:one_day_show/DrinkShop/icons.dart';
//import 'package:meta/meta.dart';

class AddButton extends StatefulWidget {
  final VoidCallback onTap;

  AddButton({@required this.onTap});

  @override
  State createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> with TickerProviderStateMixin {
  final double radius = 75.0;
  double radiusScale = 1.0;

  AnimationController btnAnimcontroller;
  Animation<double> buttonScaleAnim;

  @override
  void initState() {
    super.initState();

    btnAnimcontroller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));

    buttonScaleAnim = Tween<double>(begin: 1.0, end: 0.8)
        .animate(CurvedAnimation(parent: btnAnimcontroller, curve: Curves.easeIn));

    buttonScaleAnim.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    btnAnimcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await btnAnimcontroller.forward();
        widget.onTap();
        await btnAnimcontroller.reverse();
      },
      child: Container(
        width: radius * buttonScaleAnim.value,
        height: radius * buttonScaleAnim.value,
        decoration: BoxDecoration(
          color: DrinkShopColors.buttonColor,
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 1.0,
              blurRadius: 3.0,
              offset: Offset(1.0, 2.0),
            ),
          ],
        ),
        child: Icon(
          DrinkShopIcons.plus,
          color: Colors.white,
        ),
      ),
    );
  }
}
