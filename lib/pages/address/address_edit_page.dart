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

class AddressEditPage extends StatefulWidget {
  Map? arguments;
  AddressEditPage({Key? key,this.arguments}) : super(key: key);

  @override
  _AddressEditPageState createState() => _AddressEditPageState();
}

class _AddressEditPageState extends State<AddressEditPage> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  Map? arguments;

  var area='';

  @override
  void initState() {
    super.initState();
    this.arguments = widget.arguments;
    print(arguments);

    if(arguments!=null){
      _nameController.text = "${arguments!['name']}";
      _phoneController.text = "${arguments!['phone']}";
      _addressController.text = "${arguments!['address']}";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("修改收货地址"),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20),
              JdTextField(
                controller: _nameController,
                hint: "收货人姓名",
                onChanged: (value){
                  _nameController.text=value;
                },
              ),
              SizedBox(height: 10),
              JdTextField(
                controller: _phoneController,
                hint: "收货人电话",
                onChanged: (value){
                  _phoneController.text=value;
                },
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 5),
                height: ScreenAdapter.height(68),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.black12))),
                child: InkWell(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.add_location),
                      this.area.length>0?Text('${this.area}', style: TextStyle(color: Colors.black54)):Text('省/市/区', style: TextStyle(color: Colors.black54))
                    ],
                  ),
                  onTap: () async{
                    Result? result = await CityPickers.showCityPicker(
                        context: context,
                        locationCode: "130102",
                        cancelWidget:
                        Text("取消", style: TextStyle(color: Colors.blue)),
                        confirmWidget:
                        Text("确定", style: TextStyle(color: Colors.blue))
                    );

                    // print(result);
                    setState(() {
                      this.area= "${result?.provinceName}/${result?.cityName}/${result?.areaName}";
                    });
                  },
                ),
              ),
              SizedBox(height: 10),
              JdTextField(
                controller: _addressController,
                hint: "详细地址",
                maxLines: 4,
                height: 200,
                onChanged: (value){
                  _addressController.text=value;
                },
              ),
              SizedBox(height: 10),
              SizedBox(height: 40),
              JdButton(text: "修改", color: Colors.red,cb: () async{

                List userinfo=await UserServices.getUserInfo();


                var tempJson={
                  "uid":userinfo[0]["_id"],
                  "id":this.arguments?["_id"],
                  "name": _nameController.text,
                  "phone":_phoneController.text,
                  "address":_addressController.text,
                  "salt":userinfo[0]["salt"]
                };

                var sign=SignServices.getSign(tempJson);
                // print(sign);

                var api = '${Config.domain}api/editAddress';
                var response = await Dio().post(api,data:{
                  "uid":userinfo[0]["_id"],
                  "id":this.arguments?["_id"],
                  "name": _nameController.text,
                  "phone":_phoneController.text,
                  "address":_addressController.text,
                  "sign":sign
                });

                print(response);
                if(response.data['success']){
                  eventBus.fire(AddressEvent('修改地址成功'));
                  Navigator.pop(context);
                }


              })
            ],
          ),
        )
    );
  }
}