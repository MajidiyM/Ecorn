import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecorn/styles/font_styles.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'maps_for_order_screen.dart';
import 'package:localstorage/localstorage.dart';
import 'profile_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ecorn/globals.dart';

class OrderInfo extends StatefulWidget {
  static final routeName = "checkOrderInfoScreen";

  OrderInfo({this.data, this.price});
  final String price;
  final Map data;

  @override
  _OrderInfoState createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final LocalStorage storage = new LocalStorage('auth');

  var coordinates;

  String dropdownOrder;
  String dropdownPayment;
  String dropdownPlace;
  bool _progressController = true;

  Map data;
  String price;

  var checkEnabled = true;

  @override
  TextEditingController controllerForAddress = TextEditingController();
  TextEditingController controllerForC = TextEditingController();
  final _sendKey = GlobalKey<FormState>();

  Future<String> getData() async {
    List<dynamic> delivery;

    Response deliveryResponse =
        await get(API_URL + '/api/admin/v1/translations');
    delivery = json.decode(deliveryResponse.body)['data']['recs'];

    setState(() {
      delivery.forEach((element) {
        if (element['translation_code'] == 'delivery') {
          print(element['translation_translations']);
          orderPrice = int.parse(element['translation_translations']);
        }
      });
      _progressController = false;
    });
  }

  @override
  void initState() {
    totalSum = totalPrice;

    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Информация по Доставке',
          style: kTitleAppBar,
        ),
      ),
      body: _progressController
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.only(top: 10.0),
              child: Form(
                key: _sendKey,
                child: Column(
                  children: [
                    Flexible(
                      child: ListView(
                        children: [
                          //Google Maps
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextField(
                              enabled: checkEnabled,
                              readOnly: true,
                              onTap: () async {
                                var result = await Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MapsOrder(),
                                  ),
                                );
                                controllerForAddress.text = result['address'];
                                coordinates = result['coordinates'];
                              },
                              style: kTextFieldStyle,
                              showCursor: false,
                              textCapitalization: TextCapitalization.sentences,
                              controller: controllerForAddress,
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  child: Icon(
                                    Icons.room,
                                    size: 30.0,
                                  ),
                                ),
                                border: OutlineInputBorder(),
                                hintText: 'Адрес',
                              ),
                            ),
                          ),
                          //Comment TextField
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            margin: EdgeInsets.only(top: 20.0),
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.done,
                              controller: controllerForC,
                              style: kTextFieldStyle,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: 'Комментарии к заказу',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          //Методы Оплаты,Метод Доставки,Филиал
                          Container(
                            margin:
                                EdgeInsets.only(right: 3.5, left: 3.5, top: 25),
                            child: Column(
                              children: [
                                //Доставка
                                Container(
                                  width: MediaQuery.of(context).size.width - 40,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFf5f5f5),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      enabledBorder: InputBorder.none,
                                    ),
                                    hint: AutoSizeText('Вид Доставки'),
                                    value: dropdownOrder,
                                    icon: FaIcon(FontAwesomeIcons.angleDown),
                                    elevation: 24,
                                    onChanged: (String newValue) async {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      _sendKey.currentState.validate();
                                      if (newValue == '1')
                                        totalSum = totalPrice + orderPrice;
                                      else
                                        totalSum = totalPrice;
                                      setState(() {
                                        dropdownOrder = newValue;
                                      });
                                      if (newValue == '1') {
                                        _orderInfo(context);
                                      }
                                    },
                                    validator: (value) => value == null
                                        ? 'Выберите метод доставки'
                                        : null,
                                    items: <Map>[
                                      {'id': '1', 'name': 'Доставка'},
                                      {'id': '2', 'name': 'Самовывоз'},
                                    ].map<DropdownMenuItem<String>>(
                                        (Map value) {
                                      return DropdownMenuItem<String>(
                                        value: value['id'],
                                        child: AutoSizeText(
                                          value['name'],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(height: 20),
                                //Оплата
                                Container(
                                  width: MediaQuery.of(context).size.width - 40,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFf5f5f5),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: DropdownButtonFormField<String>(
                                    validator: (value) => value == null
                                        ? 'Выберите метод оплаты'
                                        : null,
                                    decoration: InputDecoration(
                                      enabledBorder: InputBorder.none,
                                    ),
                                    hint: AutoSizeText('Вид Оплаты'),
                                    value: dropdownPayment,
                                    icon: FaIcon(FontAwesomeIcons.angleDown),
                                    elevation: 24,
                                    onChanged: (String newValue) async {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      _sendKey.currentState.validate();
                                      setState(() {
                                        dropdownPayment = newValue;
                                      });
                                    },
                                    items: <Map>[
                                      {'id': '1', 'name': 'Наличные'},
                                      {'id': '2', 'name': 'PayMe'},
//                                {'id': '3', 'name': 'Click'},
                                    ].map<DropdownMenuItem<String>>(
                                        (Map value) {
                                      return DropdownMenuItem<String>(
                                        value: value['id'],
                                        child: AutoSizeText(
                                          value['name'],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(height: 20),
                                //Филиал
                                Container(
                                  width: MediaQuery.of(context).size.width - 40,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFf5f5f5),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: DropdownButtonFormField<String>(
                                    validator: (value) => value == null
                                        ? 'Выберите Филиал'
                                        : null,
                                    value: dropdownPlace,
                                    hint: AutoSizeText('Выберите филиал'),
                                    icon: FaIcon(FontAwesomeIcons.angleDown),
                                    decoration: InputDecoration(
                                      enabledBorder: InputBorder.none,
                                    ),
                                    elevation: 24,
                                    onChanged: (String newValue) {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      _sendKey.currentState.validate();
                                      setState(() {
                                        dropdownPlace = newValue;
                                      });
                                    },
                                    items: <Map>[
                                      {
                                        'id': '1',
                                        'name': 'Ecorn Ц1',
                                      },
                                      {
                                        'id': '2',
                                        'name': 'Ecorn на Мирабадской'
                                      },
                                      {
                                        'id': '3',
                                        'name': 'Ecorn на Чимкентской'
                                      },
                                    ].map<DropdownMenuItem<String>>(
                                        (Map value) {
                                      return DropdownMenuItem<String>(
                                        value: value['id'],
                                        child: AutoSizeText(
                                          value['name'],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 3,
                      color: Colors.black45,
                      endIndent: 90,
                      indent: 90,
                    ),
                    Column(
                      children: [
                        dropdownOrder == '1'
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: AutoSizeText(
                                        'Доставка:',
                                        style: kPriceContainer,
                                        maxLines: 1,
                                        minFontSize: 0,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      child: AutoSizeText(
                                        orderPrice.toString(),
                                        style: kPriceContainer,
                                        maxLines: 1,
                                        minFontSize: 0,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.only(left: 15.0),
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
                                padding: EdgeInsets.only(right: 15.0),
                                child: AutoSizeText(
                                  totalSum.toString(),
                                  style: kPriceContainer,
                                  maxLines: 1,
                                  minFontSize: 0,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    //NextButton
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        widthFactor: 0.90,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          height: 70.0,
                          padding: EdgeInsets.only(top: 10.0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              "Отправить",
                              style: kTextStyleButton,
                            ),
                            colorBrightness: Brightness.dark,
                            onPressed: () async {
                              if (!_sendKey.currentState.validate()) {
                                return;
                              }

                              var order_lat = null;
                              var order_lon = null;

                              var user = storage.getItem('user'),
                                  order_items = List();
                              if (user == null) {
                                Navigator.of(context)
                                    .popAndPushNamed(ProfileScreen.routeName);
                                return;
                              }

                              order_items.clear();
                              CART.forEach((element) {
                                order_items.add({
                                  'menu_id': element['menu_id'],
                                  'count': element['count'],
                                });
                              });

                              if (dropdownOrder == '1') {
                                if (coordinates == null) {
                                  print(coordinates);
                                  dialogError(context, 'Укажите адрес');
                                  return;
                                }
                                order_lat = coordinates[0];
                                order_lon = coordinates[1];
                              } else {
                                order_lat = null;
                                order_lon = null;
                              }

                              dialog(context, 'Спасибо за заказ!',
                                  'Ожидайте звонок оператора');

                              final http.Response response = await http.post(
                                API_URL + '/api/admin/v1/orders',
                                headers: <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  'Client': CLIENT,
                                },
                                body: json.encode(<String, dynamic>{
                                  'point_id': dropdownPlace ?? 1,
                                  'user_id': user['user_id'],
                                  'order_items': jsonEncode(order_items),
                                  'order_phone': user['user_phone'],
                                  'order_lat': order_lat,
                                  'order_lon': order_lon,
                                  'order_delivery_type': dropdownOrder ?? 2,
                                  'order_payment_type': dropdownPayment ?? 1,
                                  'order_comment': controllerForC.text,
                                  'order_address': controllerForAddress.text,
                                  'order_status': 1,
                                  'order_payment_status': 2,
                                  'order_price': totalSum,
                                  'order_delivery_price': orderPrice,
                                }),
                              );

                              if (json.decode(response.body)['success']) {
                                CART.clear();
                              } else {
                                switch (json.decode(response.body)['data']) {
                                  case 1:
                                    break;
                                }
                              }
                            },
                            color: Color(0xFF00633E),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

_orderInfo(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Center(child: Text('Информация по доставке')),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, state) {
          return Container(
            height: MediaQuery.of(context).size.height / 6,
            child: Column(children: [
              Center(
                child: Text(
                  'Доставка осуществляется по тарифу Taxi Millennium',
                  style: TextStyle(fontSize: 18),
                ),
              )
            ]),
          );
        },
      ),
    ),
  );
}

// Модалка ошибки
dialog(BuildContext context, text, content) {
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          text,
          style: TextStyle(
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w400,
          ),
        ),
        content: Text(
          content,
          style: TextStyle(
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          FlatButton(
            child: Text(
              'Ок',
              style: TextStyle(
//                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
            onPressed: () {
              Navigator.of(context).popAndPushNamed(ProfileScreen.routeName);
            },
          )
        ],
      );
    },
  );
}
