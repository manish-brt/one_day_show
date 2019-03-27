import 'package:flutter/material.dart';
import 'package:one_day_show/DrinkShop/colors.dart';
import 'dart:math';

class DrinkCarouselCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(110.0, 80.0),
      painter: DrinkCarouselPainter(),
    );
  }
}

class DrinkCarouselPainter extends CustomPainter {
  final Paint cardPaint;
  final Paint cardLinePaint;
  final Paint cardBackPaint;

  DrinkCarouselPainter()
      : cardPaint = new Paint(),
        cardLinePaint = new Paint(),
        cardBackPaint = new Paint() {
    cardPaint.color = DrinkShopColors.carouselCardColor;
    cardPaint.style = PaintingStyle.fill;
    cardLinePaint.color = DrinkShopColors.carouselCardLineColor;
    cardLinePaint.style = PaintingStyle.fill;
    cardBackPaint.color = DrinkShopColors.carouselCardBackColor;
    cardBackPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Path cardBackPath = new Path();
    cardBackPath.moveTo(0.8 * size.width, 0.0);
    cardBackPath.lineTo(size.width, 0.6 * size.height);
    cardBackPath.lineTo(0.2 * size.width, 0.6 * size.height);
    cardBackPath.close();
    canvas.drawPath(cardBackPath, cardBackPaint);

    Path cardPath = new Path();
    cardPath.moveTo(0.2 * size.width, 0.0);
    cardPath.lineTo(0.0, 0.7 * size.height);
    cardPath.lineTo(0.6 * size.width, size.height);
    cardPath.lineTo(0.8 * size.width, 0.0);
    cardPath.close();
    canvas.drawPath(cardPath, cardPaint);

    canvas.rotate(8 * (pi / 180));
    canvas.save();

    final horizontalPadding = 5.0;
    final verticalPadding = 10.0;
    final lineHeigh = 20.0;

    var rrect = new RRect.fromLTRBR(
        0.2 * size.width + horizontalPadding,
        verticalPadding,
        0.7 * size.width - horizontalPadding,
        lineHeigh,
        Radius.circular(5.0));

    canvas.drawRRect(rrect, cardLinePaint);
    canvas.rotate(4 * (pi / 180));

    rrect = new RRect.fromLTRBR(
        0.2 * size.width,
        verticalPadding + lineHeigh,
        0.7 * size.width - horizontalPadding,
        (2 * verticalPadding) + lineHeigh,
        Radius.circular(5.0));
  
    canvas.drawRRect(rrect, cardLinePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
