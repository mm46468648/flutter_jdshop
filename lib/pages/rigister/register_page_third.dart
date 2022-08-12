import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jdshop/config/Config.dart';
import 'package:flutter_jdshop/pages/tabs/Tabs.dart';
import 'package:flutter_jdshop/services/ScreenAdaper.dart';
import 'package:flutter_jdshop/services/Storage.dart';
import 'package:flutter_jdshop/widget/jd_button.dart';
import 'package:flutter_jdshop/widget/jd_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterThirdPage extends StatefulWidget {
  Map? arguments;

  RegisterThirdPage({Key? key, this.arguments}) : super(key: key);

  _RegisterThirdPageState createState() => _RegisterThirdPageState();
}

class _RegisterThirdPageState extends State<RegisterThirdPage> {
  String? tel;
  String? code;
  String password = '';
  String rePassword = '';

  @override
  void initState() {
    super.initState();
    tel = widget.arguments?['tel'];
    code = widget.arguments?['code'];
  }

  doRegister() async {
    var l = password.length;
    if (l < 6) {
      Fluttertoast.showToast(msg: "密码小于6位");
      return;
    }

    if (password != rePassword) {
      Fluttertoast.showToast(msg: "两次输入密码不一致");
      return;
    }

    var api = "${Config.domain}api/register";
    var response = await Dio()
        .post(api, data: {'tel': tel, 'code': code, 'password': password});
    if (response.data['success']) {
      //保存用户信息
      var userInfo = json.encode(response.data['userinfo']);
      Storage.setString('userInfo', userInfo);
      //返回根目录
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
            return Tabs(index: 3,);
          }), (route) => route == null);
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("用户注册-第三步"),
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenAdapter.width(20)),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 50),
            JdTextField(
              hint: "请输入密码",
              password: true,
              onChanged: (value) {
                password = value;
              },
            ),
            SizedBox(height: 10),
            JdTextField(
              hint: "请输入确认密码",
              password: true,
              onChanged: (value) {
                rePassword = value;
              },
            ),
            SizedBox(height: 20),
            JdButton(
              text: "注册",
              color: Colors.red,
              height: 74,
              cb: () {
                doRegister();
              },
            )
          ],
        ),
      ),
    );
  }
}
