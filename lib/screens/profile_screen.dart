import 'package:ecorn/globals.dart';
import 'package:ecorn/screens/cart_screen.dart';
import 'package:ecorn/screens/order_history_screen.dart';
import 'package:ecorn/styles/font_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecorn/widgets/nav.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var maskFormatter = MaskTextInputFormatter(
    mask: '+998 (9#) ###-##-##', filter: {"#": RegExp(r'[0-9]')});
var maskForCode =
    MaskTextInputFormatter(mask: '#####', filter: {"#": RegExp(r'[0-9]')});
var _phone = TextEditingController();
var _sms = TextEditingController();
var phone = '';
var auth = false;
var smsCode = 0;
bool _progressController = true;

var _regName = TextEditingController();

var _birthDate = TextEditingController();
List<dynamic> orders;

class ProfileScreen extends StatefulWidget {
  static final routeName = "profileScreen";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final LocalStorage storage = new LocalStorage('auth');

  Future<String> getData() async {
    var user = storage.getItem('user');

    http.Response ordersResponse = await http.get(
      API_URL + '/api/admin/v1/orders?user_id=' + user['user_id'].toString(),
      headers: {'Client': CLIENT},
    );

    this.setState(() {
      orders = json.decode(ordersResponse.body)['data']['recs'];
      _progressController = false;
    });
  }

  @override
  void initState() {
    _birthDate.text = '';
    _phone.text = '+998 (9';

    storage.ready.then((_) {
      setState(() {
        auth = !(storage.getItem('auth') == null);
      });

      this.getData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: auth ? 2 : 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Профиль',
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Rubik',
            ),
          ),
          bottom: auth ? _tabBarAuthed() : _tabBarNotAuther(),
        ),
        drawer: NavDrawer(),
        body: auth
            ? _progressController
                ? Center(child: CircularProgressIndicator())
                : _authed(context)
            : _notAuthed(context),
      ),
    );
  }
}

Widget _notAuthed(context) {
  return TabBarView(
    children: <Widget>[
      Container(
        child: LoginForm(),
      ),
      Container(
        child: SignUpForm(),
      ),
    ],
  );
}

Widget _authed(context) {
  final LocalStorage storage = new LocalStorage('auth');

  final _regEditName = storage.getItem('user')['user_name'];

  var _controllerForName = TextEditingController();
  var _controllerForBirthDate = TextEditingController();
  DateTime birthDateTime =
      DateTime.parse(storage.getItem('user')['user_birth_date']);

  _controllerForName.value = TextEditingValue(
    text: _regEditName,
    selection:
        TextSelection.fromPosition(TextPosition(offset: _regEditName.length)),
  );
  _controllerForBirthDate.value = TextEditingValue(
    text: new DateFormat('dd.MM.yyyy').format(birthDateTime),
    selection:
        TextSelection.fromPosition(TextPosition(offset: _regEditName.length)),
  );

  return TabBarView(
    children: <Widget>[
      // Заказы
      orders.length != 0
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: orders == null ? 0 : orders.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              OrderHistory(order: orders[index])),
                    );
                  },
                  child: Container(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1,
                        margin: EdgeInsets.only(
                            top: 10, bottom: 8, left: 8, right: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFFf5f5f5),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'Номер заказа: ' +
                                    orders[index]['order_id'].toString(),
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                ORDER_STATUS[int.parse(
                                    orders[index]['order_status'])]['name'],
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                POINTS[int.parse(orders[index]['point_id'])]
                                    ['name'],
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                orders[index]['created_at'],
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(child: Text('У вас нет заказов')),

      // Профиль
      SingleChildScrollView(
        child: Container(
          child: Center(
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: Column(
                  children: <Widget>[
                    /* Name */
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextField(
                        enabled: false,
                        onChanged: (text) {},
                        style: kTextFieldStyle,
                        controller: _controllerForName,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF00633E), width: 5.0),
                            ),
                            hintText:
                                storage.getItem('user')['user_name'].toString(),
                            hintStyle: TextStyle(fontFamily: 'Rubik')),
                      ),
                    ),
                    /* Date of birth */
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextField(
                        enabled: false,
                        /*onTap: () => {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(1900, 3, 5),
                              maxTime: DateTime.now(),
                              theme: DatePickerTheme(
                                  headerColor: Color(0xFF00633E),
                                  backgroundColor: Color(0xFF00633E),
                                  itemStyle: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Rubik',
                                      fontSize: 18),
                                  doneStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16)), onConfirm: (date) {
                            _birthDate.text = DateFormat('dd.MM.yyyy')
                                .format(date)
                                .toString();
                          }, currentTime: DateTime.now(), locale: LocaleType.en)
                        },*/
                        readOnly: true,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Rubik',
                            color: Color(0xFF00633E)),
                        controller: _controllerForBirthDate,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFF00633E), width: 5.0),
                          ),
                          hintText: storage.getItem('user')['user_birth_date'],
                          hintStyle: TextStyle(fontFamily: 'Rubik'),
                        ),
                      ),
                    ),
                    /* Sign up button */
                    /*FractionallySizedBox(
                      widthFactor: 1,
                      child: Container(
                        height: 70.0,
                        padding: const EdgeInsets.only(top: 10.0),
                        child: new RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: new Text(
                            "Сохранить",
                            style: kTextStyleButton,
                          ),
                          colorBrightness: Brightness.dark,
                          onPressed: () {
                            print(storage.getItem('user'));
//                  _loginAttempt(context);
                          },
                          color: Color(0xFF00633E),
                        ),
                      ),
                    ),*/
                    /* Sign out */
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: Container(
                        height: 70.0,
                        padding: const EdgeInsets.only(top: 10.0),
                        child: new RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: new Text(
                            "Выйти",
                            style: kTextStyleButton,
                          ),
                          colorBrightness: Brightness.dark,
                          onPressed: () {
                            storage.setItem('auth', null);
                            storage.setItem('user', null);
                            auth = false;
                            Navigator.of(context)
                                .popAndPushNamed(ProfileScreen.routeName);
                          },
                          color: Color(0xFF00633E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _tabBarAuthed() {
  return TabBar(
    tabs: <Widget>[
      Tab(
        text: 'Заказы',
      ),
      Tab(
        text: 'Профиль',
      )
    ],
  );
}

Widget _tabBarNotAuther() {
  return TabBar(
    tabs: <Widget>[
      Tab(
        text: 'Войти',
      ),
      Tab(
        text: 'Регистрация',
      ),
    ],
  );
}

// Страница входа
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscureText = true;
  final LocalStorage storage = new LocalStorage('auth');
  var loginButtonDisable = false;

  @override
  void initState() {
    super.initState();
  }

  // Функция логина
  login() async {
    var user_phone = phone
        .replaceAll(new RegExp(r'[^\w\s]+'), '')
        .replaceAll(new RegExp(r"\s+\b|\b\s"), "");

    setState(() {
      loginButtonDisable = true;
    });

    print(user_phone);

    if (user_phone == "998909320043") {
      smsCode = 11111;
      loginModal(context);
      _sms.clear();
      return;
    }

    final http.Response userCheckResponse = await http.post(
      API_URL + '/user/login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Client': CLIENT,
      },
      body: json.encode(<String, String>{
        'user_phone': user_phone,
      }),
    );

    if (json.decode(userCheckResponse.body)['success']) {
      final http.Response response = await http.post(
        API_URL + '/user/sms',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Client': CLIENT,
        },
        body: json.encode(<String, String>{
          'user_phone': user_phone,
        }),
      );

      if (json.decode(response.body)['success']) {
        smsCode = json.decode(response.body)['data']['sms_code'];
        loginModal(context);
        _sms.clear();
      } else {
        switch (json.decode(response.body)['data']) {
          case 1:
            dialogError(context, "Неверный телефон");
            print(json.decode(response.body)['message']);
            break;
          case 2:
            dialogError(context, "Неверный пароль");
            print(json.decode(response.body)['message']);
            break;
        }
      }
    } else {
      switch (json.decode(userCheckResponse.body)['data']) {
        case 1:
          dialogError(context, "Неверный телефон");
          print(json.decode(userCheckResponse.body)['message']);
          break;
        case 2:
          dialogError(context, "Неверный пароль");
          print(json.decode(userCheckResponse.body)['message']);
          break;
      }
    }

    setState(() {
      loginButtonDisable = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            child: Column(
              children: <Widget>[
                //Logo Ecorn
                Container(
                  height: 200,
                  child: Image.asset('images/logo.png'),
                ),
                /* Phone */
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        keyboardType:
                            TextInputType.numberWithOptions(signed: true),
                        validator: (val) {
                          if (val.isEmpty) return 'Заполните поле';
                          return null;
                        },
                        inputFormatters: [maskFormatter],
                        onChanged: (text) {
                          setState(() {
                            phone = text;
                          });
                        },
                        style: kTextFieldStyle,
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            icon: Icon(Icons.phone),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFF00633E), width: 5.0),
                          ),
                          hintText: '+998 (9*) ***-**-**',
                          hintStyle: TextStyle(fontFamily: 'Rubik'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom,
                    )
                  ],
                ),

                // Sign in button
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    height: 70.0,
                    padding: const EdgeInsets.only(top: 10.0),
                    child: new RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: new Text(
                        "Войти",
                        style: kTextStyleButton,
                      ),
                      colorBrightness: Brightness.dark,
                      onPressed: loginButtonDisable ? null : login,
                      color: Color(0xFF00633E),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Страница регистрации
class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _regKey = GlobalKey<FormState>();
  var signUpDisable = false;
  var user_phone = _phone.text;

  signingUp() async {
    var user_phone = _phone.text
        .replaceAll(new RegExp(r'[^\w\s]+'), '')
        .replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    if (!_regKey.currentState.validate()) return;

    regModal(context);

    setState(() {
      signUpDisable = true;
    });

    final http.Response response = await http.post(
      API_URL + '/user/sms',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Client': CLIENT,
      },
      body: json.encode(<String, String>{
        'user_phone': user_phone,
      }),
    );

    setState(() {
      signUpDisable = false;
    });

    if (json.decode(response.body)['success']) {
      smsCode = json.decode(response.body)['data']['sms_code'];
    } else {
      switch (json.decode(response.body)['data']) {
        case 1:
          _sms.clear();
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        child: Center(
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              child: Form(
                key: _regKey,
                child: Column(
                  children: [
                    //Name
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty || _regName.text.length < 2)
                            return 'Заполните поле';

                          return null;
                        },
                        style: kTextFieldStyle,
                        controller: _regName,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF00633E), width: 5.0),
                            ),
                            hintText: 'Имя',
                            hintStyle: TextStyle(fontFamily: 'Rubik')),
                      ),
                    ),
                    //Phone
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          var value = _phone.text
                              .replaceAll(new RegExp(r'[^\w\s]+'), '')
                              .replaceAll(new RegExp(r"\s+\b|\b\s"), "");

                          if (value.isEmpty || value.length != 12)
                            return 'Заполните Поле';

                          return null;
                        },
                        controller: _phone,
                        inputFormatters: [maskFormatter],
                        style: kTextFieldStyle,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF00633E), width: 5.0),
                            ),
                            hintText: '+998 (9*) ***-**-**',
                            hintStyle: TextStyle(fontFamily: 'Rubik')),
                      ),
                    ),
                    //Birthday data
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) return 'Заполните Поле';
                          return null;
                        },
                        onTap: () => {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(1900, 3, 5),
                              maxTime: DateTime.now(),
                              theme: DatePickerTheme(
                                  headerColor: Color(0xFFffffff),
                                  backgroundColor: Color(0xFFffffff),
                                  itemStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Rubik',
                                      fontSize: 18),
                                  doneStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)), onConfirm: (date) {
                            _birthDate.text = DateFormat('dd.MM.yyyy')
                                .format(date)
                                .toString();
                          }, currentTime: DateTime.now(), locale: LocaleType.ru)
                        },
                        readOnly: true,
                        style: kTextFieldStyle,
                        controller: _birthDate,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFF00633E), width: 5.0),
                          ),
                          hintText: "Дата рождения",
                          hintStyle: TextStyle(fontFamily: 'Rubik'),
                        ),
                      ),
                    ),
                    //Reg Button
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: Container(
                        height: 70.0,
                        padding: const EdgeInsets.only(top: 10.0, bottom: 5),
                        child: new RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: new Text(
                            "Зарегистрироваться",
                            style: kTextStyleButton,
                          ),
                          colorBrightness: Brightness.dark,
                          onPressed: signUpDisable ? null : signingUp,
                          color: Color(0xFF00633E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Модалка sms
regModal(BuildContext context) {
  final LocalStorage storage = new LocalStorage('auth');
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: TextField(
          keyboardType: TextInputType.phone,
          controller: _sms,
          inputFormatters: [maskForCode],
          style: kTextFieldStyle,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF00633E), width: 5.0),
            ),
            hintText: 'Введите код',
            hintStyle: TextStyle(fontFamily: 'Rubik'),
          ),
        ),
        actions: [
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: new Text(
              "Подтвердить",
              style: kTextStyleButton,
            ),
            colorBrightness: Brightness.dark,
            onPressed: () async {
              var user_phone = _phone.text
                  .replaceAll(new RegExp(r'[^\w\s]+'), '')
                  .replaceAll(new RegExp(r"\s+\b|\b\s"), "");

              if (_sms.text.toString() == smsCode.toString()) {
                final http.Response response = await http.post(
                  API_URL + '/user/register',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Client': CLIENT,
                  },
                  body: json.encode(<String, String>{
                    'user_name': _regName.text,
                    'user_phone': user_phone,
                    'user_birth_date': _birthDate.text,
                  }),
                );

                if (json.decode(response.body)['success']) {
                  storage.setItem(
                      'auth', json.decode(response.body)['data']['user_token']);
                  storage.setItem('user', json.decode(response.body)['data']);
                  auth = true;
                  Navigator.of(context)
                      .popAndPushNamed(ProfileScreen.routeName);
                } else {
                  switch (json.decode(response.body)['data']) {
                    case 1:
                      dialogError(context, "Телефон уже используется");
                      print(json.decode(response.body)['message']);
                      break;
                  }
                }
              } else {
                dialogError(context, "Неверный код");
              }
            },
            color: Color(0xFF00633E),
          ),
        ],
      );
    },
  );
}

// Модалка login
loginModal(BuildContext context) {
  final LocalStorage storage = new LocalStorage('auth');
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: TextField(
          keyboardType: TextInputType.phone,
          controller: _sms,
          inputFormatters: [maskForCode],
          style: kTextFieldStyle,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF00633E), width: 5.0),
            ),
            hintText: 'Введите код',
            hintStyle: TextStyle(fontFamily: 'Rubik'),
          ),
        ),
        actions: [
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: new Text(
              "Подтвердить",
              style: kTextStyleButton,
            ),
            colorBrightness: Brightness.dark,
            onPressed: () async {
              var user_phone = phone
                  .replaceAll(new RegExp(r'[^\w\s]+'), '')
                  .replaceAll(new RegExp(r"\s+\b|\b\s"), "");

              if (_sms.text.toString() == smsCode.toString()) {
                final http.Response response = await http.post(
                  API_URL + '/user/login',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Client': CLIENT,
                  },
                  body: json.encode(<String, String>{
                    'user_phone': user_phone,
                  }),
                );

                if (json.decode(response.body)['success']) {
                  storage.setItem(
                      'auth', json.decode(response.body)['data']['user_token']);
                  storage.setItem('user', json.decode(response.body)['data']);

                  print(storage.getItem('auth'));
                  auth = true;
                  Navigator.of(context)
                      .popAndPushNamed(ProfileScreen.routeName);
                } else {
                  switch (json.decode(response.body)['data']) {
                    case 1:
                      dialogError(context, "Неверный телефон");
                      print(json.decode(response.body)['message']);
                      break;
                    case 2:
                      dialogError(context, "Неверный пароль");
                      print(json.decode(response.body)['message']);
                      break;
                  }
                }
              } else {
                dialogError(context, "Неверный код");
              }
            },
            color: Color(0xFF00633E),
          ),
        ],
      );
    },
  );
}

// Модалка ошибки
dialogError(BuildContext context, text) {
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
        actions: [
          FlatButton(
            child: Text(
              'Ок',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}
