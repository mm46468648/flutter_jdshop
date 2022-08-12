import 'package:city_pickers/city_pickers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jdshop/config/Config.dart';
import 'package:flutter_jdshop/services/EventBus.dart';
import 'package:flutter_jdshop/services/ScreenAdaper.dart';
import 'package:flutter_jdshop/services/SignServices.dart';
import 'package:flutter_jdshop/services/UserServices.dart';
import 'package:flutter_jdshop/widget/jd_button.dart';
import 'package:flutter_jdshop/widget/jd_text_field.dart';

class AddressAddPage extends StatefulWidget {
  AddressAddPage({Key? key}) : super(key: key);

  @override
  _AddressAddPageState createState() => _AddressAddPageState();
}

class _AddressAddPageState extends State<AddressAddPage> {
  var _area = '';
  var _name = '';
  var _phone = '';
  var _addres = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('增加收获地址'),
      ),
      body: Container(
          padding: EdgeInsets.only(top: 20),
          child: ListView(
            children: [
              JdTextField(
                hint: "收件人姓名",
                onChanged: (val){
                  _name = val;
              },
              ),
              SizedBox(
                height: 10,
              ),
              JdTextField(
                hint: "收货人电话",
                onChanged: (val){
                  _phone = val;
                },
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () { getResult();},
                  child: Container(
                    height: ScreenAdapter.height(68),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(width: 1, color: Colors.black12))),
                    child: Row(
                      children: [
                        Icon(Icons.add_location),
                        this._area.length>0 ? Text(this._area) :Text(
                          "省/市/区",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  )),
              JdTextField(
                hint: "详细地址",
                maxLines: 4,
                height: 200,
                onChanged: (val){
                  _addres = '${_area} ${val}';
                },
              ),
              SizedBox(
                height: 40,
              ),
              JdButton(
                text: "增加",
                color: Colors.red,
                cb: () async {

                  List userinfo = await UserServices.getUserInfo();

                  var tempJson = {
                    'uid':"${userinfo[0]['_id']}",
                    'name':this._name,
                    'phone':this._phone,
                    'address':this._addres,
                    'salt':"${userinfo[0]['salt']}",
                  };

                  var sign = SignServices.getSign(tempJson);

                  print("id:${userinfo[0]['_id']}-----salt:-----${userinfo[0]['salt']}-------sign:${sign}");

                  var api = "${Config.domain}api/addAddress";
                  var result = await Dio().post(api,data: {
                    'uid':"${userinfo[0]['_id']}",
                    'name':this._name,
                    'phone':this._phone,
                    'address':this._addres,
                    'sign':sign,
                  });

                  // print(result);
                  if(result.data['success']){
                    eventBus.fire(AddressEvent('增加成功'));
                    Navigator.pop(context);
                  }
                },
              )
            ],
          )),
    );
  }

  // 通过钩子事件, 主动唤起浮层.
  Future<Result?> getResult() async {
    // type 1
    Result? result = await CityPickers.showCityPicker(
      context: context,
    );

    setState(() {
      _area = "${result?.provinceName}/${result?.cityName}/${result?.areaName}";
    });
    print('result $result');
    return result;
  }
}
