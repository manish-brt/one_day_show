import 'dart:async';
import 'package:flutter/material.dart';
import 'package:one_day_show/DrinkShop/colors.dart';
import 'package:one_day_show/DrinkShop/drink_carousel_item.dart';
import 'package:one_day_show/DrinkShop/models.dart';
import 'package:one_day_show/DrinkShop/drink_carousel.dart';
import 'package:one_day_show/DrinkShop/settings_btn.dart';
import 'package:one_day_show/DrinkShop/add_btn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


int itemCount = 0;

class DrinkSelectionPanel extends StatefulWidget {
  final StreamController<DrinkType> drinkTyeStream;
  final Size size;

  DrinkSelectionPanel(this.drinkTyeStream, this.size);

  @override
  State createState() => _DrinkSelectionPanelState();
}

class _DrinkSelectionPanelState extends State<DrinkSelectionPanel>
    with TickerProviderStateMixin {
  AnimationController expansionAnimController;
  Animation<double> expandAnim;
  Animation<double> carouselTranslateAnim;

  AnimationController drinkTypeAnimController;
  Animation<double> carouselSwitchTranslateAnim;
  Animation<double> carouselOpacityAnim;

  DrinkType currentDrinkType = DrinkType.frappe;

  int currentPage = 0;
  PageController pageController;
  List<Drink> drinks;

  @override
  void initState() {
    super.initState();

    drinks = getDrinks(currentDrinkType);
    currentPage = (drinks.length / 2).round();
    pageController =
        PageController(initialPage: currentPage, viewportFraction: 1);

    expansionAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    expandAnim = Tween<double>(begin: 80.0, end: 0.0).animate(CurvedAnimation(
        parent: expansionAnimController, curve: Curves.easeInOut));
    carouselTranslateAnim = Tween<double>(begin: 30.0, end: -50.0).animate(
        CurvedAnimation(
            parent: expansionAnimController, curve: Curves.easeInOut));

    expandAnim.addListener(() {
      setState(() {});
    });
    carouselTranslateAnim.addListener(() {
      setState(() {});
    });

    drinkTypeAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));

    carouselSwitchTranslateAnim = Tween<double>(begin: 0.0, end: 40.0).animate(
        CurvedAnimation(
            parent: expansionAnimController, curve: Curves.easeInOut));
    carouselOpacityAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: expansionAnimController, curve: Curves.easeInOut));

    carouselSwitchTranslateAnim.addListener(() {
      setState(() {});
    });
    carouselOpacityAnim.addListener(() {
      setState(() {});
    });

    widget.drinkTyeStream.stream.listen((type) async {
      await drinkTypeAnimController.forward();
      setState(() {
        currentDrinkType = type;
      });
      drinkTypeAnimController.reverse();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    drinks = getDrinks(currentDrinkType);

    return Stack(
      children: <Widget>[
        ClipOval(
          clipper: _CustomClipOval(
            clipOffset: expandAnim.value + 40,
          ),
          child: SizedBox(
            width: widget.size.width,
            height: widget.size.height,
            child: Container(
              padding: const EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                color: DrinkShopColors.backgroundAccentColor,
              ),
              child: PageView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                controller: pageController,
                itemCount: drinks.length,
                itemBuilder: (BuildContext context, int index){
                  return DrinkCarousel(
                    drinks: drinks,
                    drinkSwitchYTranslation: carouselSwitchTranslateAnim.value,
                    carouselExpandYTranslation: carouselTranslateAnim.value,
                    opacity: carouselOpacityAnim.value,
                  );
                },
//                child: DrinkCarousel(
//                  drinks: drinks,
//                  drinkSwitchYTranslation: carouselSwitchTranslateAnim.value,
//                  carouselExpandYTranslation: carouselTranslateAnim.value,
//                  opacity: carouselOpacityAnim.value,
//                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: widget.size.width / 6,
          top: widget.size.width *(3/4) + expandAnim.value,
          child: SettingButton(),
        ),
        Positioned(
          right: widget.size.width / 6,
          top: widget.size.width *(3/4) - 10 + expandAnim.value,
          child: AddButton(onTap: () {
            if (expansionAnimController.status != AnimationStatus.completed) {
              expansionAnimController.forward();
            } else {
              expansionAnimController.reverse();
            }
            addDrinkToCart();
          }),
        )
      ],
    );
  }


  void addDrinkToCart() {
    itemCount ++;
    final docReference = Firestore.instance.document("Show/today");

    Map<String, int> data = <String, int>{
      "number": itemCount,
    };
    docReference.setData(data).whenComplete(() {
      print("Drink Added");
    }).catchError((e) => print(e));

//    List<DrinkCarouselItem> _buildChildren() {
//      final children = <DrinkCarouselItem>[];
//      for (var i = 0; i < drinks.length; ++i) {
//        final child = new DrinkCarouselItem(
//          size: const Size(140, 180),
//          drink:drinks[i],
//          onDrinkSelected: null,
//          active: i == currentActiveIndex,
//        );
//        children.add(child);
//      }
//      return children;
//    }

  }
}

class _CustomClipOval extends CustomClipper<Rect> {
  final double clipOffset;

  _CustomClipOval({this.clipOffset});

  // expanded -> offset (size.width / 2, 150)
  // collapsed -> offset (size.width / 2, 50)
  @override
  Rect getClip(Size size) {
    return new Rect.fromCircle(
        center: new Offset(size.width / 2, clipOffset), radius: size.width*(3/4));
  }

  @override
  bool shouldReclip(_CustomClipOval oldClipper) =>
      oldClipper.clipOffset != clipOffset;
}
