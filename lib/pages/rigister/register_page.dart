import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jdshop/config/Config.dart';
import 'package:flutter_jdshop/pages/tabs/Tabs.dart';
import 'package:flutter_jdshop/widget/jd_button.dart';
import 'package:flutter_jdshop/widget/jd_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String tel = '';
  sendCode() async{
    var regExp = RegExp(r"^1\d{10}");
    var b = regExp.hasMatch(tel);
    if(b){
      var api = "${Config.domain}api/sendCode";
      var response = await Dio().post(api,data:{"tel" : this.tel});
      if(response.data['success']){
        //输入服务器返回的验证码
        print(response);
        Navigator.pushNamed(context, '/registerSecond',arguments: {'tel':this.tel});
      }else{
        Fluttertoast.showToast(msg: '${response.data['message']}');
      }
    }else{
      Fluttertoast.showToast(msg: '手机号格式错误');
    }
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
              JdTextField(hint: '请输入手机号',onChanged: (val){
                this.tel = val;
              },),
              SizedBox(
                height: 20,
              ),
              JdButton(
                text: "下一步",
                color: Colors.red,
                height: 74,
                cb: () {
                  sendCode();
                },
              )
            ],
          ),
        ));
  }
}
