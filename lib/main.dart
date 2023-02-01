import 'package:bloc/bloc.dart';
import 'package:ecorn/bloc/counter_menu_item/counter_observer.dart';
import 'package:ecorn/screens/cart_screen.dart';
import 'package:ecorn/screens/maps_for_order_screen.dart';
import 'package:ecorn/screens/order_Info.dart';
import 'package:ecorn/screens/info_screen.dart';
import 'package:ecorn/screens/menu_item_info.dart';
import 'package:ecorn/screens/order_history_screen.dart';
import 'package:ecorn/screens/search_screen.dart';
import 'package:ecorn/screens/splash_screen.dart';
import 'package:ecorn/screens/profile_screen.dart';
import 'package:ecorn/screens/reviews_screen.dart';
import 'package:ecorn/screens/services_screen.dart';
import 'package:ecorn/screens/sing_up_screen.dart';
import 'screens/menu_screen.dart';
import 'package:flutter/material.dart';

void main() {
  Bloc.observer = CounterObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: Color(0xFF00633E), //AppBar
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
        canvasColor: Color(0xFFFFFFFF),
        //backgroundColor
      ),
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        MenuScreen.routeName: (context) => MenuScreen(),
        SearchScreen.routeName: (context) => SearchScreen(),
        InfoScreen.routeName: (context) => InfoScreen(),
        ProfileScreen.routeName: (context) => ProfileScreen(),
        ReviewsScreen.routeName: (context) => ReviewsScreen(),
        ServicesScreen.routeName: (context) => ServicesScreen(),
        SignInScreen.routeName: (context) => SignInScreen(),
        CartScreen.routeName: (context) => CartScreen(),
        MenuItemInfo.routeName: (context) => MenuItemInfo(),
        OrderInfo.routeName: (context) => OrderInfo(),
        MapsOrder.routeName: (context) => MapsOrder(),
        OrderHistory.routeName: (context) => OrderHistory(),
      },
      initialRoute: SplashScreen.routeName,
    );
  }
}
