import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:ecorn/screens/order_Info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecorn/widgets/cart_item.dart';
import 'package:ecorn/styles/font_styles.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:ecorn/globals.dart';
import 'package:localstorage/localstorage.dart';
import 'profile_screen.dart';

class CartScreen extends StatefulWidget {
  static final routeName = "cartScreen";

  CartScreen({this.price, this.data});

  final String price;
  final Map data;

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String price;
  Map data;
  var loginButtonDisable = false;
  var lengthCart = CART.length > 0;
  int _n = 1;

  void updateCart(data) {
    setState(() {
      CART.remove(data);
      totalPrice = totalPrice - int.parse(data['menu_price']);
    });
    updateSum();
  }

  void updateSum() {
    setState(() {
      totalPrice = 0;
      CART.forEach((element) {
        totalPrice =
            totalPrice + element['count'] * int.parse(element['menu_price']);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    totalPrice = 0;
    CART.forEach((element) {
      totalPrice =
          totalPrice + element['count'] * int.parse(element['menu_price']);
    });
  }

  void getPermission() async {
    PermissionStatus permission =
        await LocationPermissions().requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final LocalStorage storage = new LocalStorage('auth');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Корзина',
          style: kTitleAppBar,
        ),
      ),
      body: lengthCart
          ? Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: CART == null ? 0 : CART.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            key: UniqueKey(),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              CartItem(
                                name: CART[index]['menu_name'],
                                desc: CART[index]['menu_desc'],
                                miniDesc: CART[index]['menu_mini_desc'],
                                price: CART[index]['menu_price'],
                                image: CART[index]['menu_image'],
                                count: CART[index]['count'],
                                data: CART[index],
                                updateCart: this.updateCart,
                                updateSum: this.updateSum,
                              ),
                            ],
                          );
                        }),
                  ),
                  Divider(
                    thickness: 3,
                    color: Colors.black45,
                    endIndent: 90,
                    indent: 90,
                  ),
                  Stack(
                    children: [
                      Positioned(
                        child: Container(
//                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15.0),
                                      child: AutoSizeText(
                                        'Общая стоимость:',
                                        style: kPriceContainer,
                                        maxLines: 1,
                                        minFontSize: 0,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 15.0),
                                      child: AutoSizeText(
                                        totalPrice.toString(),
                                        style: kPriceContainer,
                                        maxLines: 1,
                                        minFontSize: 0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 30),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: RaisedButton(
                                    color: Color(0xFF00633E),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        side: BorderSide(color: Color(0xFF00633E))),
                                    onPressed: () {
                                      var user = storage.getItem('user');
                                      print(user);
                                      if (user == null) {
                                        Navigator.of(context).popAndPushNamed(
                                            ProfileScreen.routeName);
                                        return;
                                      }

                                      getPermission();

                                      /*if (totalPrice < 50000) {
                                        _showPriceError();
                                      } else */

                                      if (CART.isEmpty) {
                                        loginButtonDisable = false;
                                      } else {
                                        Navigator.of(context)
                                            .pushNamed(OrderInfo.routeName);
                                      }

                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: AutoSizeText(
                                        'Подтвердить Заказ',
                                        style: kTextStyleButton,
                                        maxLines: 1,
                                        minFontSize: 0,
                                      ),
                                    ),

                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          : Container(
              child: Center(
                child: Text(
                  'Ваша корзина пуста',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 20,
                  ),
                ),
              ),
            ),
    );
  }

  showConfirmDialog() {
    return AlertDialog(
      title: Text('Вы точно хотите удалить?'),
      actions: [
        FlatButton(
          child: Text('Да'),
        ),
        FlatButton(
          child: Text('Нет'),
        ),
      ],
    );
  }

  _showPriceError() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 4,
        titlePadding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Center(
          child: Text(
            'Оформить заказ можно только свыше 50.000сум',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Rubik',
                fontWeight: FontWeight.bold,
                fontSize: 23.0,
                wordSpacing: 2),
          ),
        ),
        contentPadding: EdgeInsets.only(bottom: 25.0, left: 10),
        backgroundColor: Color(0xFF00633E),
      ),
    );
  }

  _showCartError() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 4,
        titlePadding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Center(
          child: Text(
            'Ваша Корзина пуста,перейдите в меню',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Rubik',
                fontWeight: FontWeight.bold,
                fontSize: 23.0,
                wordSpacing: 2),
          ),
        ),
        contentPadding: EdgeInsets.only(bottom: 25.0, left: 10),
        backgroundColor: Color(0xFF00633E),
      ),
    );
  }
}
