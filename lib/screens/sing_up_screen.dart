import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

var maskFormatter = MaskTextInputFormatter(
    mask: '+998 (9#) ###-##-##', filter: {"#": RegExp(r'[0-9]')});
var _birthDate = TextEditingController();
var _phone = TextEditingController();

class SignInScreen extends StatefulWidget {
  static final routeName = "signInScreen";

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  void initState() {
    _birthDate.text = '';
    _phone.text = '+998 (9';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Регистрация',
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: 'Rubik',
          ),
        ),
      ),
      body: _signUp(context),
    );
  }
}

Widget _signUp(context) {
  return Center(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        child: Column(
          children: <Widget>[
            /* Name */
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Rubik',
                    color: Color(0xFF00633E)),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00633E), width: 5.0),
                    ),
                    hintText: 'Имя',
                    hintStyle: TextStyle(fontFamily: 'Rubik')),
              ),
            ),
            /* Phone */
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                controller: _phone,
                inputFormatters: [maskFormatter],
                style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Rubik',
                    color: Color(0xFF00633E)),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00633E), width: 5.0),
                    ),
                    hintText: '+998 (9*) ***-**-**',
                    hintStyle: TextStyle(fontFamily: 'Rubik')),
              ),
            ),
            /* Password */
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                obscureText: true,
                style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Rubik',
                    color: Color(0xFF00633E)),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF00633E), width: 5.0),
                  ),
                  hintText: 'Пароль',
                  hintStyle: TextStyle(fontFamily: 'Rubik'),
                ),
              ),
            ),
            /* Repeat password */
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                obscureText: true,
                style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Rubik',
                    color: Color(0xFF00633E)),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF00633E), width: 5.0),
                  ),
                  hintText: 'Повторите пароль',
                  hintStyle: TextStyle(fontFamily: 'Rubik'),
                ),
              ),
            ),
            /* Date of birth */
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                onTap: () => {
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
                          doneStyle:
                              TextStyle(color: Colors.white, fontSize: 16)),
                      onConfirm: (date) {
                    _birthDate.text =
                        DateFormat('dd.MM.yyyy').format(date).toString();
                  }, currentTime: DateTime.now(), locale: LocaleType.en)
                },
                readOnly: true,
                style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Rubik',
                    color: Color(0xFF00633E)),
                controller: _birthDate,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF00633E), width: 5.0),
                  ),
                  hintText: "Дата рождения",
                  hintStyle: TextStyle(fontFamily: 'Rubik'),
                ),
              ),
            ),
            /* Sign up button */
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 70.0,
                padding: const EdgeInsets.only(top: 10.0),
                child: new RaisedButton(
                  child: new Text(
                    "Зарегистрироваться",
                    style: new TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: 'Rubik'),
                  ),
                  colorBrightness: Brightness.dark,
                  onPressed: () {
//                  _loginAttempt(context);
                  },
                  color: Color(0xFF00633E),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
