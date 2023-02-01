import 'package:flutter/material.dart';
import 'package:ecorn/styles/font_styles.dart';

Divider divider = Divider(
  thickness: 3,
  color: Color(0xFF00633E),
  indent: 150,
  endIndent: 150,
);

class MarketPoint extends StatelessWidget {
/*  MenuCat({this.label, this.image, this.subtitleLabel, this.data});

  final String label;
  final String image;
  final String subtitleLabel;
  final Map data;*/

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 146.0,
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF00633E)),
        borderRadius: BorderRadius.circular(30),
        color: Color(0xFF000000),
        image: DecorationImage(
          image: NetworkImage(
              "https://i.pinimg.com/originals/cc/66/71/cc66718767b3ee5dac90a2d6ca65af22.jpg"),
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
          child: Text("Категория", style: catMenuTitleTextStyle),
        ),
      ),
    );
  }
}
