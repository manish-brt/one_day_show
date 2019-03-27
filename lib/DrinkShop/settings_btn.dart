import 'package:flutter/material.dart';
import 'package:one_day_show/DrinkShop/colors.dart';
import 'package:one_day_show/DrinkShop/icons.dart';
import 'package:one_day_show/customWidgets/packman_slider.dart';
import 'package:one_day_show/customWidgets/wave_slider.dart';

class SettingButton extends StatefulWidget {
  @override
  State createState() => SettingButtonState();
}

class SettingButtonState extends State<SettingButton> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) =>Dialog(
            insetAnimationCurve: ElasticInCurve(),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: Container(
              color: DrinkShopColors.carouselCardColor,
              height: 320,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment(-9, 0),
                    child: Container(
                      width: 250,
                      height: 400,
                      child: Image.asset(
                        "assets/images/frappe_with_straw.png",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60.0, right: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(2.0),
                          child: WaveSlider(
                            width: 300,
                            height: 50,
                            color: Colors.white,
                            onChanged: (double val) {
//                      _updateSliderValue(val);
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(2.0),
                          child: WaveSlider(
                            width: 300,
                            height: 50,
                            color: Colors.blue,
                            onChanged: (double val) {
//                      _updateSliderValue(val);
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(2.0),
                          child: WaveSlider(
                            width: 300,
                            height: 50,
                            color: Colors.black,
                            onChanged: (double val) {
//                      _updateSliderValue(val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: true),
      child: Container(
        width: 50.00,
        height: 50.0,
        decoration: BoxDecoration(
            color: DrinkShopColors.buttonAccentColor,
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 4.0,
                blurRadius: 3.0,
                offset: Offset(1.0, 1.0),
              )
            ]),
        child: Icon(
          DrinkShopIcons.controls,
          color: Colors.white,
        ),
      ),
    );
  }

  int sliderVal = 0;

  void _updateSliderValue(double val) {
    setState(
      () {
        sliderVal = (val * 100).round();
      },
    );
  }
}
