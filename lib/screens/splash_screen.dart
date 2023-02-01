import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'menu_screen.dart';
import 'package:ecorn/globals.dart';

class SplashScreen extends StatefulWidget {
  static final routeName = "splashScreen";

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  Future<String> getData() async {
    Response categoriesResponse =
        await get(API_URL + '/api/admin/v1/categories');

    Response menusResponse = await get(API_URL + '/api/admin/v1/menus');

    this.setState(() {
      categories = json.decode(categoriesResponse.body)['data']['recs'];
      menus = json.decode(menusResponse.body)['data']['recs'];
    });

    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MenuScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 500),
    );

    _animation = new CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _animation.addListener(() => this.setState(() {}));
    _animationController.forward();
    _checkConnectivity();
    this.getData();
  }

  _checkConnectivity() async {
    var result = await (Connectivity().checkConnectivity());
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      getData();
    } else {
      _showDialog('Упс...', 'Проверьте подключение к интернету');
    }
  }

  _showDialog(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: [
              FlatButton(
                child: Text(
                  'Подключиться снова',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  setState(() {
                    getData();
                  });
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF00633E),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only(top: 10.0)),
              Container(
                height: _animation.value * 150.0,
                child: Image.asset(
                  'images/logo.png',
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
        ));
  }
}
