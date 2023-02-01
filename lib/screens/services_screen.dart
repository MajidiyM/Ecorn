import 'package:ecorn/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecorn/widgets/nav.dart';

class ServicesScreen extends StatefulWidget {
  static final routeName = "servicesScreen";

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Услуги',
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Rubik',
            ),
          ),
          bottom: _tabView(),
        ),
        drawer: NavDrawer(),
        body: _tabViewDesign(context),
      ),
    );
  }

//TabBar
  Widget _tabView() {
    return TabBar(
      tabs: [
        Tab(
          text: 'Забронировать',
        ),
        Tab(
          text: 'Доставка',
        ),
      ],
    );
  }

//TabBarView
  Widget _tabViewDesign(context) {
    return TabBarView(
      children: [
        Container(
          child: Center(
            child: Text(
              'Забронировать столик',
              style: TextStyle(
                  color: Colors.black45, fontSize: 35, fontFamily: 'Rubik'),
            ),
          ),
        ),
        Container(
          child: Center(
            child: Text(
              'Доставка',
              style: TextStyle(
                  color: Colors.black45, fontSize: 35, fontFamily: 'Rubik'),
            ),
          ),
        ),
      ],
    );
  }
}
