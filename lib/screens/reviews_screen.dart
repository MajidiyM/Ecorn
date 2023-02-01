import 'package:auto_size_text/auto_size_text.dart';
import 'package:ecorn/styles/font_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecorn/widgets/nav.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewsScreen extends StatefulWidget {
  static final routeName = "reviewsScreen";

  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final _reviewsKey = GlobalKey<FormState>();

  TextEditingController controller = TextEditingController();
  TextEditingController controller1 = TextEditingController();
  FocusNode nodeOne = FocusNode();
  FocusNode nodeTwo = FocusNode();
  bool _isButtonDisabled;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Обратная связь',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Rubik',
          ),
        ),
      ),
      drawer: NavDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            child: Form(
              key: _reviewsKey,
              child: Column(
                children: [
                  //Logo
                  Container(
                    height: 200,
                    child: Image.asset('images/logo.png'),
                  ),
                  //TextField(Заголовок)
                  Container(
                    margin: EdgeInsets.only(
                      top: 32,
                      left: 32,
                      right: 32,
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) return 'Заполните поле';
                        return null;
                      },
                      showCursor: false,
                      style: kTextFieldStyle,
                      textCapitalization: TextCapitalization.sentences,
                      controller: controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF00633E), width: 5.0),
                        ),
                        prefixIcon: Icon(Icons.info),
                        hintText: 'Заголовок',
                      ),
                    ),
                  ),
                  //TextField(Текст)
                  Container(
                    margin: EdgeInsets.only(
                      top: 32,
                      left: 32,
                      right: 32,
                      bottom: 20,
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) return 'Заполните поле';
                        return null;
                      },
                      style: kTextFieldStyle,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.send,
                      focusNode: nodeTwo,
                      controller: controller1,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Текст',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF00633E), width: 5.0),
                        ),
                      ),
                    ),
                  ),
                  //SendButton
                  FractionallySizedBox(
                    widthFactor: 0.84,
                    child: Container(
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
                        onPressed: () {
                          if (_reviewsKey.currentState.validate()) {
                            _showCupertinoDialog();
                            controller.clear();
                            controller1.clear();
                          }
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
    );
  }

//AlertDialog
/*  _showDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 4,
        titlePadding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Center(
          child: Text(
            'Cпасибо',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Rubik',
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
        ),
        content: Text(
          'Ваш отзыв очень важен для нас!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
            fontFamily: 'Rubik',
            fontWeight: FontWeight.bold,
          ),
        ),
        contentPadding: EdgeInsets.only(bottom: 25.0, right: 10, left: 10),
        backgroundColor: Color(0xFF00633E),
      ),
    );
  }*/

  _showCupertinoDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              'Cпасибо',
              style: TextStyle(
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
            content: Text(
              'Ваш отзыв очень важен для нас!',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Rubik',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        });
  }
}
