import 'package:auto_size_text/auto_size_text.dart';
import 'package:ecorn/bloc/counter_menu_item/counter_cubit.dart';
import 'package:ecorn/screens/cart_screen.dart';
import 'package:ecorn/screens/menu_screen.dart';
import 'package:ecorn/widgets/cart_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:ecorn/globals.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuItemInfo extends StatefulWidget {
  static final routeName = "menuItemInfo";

  MenuItemInfo({this.data, this.update});

  final Map data;
  final Function update;

  @override
  _MenuItemInfoState createState() => _MenuItemInfoState();
}

class _MenuItemInfoState extends State<MenuItemInfo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void initState() {
    data = widget.data;
    update = widget.update;
    name = json.decode(data['menu_name'])[LANG];
    desc = json.decode(data['menu_desc'])[LANG];
    price = data['menu_price'];
    image = json.decode(data['menu_image'])[0]['big'];
    super.initState();
  }

  Map data;
  String name;
  String desc;
  String image;
  String price;
  Function update;

  int _n = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(
            name,
            style: TextStyle(
              fontFamily: 'Rubik',
            ),
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  onPressed: () {
                    var future =
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                    future.then((value) {
                      setState(() {
                        update();
//                      CART.length.toString();
                      });
                    });
                  },
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                if (CART.length > 0)
                  Positioned(
                    left: 16,
                    top: 5,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 8.0,
                      child: Text(
                        CART.length.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Rubik',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
              ],
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Column(
                    children: [
                      //Image
                      Container(
                        height: 280,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(API_URL + image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      /* Счетчик */
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () =>
                                  context.bloc<CounterCubit>().decrement(),
                              icon: Icon(
                                Icons.remove,
                                size: 30,
                                color: Color(0xFF00633E),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: BlocBuilder<CounterCubit, int>(
                                builder: (context, state) {
                                  return Text(
                                    '$state',
                                    style: TextStyle(
                                        color: Color(0xFF00633E),
                                        fontSize: 40,
                                        fontFamily: 'Rubik'),
                                  );
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  context.bloc<CounterCubit>().increment(),
                              icon: Icon(
                                Icons.add,
                                size: 30,
                                color: Color(0xFF00633E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Заголовок,Описание продукта,Цена
                      Container(
                        margin: EdgeInsets.only(top: 8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 20, right: 20),
                              child: AutoSizeText(
                                desc,
                                textAlign: TextAlign.center,
                                maxLines: 10,
                                minFontSize: 5,
                                style: TextStyle(
                                  color: Color(0xFF888888),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Rubik',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text(
                                price + ' сум',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Rubik',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            BlocBuilder<CounterCubit, int>(
              builder: (context, state) {
                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(top: 10.0, bottom: 20),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: BorderSide(color: Color(0xFF00633E))),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 30.0, right: 30.0),
                            child: AutoSizeText("Добавить в Корзину",
                                maxLines: 1,
                                minFontSize: 0,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontFamily: 'Rubik')),
                          ),
                          color: Color(0xFF00633E),
                          colorBrightness: Brightness.dark,
                          onPressed: () {
                            setState(() {
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  backgroundColor: Color(0xFFFF9E9E9E),
                                  content: Text(
                                    'Добавлено в корзину',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Rubik',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  duration: Duration(milliseconds: 600),
                                ),
                              );
                              var flag = true;
                              CART.forEach((el) => {
                                    if (el['menu_id'] == data['menu_id'])
                                      {flag = false}
                                  });

                              if (flag) {
                                data['count'] = state;
                                CART.add(data);
                              } else {
                                data['count'] += state;
                              }
                              update();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ));
  }
}
