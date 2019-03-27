import 'package:flutter/material.dart';
import 'package:one_day_show/DrinkShop/colors.dart';

class PlaceOrderBtn extends StatefulWidget {
  @override
  State createState() => PlaceOrderBtnState();
}

class PlaceOrderBtnState extends State<PlaceOrderBtn> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 75,
        color: DrinkShopColors.buttonColor,
        alignment: Alignment.bottomRight,
        child: Center(
          child: Text(
            "PLACE AN ORDER",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
