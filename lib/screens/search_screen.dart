import 'package:flutter/material.dart';
import 'package:ecorn/widgets/menu_item.dart';

class SearchScreen extends StatefulWidget {
  static final routeName = "searchScreen";

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          style: TextStyle(
              fontSize: 20.0, fontFamily: 'Rubik', color: Colors.white),
          decoration: InputDecoration(
            hintText: "Поиск",
            hintStyle: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Rubik',
                color: Colors.white.withOpacity(.5)),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              MenuItem(),
              MenuItem(),
              MenuItem(),
              MenuItem(),
              MenuItem(),
              MenuItem(),
              MenuItem(),
            ],
          )
        ],
      ),
    );
  }
}
