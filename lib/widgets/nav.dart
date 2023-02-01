import 'package:ecorn/styles/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:ecorn/screens/info_screen.dart';
import 'package:ecorn/screens/menu_screen.dart';
import 'package:ecorn/screens/profile_screen.dart';
import 'package:ecorn/screens/reviews_screen.dart';
import 'package:ecorn/screens/cart_screen.dart';
import 'package:ecorn/screens/splash_screen.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFF00633E),
        child: ListView(
          children: <Widget>[
            Container(
              height: 150.0,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF00633E),
                  image: DecorationImage(
                    alignment: Alignment.center,
                    fit: BoxFit.fitHeight,
                    image: AssetImage(
                      'images/logo_p.png',
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.restaurant_menu,
                color: Colors.white,
              ),
              title: Text(
                'Меню',
                style: navTextStyle,
              ),
              onTap: () => {
                Navigator.of(context).popAndPushNamed(MenuScreen.routeName)
              },
            ),
            ListTile(
              leading: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              title: Text(
                'Профиль',
                style: navTextStyle,
              ),
              onTap: () => {
                Navigator.of(context).popAndPushNamed(ProfileScreen.routeName)
              },
            ),
            ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.white,
              ),
              title: Text(
                'О нас',
                style: navTextStyle,
              ),
              onTap: () {
                Navigator.of(context).popAndPushNamed(InfoScreen.routeName);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.mail_outline,
                color: Colors.white,
              ),
              title: Text(
                'Обратная связь',
                style: navTextStyle,
              ),
              onTap: () => {
                Navigator.of(context).popAndPushNamed(ReviewsScreen.routeName)
              },
            ),
          ],
        ),
      ),
    );
  }
}
