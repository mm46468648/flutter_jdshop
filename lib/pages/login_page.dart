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

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String username = '';
  String password = '';

  doLogin() async {

    var regExp = RegExp(r"^1\d{10}");
    var b = regExp.hasMatch(username);
    if(!b){
      Fluttertoast.showToast(msg: '手机号格式错误');
      return;
    }
    var l = password.length;
    if (l < 6) {
      Fluttertoast.showToast(msg: "密码小于6位");
      return;
    }

    var api = "${Config.domain}api/doLogin";
    var response = await Dio().post(api,data:{'username':this.username,'password':this.password});
    if(response.data['success']){
      //输入服务器返回的验证码
      print(response);
      //保存用户信息
      var userInfo = json.encode(response.data['userinfo']);
      Storage.setString('userInfo', userInfo);
      //返回到UserPage
      Navigator.of(context).pop('ok');
      // //返回根目录
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) {
      //       return Tabs(index: 3,);
      //     }), (route) => route == null);
    }else{
      Fluttertoast.showToast(msg: '${response.data['message']}');
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: [
            Container(
              child: Center(
                  child: Text(
                '客服',
              )),
              padding: EdgeInsets.only(right: 10),
            )
          ]),
      body: ListView(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: ScreenAdapter.height(20)),
              height: ScreenAdapter.width(160),
              width: ScreenAdapter.width(160),
              child: Image.asset(
                'assets/images/login.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          JdTextField(
            hint: "请输入用户名",
            onChanged: (str) {
              username = str;
            },
          ),
          SizedBox(
            height: ScreenAdapter.height(10),
          ),
          JdTextField(
            hint: "请输入密码",
            onChanged: (str) {
              password = str;
            },
          ),
          SizedBox(
            height: ScreenAdapter.height(20),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('忘记密码'),
                InkWell(
                  child: Text('新用户注册'),
                  onTap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: ScreenAdapter.height(40),
          ),
          JdButton(
            text: '登录',
            color: Colors.red,
            height: 74,
            cb: (){
              doLogin();
            },
          )
        ],
      ),
    );
  }
}
