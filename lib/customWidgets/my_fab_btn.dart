import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class FancyButton extends StatelessWidget {
  FancyButton({@required this.onPressed});

  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RawMaterialButton(
      fillColor: Colors.deepOrangeAccent,
      splashColor: Colors.blue,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 14.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RotatedBox(
              quarterTurns: 1,
                child: Icon(
              Icons.touch_app,
              color: Colors.white,
            )),
            SizedBox(
              width: 10,
            ),
            Text(
              'Tap',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ],
        ),
      ),
      onPressed: onPressed,
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(9.0),
        ),
      ),
      elevation: 8.0,
    );
  }
}
