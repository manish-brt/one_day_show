import 'package:one_day_show/model/drink_cart_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';

class DrinkDatabase {
  static final DrinkDatabase _drinkDatabase = new DrinkDatabase._internal();

  final String tableName = "Cart";

  Database db;

  bool didInit = false;

  static DrinkDatabase get() {
    return _drinkDatabase;
  }

  DrinkDatabase._internal();

  Future init() async {
    return await _init();
  }

  Future<Database> _getDB() async {
    if (!didInit) await _init();
    return db;
  }

  Future _init() async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path, "cart.db");

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE $tableName ("
          "${DrinkCart.db_id} STRING PRIMARY KEY,"
          "${DrinkCart.db_drinkType} TEXT,"
          "${DrinkCart.db_drinkName} TEXT,"
          "${DrinkCart.db_drinkPrice} NUMBER"
          ")");
    });
    didInit = true;
  }

  //to fetch a drink in cart by id
  Future<DrinkCart> getDrinkCartFromCart(String id) async {
    var db = await _getDB();
    var result = await db
        .rawQuery('SELECT * FROM $tableName WHERE ${DrinkCart.db_id} = "$id"');
    if (result.length == 0) return null;
    return new DrinkCart.fromMap(result[0]);
  }

  //to fetch all drinks in cart by id
  Future<List<DrinkCart>> getDrinksFromCart(List<String> ids) async {
    var db = await _getDB();
    var idsDtring = ids.map((it) => '"$it"').join(',');
    var result = await db.rawQuery(
        'SELECT FROM $tableName WHERE ${DrinkCart.db_id} IN ($idsDtring)');

    List<DrinkCart> drinkCart = [];
    for (Map<String, dynamic> items in result) {
      drinkCart.add(new DrinkCart.fromMap(items));
    }

    return drinkCart;
  }

  Future updateCart(DrinkCart dCart) async {
    var db = await _getDB();
    await db.rawInsert('INSERT OR REPLACE INTO '
        '$tableName(${DrinkCart.db_id}, ${DrinkCart.db_drinkType}, ${DrinkCart.db_drinkName}, ${DrinkCart.db_drinkPrice})'
        ' VALUES (?, ?, ?, ?)' , [dCart.id, dCart.drinkType, dCart.drinkName, dCart.drinkPrice]);
  }

  Future<int> getCount() async{
    var db = await _getDB();
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  Future close() async{
    var db = await _getDB();
    return db.close();
  }
}
