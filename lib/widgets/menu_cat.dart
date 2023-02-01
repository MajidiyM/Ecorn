import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ecorn/styles/font_styles.dart';
import 'dart:convert';

class MenuCat extends StatelessWidget {
  MenuCat({this.name, this.image});

  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: MediaQuery.of(context).size.height / 5,
        width: MediaQuery.of(context).size.height / 5,
        margin: EdgeInsets.all(15.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF00633E)),
          borderRadius: BorderRadius.circular(150),
          color: Colors.black87,
          image: DecorationImage(
            image: NetworkImage(
                'https://ecorn-app.uz/' + json.decode(image)[0]['big']),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.dstATop),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF999999),
              blurRadius: 10.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the shadow
              offset: Offset(
                5.0, // horizontal, move right 10
                5.0, // vertical, move down 10
              ),
            )
          ],
        ),
        child: Center(
          child: Container(
            child: AutoSizeText(json.decode(name)['ru'],
                style: catMenuTitleTextStyle,
                textAlign: TextAlign.center,
                maxLines: 2,
                minFontSize: 0,
                wrapWords: false),
          ),
        ),
      ),
    );
  }
}
