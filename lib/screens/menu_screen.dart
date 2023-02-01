import 'package:ecorn/screens/menu_item_info.dart';
import 'package:flutter/material.dart';
import 'package:ecorn/widgets/nav.dart';
import 'package:ecorn/widgets/menu_item.dart';
import 'package:ecorn/widgets/menu_cat.dart';
import '../globals.dart';
import 'cart_screen.dart';
import 'dart:convert';
import 'dart:async';

var catName = null;
var catId = null;
var search = false;

class MenuScreen extends StatefulWidget {
  static final routeName = "menuScreen";

  MenuScreen({this.data});
  final Map data;

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  TextEditingController searchController;
  List menusFiltered = List();
  Map data;

  void update() {
    setState(() {});
  }

  @override
  void initState() {
    catId = categories[0]['category_id'];
    searchController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Меню',
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Rubik',
            ),
          ),
          actions: <Widget>[
            Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    var future1 =
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                    future1.then((value) {
                      setState(() {
                        CART.length.toString();
                      });
                    });
                  },
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
                  ),
              ],
            ),
          ],
        ),
        drawer: NavDrawer(),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Column(
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      height: 180.0,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: categories == null ? 0 : categories.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      search = false;
                                      catName = json.decode(categories[index]
                                          ['category_name'])['ru'];
                                      catId = categories[index]['category_id'];
                                      menusFiltered.clear();

                                      var menuCats = json
                                          .decode(menus[index]['category_id']);
                                      var flag = false;

                                      menuCats.forEach((k, v) {
                                        setState(() {
                                          menusFiltered.add(menus[index]);
                                        });
                                      });
                                    });
                                  },
                                  child: MenuCat(
                                    name: categories[index]['category_name'],
                                    image: categories[index]['category_image'],
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                    Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 15.0,
                          ),
                          child: Icon(Icons.arrow_forward),
                        )),
                  ],
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        catName ??
                            json.decode(categories[0]['category_name'])['ru'],
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w500,
                          fontSize: 25.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 5,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFf5f5f5)),
                  child: TextField(
                    onChanged: (content) {
                      menusFiltered.clear();
                      catId = 0;

                      setState(() {
                        search = true;
                        catName = "Поиск по всем блюдам";
                      });

                      menus.forEach((element) {
                        var name = json
                            .decode(element['menu_name'])[LANG]
                            .toLowerCase();

                        if (name.contains(content.toLowerCase())) {
                          setState(() {
                            menusFiltered.add(element);
                          });
                        }
                      });
                    },
                    textInputAction: TextInputAction.search,
                    controller: searchController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Поиск',
                      prefixIcon: Icon(Icons.search),
                      hintStyle: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: search
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              menusFiltered == null ? 0 : menusFiltered.length,
                          itemBuilder: (BuildContext context, int index) {
                            var menuCats = json
                                .decode(menusFiltered[index]['category_id']);
                            var flag = false;

                            if (catId != 0) {
                              menuCats.forEach((k, v) {
                                if (v == catId) flag = true;
                              });

                              if (!flag) return Column();
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                MenuItem(
                                  name: menusFiltered[index]['menu_name'],
                                  desc: menusFiltered[index]['menu_name'],
                                  miniDesc: menusFiltered[index]
                                      ['menu_mini_desc'],
                                  price: menusFiltered[index]['menu_price'],
                                  image: menusFiltered[index]['menu_image'],
                                  data: menusFiltered[index],
                                  update: update,
                                ),
                              ],
                            );
                          })
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: menus == null ? 0 : menus.length,
                          itemBuilder: (BuildContext context, int index) {
                            var menuCats =
                                json.decode(menus[index]['category_id']);
                            var flag = false;

                            if (catId != 0) {
                              menuCats.forEach((k, v) {
                                if (v == catId) flag = true;
                              });

                              if (!flag) return Column();
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                MenuItem(
                                  name: menus[index]['menu_name'],
                                  desc: menus[index]['menu_desc'],
                                  miniDesc: menus[index]['menu_mini_desc'],
                                  price: menus[index]['menu_price'],
                                  image: menus[index]['menu_image'],
                                  data: menus[index],
                                  update: update,
                                ),
                              ],
                            );
                          }),
                )
              ],
            )
          ],
        ));
  }
}
