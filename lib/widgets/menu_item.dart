import 'package:auto_size_text/auto_size_text.dart';
import 'package:ecorn/bloc/counter_menu_item/counter_cubit.dart';
import 'package:ecorn/screens/menu_item_info.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:ecorn/globals.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuItem extends StatelessWidget {
  MenuItem({
    this.name,
    this.desc,
    this.price,
    this.miniDesc,
    this.image,
    this.data,
    this.update,
  });

  final String name;
  final String desc;
  final String price;
  final String miniDesc;
  final String image;
  final Map data;
  final Function update;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => BlocProvider(
                  create: (_) => CounterCubit(),
                  child: MenuItemInfo(data: data, update: update))),
        );
      },
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  height: 130.0,
                  width: 130.0,
                  margin: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xFF000000),
                    image: DecorationImage(
                      image: NetworkImage(
                          API_URL + json.decode(image)[0]['little']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: AutoSizeText(
                            json.decode(name)[LANG],
                            maxLines: 2,
                            minFontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            wrapWords: false,
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Rubik',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: AutoSizeText(
                          json.decode(miniDesc)[LANG],
                          maxLines: 4,
                          minFontSize: 14,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Rubik',
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, top: 30),
                          child: AutoSizeText(
                            price + 'cум',
                            maxLines: 1,
                            minFontSize: 0,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Rubik',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
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
      ),
    );
  }
}
