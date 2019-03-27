import 'package:flutter/material.dart';
import 'package:one_day_show/DrinkShop/drink_carousel_item.dart';
import 'package:one_day_show/DrinkShop/place_order_btn.dart';
import 'package:one_day_show/database/database.dart';
import 'header.dart';
import 'colors.dart';
import 'models.dart';
import 'dart:async';
import 'drink_selection_panel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrinkShopHome extends StatefulWidget {
  @override
  State createState() => DrinkShopHomeState();
}

class DrinkShopHomeState extends State<DrinkShopHome> {
  StreamController<DrinkType> drinkTypeStream;

  @override
  void initState() {
    super.initState();
    drinkTypeStream = StreamController<DrinkType>();
  }

  @override
  void dispose() {
    drinkTypeStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final panelSize = Size(screenWidth, screenHeight * 4 / 5);

    return Scaffold(
      body: Container(
        color: DrinkShopColors.backgroundColor,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: Stack(
          children: <Widget>[
            _buildOrderItems2(),
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Opacity(
                opacity: 0.8,
                child: PlaceOrderBtn(),
              ),
            ),
            DrinkSelectionPanel(drinkTypeStream, panelSize),
            DrinkShopHeader(drinkTypeStream),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItems() {
    return Padding(
//      alignment: Alignment(0.0, 0.0),
      padding: EdgeInsets.only(top: 400),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Image.asset(
            "assets/images/frappe_with_straw.png",
            width: 110,
            height: 120,
          );
        },
      ),
    );
  }

  Widget _buildOrderItems2() {
    return Padding(
//      alignment: Alignment(0.0, 0.0),
      padding: EdgeInsets.only(top: 400),
      child: StreamBuilder(
          stream: Firestore.instance.document("Show/today").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: snapshot.data['number'],
              itemBuilder: (BuildContext context, int index) {
                return Image.asset(
                  "assets/images/frappe_with_straw.png",
                  width: 110,
                  height: 120,
                );
              },
            );
          }),
    );
  }
}
