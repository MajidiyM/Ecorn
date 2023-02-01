import 'package:ecorn/styles/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:ecorn/globals.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderHistory extends StatefulWidget {
  static final routeName = "orderHistory";

  OrderHistory({this.order});

  final Map order;

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map order;
  List<dynamic> menus;
  bool _progressController = true;

  Future<String> getData() async {
    http.Response menusResponse = await http.get(
      API_URL + '/api/admin/v1/orders/' + order['order_id'].toString(),
      headers: {'Client': CLIENT},
    );

    http.Response orderResponse = await http.get(
      API_URL + '/api/admin/v1/orders?order_id=' + order['order_id'].toString(),
      headers: {'Client': CLIENT},
    );

    this.setState(() {
      menus = json.decode(menusResponse.body)['data'];
      order = json.decode(orderResponse.body)['data']['recs'][0];
      _progressController = false;
    });
  }

  @override
  void initState() {
    order = widget.order;
    super.initState();

    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: AutoSizeText(
          'Информация Заказа',
          style: kTitleAppBar,
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: getData,
          child: Container(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Column(
                        children: [
                          //Остальные данные(такие как Филиал,Адрес и т.д)
                          Container(
                            margin:
                                EdgeInsets.only(top: 10, right: 10, left: 10),
                            decoration: BoxDecoration(
                              color: Color(0xFFf5f5f5),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              children: [
                                //Номер Заказа
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 7.0, top: 2),
                                      child: AutoSizeText(
                                        'Номер Заказа: ',
                                        style: kStyleNameProp,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 7),
                                      child: SelectableText(
                                        order['order_id'].toString(),
                                        style: kStyleNamePropText,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Clipboard.setData(
                                          new ClipboardData(
                                            text: order['order_id'].toString(),
                                          ),
                                        );
                                        _scaffoldKey.currentState.showSnackBar(
                                          new SnackBar(
                                            content: AutoSizeText(
                                              "Скопировано в буфер обмена",
                                              style: kStyleNamePropText,
                                            ),
                                            duration:
                                                Duration(milliseconds: 500),
                                          ),
                                        );
                                      },
                                      child: FaIcon(
                                        FontAwesomeIcons.copy,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                //Время
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 7.0, top: 2),
                                        child: AutoSizeText(
                                          'Время',
                                          style: kStyleNameProp,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 7.0, top: 2),
                                        child: AutoSizeText(
                                          order['created_at'],
                                          maxLines: 1,
                                          minFontSize: 0,
                                          overflow: TextOverflow.ellipsis,
                                          style: kStyleNamePropText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //Статус заказа
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 7.0, top: 2),
                                        child: AutoSizeText(
                                          'Статус Заказа',
                                          maxLines: 1,
                                          minFontSize: 0,
                                          overflow: TextOverflow.ellipsis,
                                          style: kStyleNameProp,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 7.0, top: 2),
                                        child: AutoSizeText(
                                          ORDER_STATUS[int.parse(
                                              order['order_status'])]['name'],
                                          maxLines: 1,
                                          minFontSize: 0,
                                          overflow: TextOverflow.ellipsis,
                                          style: kStyleNamePropText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //Статус Оплаты
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 7.0, top: 2),
                                        child: AutoSizeText(
                                          'Статус Оплаты',
                                          maxLines: 1,
                                          minFontSize: 0,
                                          overflow: TextOverflow.ellipsis,
                                          style: kStyleNameProp,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 7.0, top: 2),
                                        child: AutoSizeText(
                                          PAYMENT_STATUS[int.parse(order[
                                                  'order_payment_status']) -
                                              1]['name'],
                                          maxLines: 1,
                                          minFontSize: 0,
                                          overflow: TextOverflow.ellipsis,
                                          style: kStyleNamePropText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //Филиал
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 7.0, top: 2),
                                        child: AutoSizeText(
                                          'Филиал',
                                          maxLines: 1,
                                          minFontSize: 0,
                                          overflow: TextOverflow.ellipsis,
                                          style: kStyleNameProp,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 7.0, top: 2),
                                        child: AutoSizeText(
                                          POINTS[int.parse(order['point_id'])]
                                              ['name'],
                                          maxLines: 1,
                                          minFontSize: 0,
                                          overflow: TextOverflow.ellipsis,
                                          style: kStyleNamePropText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //Вид Доставки
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 7.0, top: 2),
                                        child: AutoSizeText(
                                          'Вид Доставки',
                                          maxLines: 1,
                                          minFontSize: 0,
                                          overflow: TextOverflow.ellipsis,
                                          style: kStyleNameProp,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 7.0, top: 2),
                                        child: AutoSizeText(
                                          ORDER_TYPE[int.parse(
                                                  order['order_delivery_type'])]
                                              ['name'],
                                          maxLines: 1,
                                          minFontSize: 0,
                                          overflow: TextOverflow.ellipsis,
                                          style: kStyleNamePropText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //Вид Оплаты
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 7.0, top: 2),
                                        child: AutoSizeText(
                                          'Способ Оплаты',
                                          maxLines: 1,
                                          minFontSize: 0,
                                          overflow: TextOverflow.ellipsis,
                                          style: kStyleNameProp,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 7.0, top: 2),
                                        child: AutoSizeText(
                                          PAYMENT_TYPE[int.parse(
                                                  order['order_payment_type'])]
                                              ['name'],
                                          maxLines: 1,
                                          minFontSize: 0,
                                          overflow: TextOverflow.ellipsis,
                                          style: kStyleNamePropText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //Адрес
                                order['order_delivery_type'] == '1'
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 7.0, top: 2),
                                            child: AutoSizeText(
                                              'Адрес',
                                              maxLines: 1,
                                              minFontSize: 0,
                                              overflow: TextOverflow.ellipsis,
                                              style: kStyleNameProp,
                                            ),
                                          ),
//                                      SizedBox(width: 119),
                                          Flexible(
                                            flex: 3,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 7.0, top: 2),
                                              child: AutoSizeText(
                                                order['order_address'] ?? '',
                                                maxLines: 1,
                                                minFontSize: 0,
                                                overflow: TextOverflow.ellipsis,
                                                style: kStyleNamePropText,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                                //Комментарий
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 7.0, top: 2),
                                        child: AutoSizeText(
                                          'Комментарий',
                                          maxLines: 1,
                                          minFontSize: 0,
                                          overflow: TextOverflow.ellipsis,
                                          style: kStyleNameProp,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 7.0, top: 2),
                                        child: AutoSizeText(
                                          order['order_comment'] ?? "",
                                          maxLines: 1,
                                          minFontSize: 0,
                                          overflow: TextOverflow.ellipsis,
                                          style: kStyleNamePropText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          //Список Блюд
                          Container(
                            child: _progressController
                                ? CircularProgressIndicator()
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: menus == null ? 0 : menus.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Row(
                                          children: [
                                            //Фотография Блюда
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5),
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                image: DecorationImage(
                                                    image: NetworkImage(API_URL +
                                                        json.decode(menus[index]
                                                                ['menu_image'])[
                                                            0]['little']),
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                            SizedBox(width: 15),
                                            //Блюдо
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: AutoSizeText(
                                                      json.decode(menus[index]
                                                          ['menu_name'])[LANG],
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontFamily: 'Rubik',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: AutoSizeText(
                                                      menus[index]['menu_price']
                                                              .toString() +
                                                          ' x ' +
                                                          menus[index]['count']
                                                              .toString(),
                                                      style: TextStyle(
                                                        fontFamily: 'Rubik',
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 0.8,
                  color: Colors.black45,
                  endIndent: 90,
                  indent: 90,
                ),
                Stack(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: AutoSizeText(
                                    'Сумма заказа',
                                    maxLines: 1,
                                    minFontSize: 0,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 23,
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: order['order_delivery_type'] == '1'
                                      ? AutoSizeText(
                                          (int.parse(order['order_price']) -
                                                      int.parse(order[
                                                          'order_delivery_price']))
                                                  .toString() +
                                              ' сум',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontSize: 23,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          minFontSize: 0,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : AutoSizeText(
                                          (int.parse(order['order_price']))
                                                  .toString() +
                                              ' сум',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontSize: 23,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          minFontSize: 0,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          order['order_delivery_type'] == '1'
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: AutoSizeText(
                                          'Доставка',
                                          maxLines: 1,
                                          minFontSize: 0,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontSize: 23,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: AutoSizeText(
                                          order['order_delivery_price']
                                                  .toString() +
                                              ' сум',
                                          maxLines: 1,
                                          minFontSize: 0,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontSize: 23,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: AutoSizeText(
                                      'Всего',
                                      maxLines: 1,
                                      minFontSize: 0,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 23,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: AutoSizeText(
                                      order['order_price'] + ' сум',
                                      maxLines: 1,
                                      minFontSize: 0,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 23,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          order['order_payment_type'] == '2'
                              ? FractionallySizedBox(
                                  widthFactor: 1,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: new AutoSizeText(
                                        "Оплатить",
                                        style: kTextStyleButton,
                                        maxLines: 1,
                                        minFontSize: 0,
                                      ),
                                      colorBrightness: Brightness.dark,
                                      onPressed: () async {
                                        String url =
                                            "m=5f21199f669fbc8013a9c5f2;ac.order_id=" +
                                                order['order_id'].toString() +
                                                ";a=" +
                                                order['order_price']
                                                    .toString() +
                                                "00";
                                        List encodedText = utf8.encode(url);
                                        String base64Str =
                                            base64.encode(encodedText);

                                        await launch(
                                            "https://checkout.paycom.uz/" +
                                                base64Str);
                                      },
                                      color: Color(0xFF00633E),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
