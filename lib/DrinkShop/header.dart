import 'package:flutter/material.dart';
import 'package:one_day_show/DrinkShop/colors.dart';
import 'package:one_day_show/DrinkShop/icons.dart';
import 'dart:async';
import 'package:one_day_show/DrinkShop/drink_switch_menu.dart';

class DrinkShopHeader extends StatelessWidget {
  final StreamController drinkTypeStream;

  DrinkShopHeader(this.drinkTypeStream);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20.0,
        right: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IconButton(
            icon: Icon(
              DrinkShopIcons.menu,
              color: DrinkShopColors.headerIconColor,
              size: 30.0,
            ),
            onPressed: () {},
          ),
          Expanded(
            child: Container(),
          ),
          new DrinkSwitchMenu(drinkTypeStream),
        ],
      ),
    );
  }
}
