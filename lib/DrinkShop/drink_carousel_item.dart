import 'dart:math';

import 'package:flutter/material.dart';
import 'package:one_day_show/DrinkShop/models.dart';
import 'package:one_day_show/database/database.dart';
import 'package:one_day_show/model/drink_cart_model.dart';

class DrinkCarouselItem extends StatefulWidget {
  final Size size;
  final Drink drink;
  final bool active;
  final Function(Drink) onDrinkSelected;

  DrinkCarouselItem({
    this.size,
    this.drink,
    this.active: false,
    this.onDrinkSelected,
  });

  @override
  State createState() => DrinkCarouselItemState();
}

class DrinkCarouselItemState extends State<DrinkCarouselItem>
    with TickerProviderStateMixin {
  AnimationController onTapAimController;
  Animation<double> tiltAnim;
  Animation<double> translateAnim;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    onTapAimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    tiltAnim = Tween<double>(begin: 0.0, end: 50.0).animate(CurvedAnimation(
        parent: onTapAimController,
        curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn)));

    translateAnim = Tween<double>(begin: 0.0, end: 60.0).animate(
        CurvedAnimation(
            parent: onTapAimController,
            curve: Interval(0.0, 1.0, curve: Curves.elasticIn)));

    tiltAnim.addListener(() {
      setState(() {});
    });

    translateAnim.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final transform = new Matrix4.translationValues(
        (-1 * translateAnim.value) + 10.0, -1 * translateAnim.value, 0.0)
      ..rotateZ(-1 * tiltAnim.value * (pi / 180));

    return GestureDetector(
      onTap: _tapped,
      child: Transform(
        alignment: Alignment.center,
        transform: transform,
        child: SizedBox(
          width: widget.size.width,
          height: widget.size.height,
          child: Image.asset(
            widget.drink.asset,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _tapped() async {
    if (widget.active) {
      await onTapAimController.forward();
      await onTapAimController.reverse();
      if (null != widget.onDrinkSelected) {
        widget.onDrinkSelected(widget.drink);
        DrinkCart dCart = new DrinkCart();
        dCart.drinkType = widget.drink.drinkType.toString();
        dCart.drinkName =  widget.drink.name;
        dCart.drinkPrice = widget.drink.price;
        DrinkDatabase.get().updateCart(dCart);
      }
    }
  }
}
