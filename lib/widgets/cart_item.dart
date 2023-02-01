import 'package:auto_size_text/auto_size_text.dart';
import 'package:ecorn/screens/cart_screen.dart';
import 'package:ecorn/screens/menu_item_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:ecorn/globals.dart';

class CartItem extends StatefulWidget {
  CartItem({
    this.count,
    this.name,
    this.desc,
    this.price,
    this.miniDesc,
    this.image,
    this.data,
    this.updateCart,
    this.updateSum,
  });

  final String name;
  final String desc;
  final String price;
  final int count;
  final String miniDesc;
  final String image;
  final Map data;
  final Function updateCart;
  final Function updateSum;

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  String name;
  String desc;
  String price;
  int count;
  String miniDesc;
  String image;
  Map data;
  Function updateCart;
  Function updateSum;

  void initState() {
    name = widget.name;
    desc = widget.desc;
    price = widget.price;
    count = widget.count;
    miniDesc = widget.miniDesc;
    image = widget.image;
    data = widget.data;
    updateCart = widget.updateCart;
    updateSum = widget.updateSum;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 15, top: 5, bottom: 0),
                height: 100.0,
                width: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: NetworkImage(
                          API_URL + json.decode(image)[0]['little']),
                      fit: BoxFit.cover),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: AutoSizeText(
                        json.decode(name)[LANG],
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                        maxLines: 3,
                        minFontSize: 16,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 7,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  minus();
                                },
                                icon: Icon(Icons.remove),
                              ),
                              Text(
                                count.toString(),
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  add();
                                },
                                icon: Icon(Icons.add),
                              ),
                            ],
                          ),
                        ),

                        Flexible(
                          flex: 3,
                          child: Container(
//                            margin: EdgeInsets.only(left: 50),
                            child: IconButton(
                              onPressed: () {
                                updateCart(data);
                              },
                              icon: Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Text(
              price,
              style: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 18,
              ),
            ),
          ),
        ),
        Divider(
          height: 10.0,
          thickness: 0.5,
          color: Colors.blueGrey,
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }

  //ADD
  void add() {
    setState(() {
      count++;
    });

    CART.forEach((element) {
      if (element['menu_id'] == data['menu_id']) {
        element['count'] = element['count'] + 1;
      }
    });
    updateSum();
  }

//MINUS
  void minus() {
    setState(() {
      if (count != 1) count--;
    });

    CART.forEach((element) {
      if (element['menu_id'] == data['menu_id']) {
        if (element['count'] != 1) element['count'] = element['count'] - 1;
      }
    });
    updateSum();
  }
}
