import 'package:meta/meta.dart';

class DrinkCart {
  static final db_id = "id";
  static final db_drinkType = "drinkType";
  static final db_drinkName = "drnikName";
  static final db_drinkPrice = "drinkPrice";

  String id, drinkType, drinkName;
  double drinkPrice;

  DrinkCart({
    this.id,
    this.drinkType,
    this.drinkName,
    this.drinkPrice,
  });

  DrinkCart.fromMap(Map<String, dynamic> map)
      : this(
          id: map[db_id],
          drinkType: map[db_drinkType],
          drinkName: map[db_drinkName],
          drinkPrice: map[db_drinkPrice],
        );

  Map<String, dynamic> toMap(){
    return{
      db_id : id,
      db_drinkType : drinkType,
      db_drinkName : drinkName,
      db_drinkPrice : drinkPrice,
    };
  }
}
