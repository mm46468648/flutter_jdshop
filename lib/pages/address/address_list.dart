import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jdshop/config/Config.dart';
import 'package:flutter_jdshop/services/EventBus.dart';
import 'package:flutter_jdshop/services/ScreenAdaper.dart';
import 'package:flutter_jdshop/services/SignServices.dart';
import 'package:flutter_jdshop/services/UserServices.dart';

class AddressListPage extends StatefulWidget {
  AddressListPage({Key? key}) : super(key: key);

  @override
  _AddressListPageState createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  List addressList = [];
  StreamSubscription? ss;
  @override
  void initState() {
    super.initState();
    this._getAddressList();

    //监听增加收货地址的广播
    ss = eventBus.on<AddressEvent>().listen((event) {
      print(event.str);
      this._getAddressList();
    });
  }

  @override
  void dispose(){
    super.dispose();
    ss?.cancel();
  }
  _getAddressList() async {
    //请求接口
    List userinfo = await UserServices.getUserInfo();

    var tempJson = {"uid": userinfo[0]['_id'], "salt": userinfo[0]["salt"]};

    var sign = SignServices.getSign(tempJson);

    var api =
        '${Config.domain}api/addressList?uid=${userinfo[0]['_id']}&sign=${sign}';

    var response = await Dio().get(api);
    // print(response.data["result"]);

    setState(() {
      this.addressList = response.data["result"];
    });
  }

  //修改默认收货地址

  //修改默认收货地址
  _changeDefaultAddress(id) async{

    List userinfo = await UserServices.getUserInfo();

    var tempJson = {"uid": userinfo[0]['_id'], "id":id,"salt": userinfo[0]["salt"]};

    var sign = SignServices.getSign(tempJson);

    var api =
        '${Config.domain}api/changeDefaultAddress';
    var response = await Dio().post(api,data:{
      "uid": userinfo[0]['_id'],
      "id":id,
      "sign":sign
    });

    if(response.data['success']){
      eventBus.fire(ChangeAddressEvent('修改收货地址成功'));
      Navigator.pop(context);
    }

  }

  _showDelAlertDialog(id) async{
    await showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('提示信息'),
        content: Text('您确定要删除么?'),
        actions: [
          FlatButton(onPressed: (){
            Navigator.pop(context,'Cancle');
          }, child: Text('取消')),
          FlatButton(onPressed: () async {
            Navigator.pop(context,'Ok');
            _deleteAddress(id);

          }, child: Text('确定'))
        ],
      );
    });
  }

  _deleteAddress(id) async{
    List userinfo=await UserServices.getUserInfo();


    var tempJson={
      "uid":userinfo[0]["_id"],
      "id":id,
      "salt":userinfo[0]["salt"]
    };

    var sign=SignServices.getSign(tempJson);
    // print(sign);

    var api = '${Config.domain}api/deleteAddress';
    var response = await Dio().post(api,data:{
      "uid":userinfo[0]["_id"],
      "id":id,
      "sign":sign
    });

    print(response);
    if(response.data['success']){
      _getAddressList();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("收货地址列表"),
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              ListView.builder(
                itemCount: this.addressList.length,
                itemBuilder: (context, index) {
                  if (this.addressList[index]["default_address"] == 1) {
                    return Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        ListTile(
                          leading: Icon(Icons.check, color: Colors.red),
                          title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    "${this.addressList[index]["name"]}  ${this.addressList[index]["phone"]}"),
                                SizedBox(height: 10),
                                Text("${this.addressList[index]["address"]}"),
                              ]),
                          trailing: IconButton(icon:Icon(Icons.edit), color: Colors.blue,onPressed: (){
                            Navigator.pushNamed(context, '/addressEdit',arguments:this.addressList[index]);
                          },),
                          onTap: (){
                            _changeDefaultAddress(this.addressList[index]["_id"]);
                          },
                          onLongPress: (){
                            _showDelAlertDialog(this.addressList[index]["_id"]);
                          },
                        ),
                        Divider(height: 20),
                      ],
                    );
                  } else {
                    return Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        ListTile(
                          title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    "${this.addressList[index]["name"]}  ${this.addressList[index]["phone"]}"),
                                SizedBox(height: 10),
                                Text("${this.addressList[index]["address"]}"),
                              ]),
                          trailing: IconButton(icon:Icon(Icons.edit), color: Colors.blue,onPressed: (){
                            Navigator.pushNamed(context, '/addressEdit',arguments:this.addressList[index]);
                          },),
                          onTap: (){
                            _changeDefaultAddress(this.addressList[index]["_id"]);
                          },
                          onLongPress: (){
                            _showDelAlertDialog(this.addressList[index]["_id"]);
                          },
                        ),
                        Divider(height: 20),
                      ],
                    );
                  }
                },
              ),
              Positioned(
                bottom: 0,
                width: ScreenAdapter.width(750),
                height: ScreenAdapter.height(88),
                child: Container(
                  padding: EdgeInsets.all(5),
                  width: ScreenAdapter.width(750),
                  height: ScreenAdapter.height(88),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border(
                          top: BorderSide(width: 1, color: Colors.black26))),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add, color: Colors.white),
                        Text("增加收货地址", style: TextStyle(color: Colors.white))
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/addressAdd');
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
