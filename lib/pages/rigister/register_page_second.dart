import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jdshop/config/Config.dart';
import 'package:flutter_jdshop/widget/jd_button.dart';
import 'package:flutter_jdshop/widget/jd_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterSecondPage extends StatefulWidget {
  Map? arguments;

  RegisterSecondPage({Key? key, this.arguments}) : super(key: key);

  @override
  _RegisterSecondPageState createState() => _RegisterSecondPageState();
}

class _RegisterSecondPageState extends State<RegisterSecondPage> {
  String? tel;
  String? code;

  bool resetButton = false; //重新发送
  int seconds = 10;

  @override
  void initState() {
    super.initState();
    tel = widget.arguments?['tel'];
    showTimer();
  }

  Timer? timer;

  showTimer() async {
    timer = Timer.periodic(Duration(milliseconds: 1000), (t) {
      setState(() {
        this.seconds--;
      });

      if (this.seconds == 0) {
        t.cancel();
        this.resetButton = true;
      }
    });
  }

  sendCode() async {
    setState(() {
      this.seconds = 10;
      this.resetButton = false;
    });
    showTimer();
    var api = "${Config.domain}api/sendCode";
    var response = await Dio().post(api, data: {"tel": this.tel});
    if (response.data['success']) {
      //输入服务器返回的验证码
      print(response);
    } else {
      Fluttertoast.showToast(msg: '${response.data['message']}');
    }
  }

  /**
   * 验证验证码
   */
  validateCode() async {
    var api = "${Config.domain}api/validateCode";
    var response = await Dio().post(api, data: {"tel": this.tel,'code':this.code});
    if (response.data['success']) {
      //输入服务器返回的验证码
      print(response);
      Navigator.pushNamed(context, '/registerThird',arguments: {'tel':tel,'code':code});
    } else {
      Fluttertoast.showToast(msg: '${response.data['message']}');
    }
  }

  @override
  void dispose() {
    super.dispose();

    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('用户注册'),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              SizedBox(
                height: 50,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  '请输入${this.tel}手机收到的验证码',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Stack(
                  children: [
                    JdTextField(hint: '请输入验证码',onChanged: (val){
                      this.code = val;
                    }),
                    Positioned(
                        right: 0,
                        child: Container(
                          child: resetButton
                              ? RaisedButton(
                                  child: Text("重新发送"),
                                  onPressed: () {
                                    sendCode();
                                  },
                                )
                              : Text("${seconds}秒后重发"),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              JdButton(
                text: "下一步",
                color: Colors.red,
                height: 74,
                cb: () {
                  validateCode();
                },
              )
            ],
          ),
        ));
  }
}
