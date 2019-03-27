import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:one_day_show/DrinkShop/home.dart';
import 'package:flutter/services.dart';

void main() => runApp(DrinkShopApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class DrinkShopApp extends StatelessWidget{

  DrinkShopApp() {
    SystemChrome.setPreferredOrientations(
        <DeviceOrientation>[DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drink Shop',
      home: new DrinkShopHome(),
    );
  }

}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final docReference = Firestore.instance.document("Show/today");

  static Widget profileWidget() {
    return Center(
      child: Stack(
        children: <Widget>[
          Container(
            height: 100.0,
            width: 100.0,
            color: Colors.greenAccent,
          ),
          Container(
            height: 80.0,
            width: 80.0,
            color: Colors.greenAccent,
          ),
          Container(
            height: 50.0,
            width: 50.0,
            color: Colors.greenAccent,
          ),
        ],
      ),
    );
  }

  void add() {
    Map<String, int> data = <String, int>{
      "number": Random.secure().nextInt(99),
    };
    docReference.setData(data).whenComplete(() {
      print("Random Number Added");
    }).catchError((e) => print(e));
  }

  Widget myAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.monetization_on,
            color: Colors.red,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              '1 Day Show',
              style:
              TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Icon(
            Icons.videocam,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  int _selectedIndex = 1;

  Widget myBottomNavBar() {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.blueGrey[100],
        primaryColor: Colors.blueAccent,
        textTheme: Theme
            .of(context)
            .textTheme
            .copyWith(
          caption: new TextStyle(
            color: Colors.black54,
          ),
        ),
      ),
      child: BottomNavigationBar(
        onTap: _onNavItemTapped,
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset),
            title: Text(
                'Show'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity),
            title: Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset),
            title: Text(
                'Show'),
          ),
        ],
      ),
    );
  }

  void _onNavItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),

      body: TodayShow(context),
      bottomNavigationBar: myBottomNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(onPressed: () {}),
    );
  }

  Widget getLuckyNumber(AsyncSnapshot snapshot) {
    var num = snapshot.data['number'];
    return Text('$num');
  }

  Widget TodayShow(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder(
                  stream: Firestore.instance.document("Show/today").snapshots()
                  , builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();
                return Column(
                  children: <Widget>[
                    Text('Lucky Number'),
                    getLuckyNumber(snapshot),
                  ],
                );
              }),
            ),
          )
          , Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: RaisedButton(
                onPressed: add,
                child: Text("Lucky Number"),
                color: Colors.deepPurpleAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
