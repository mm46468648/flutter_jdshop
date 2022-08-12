import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jdshop/config/Config.dart';
import 'package:flutter_jdshop/pages/cart/CartNum.dart';
import 'package:flutter_jdshop/services/CartServices.dart';
import 'package:flutter_jdshop/services/CheckOutServices.dart';
import 'package:flutter_jdshop/services/EventBus.dart';
import 'package:flutter_jdshop/services/ScreenAdaper.dart';
import 'package:flutter_jdshop/services/SignServices.dart';
import 'package:flutter_jdshop/services/UserServices.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckOutPage extends StatefulWidget {
  CheckOutPage({Key? key}) : super(key: key);

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {


  @override
  void initState() {
    super.initState();

    getCheckOutData();
    getDefaultAddress();

    eventBus.on<ChangeAddressEvent>().listen((event) {
       getDefaultAddress();
    });
  }
  List checkOutData = [];
  List addressList = [];
  double allPrice = 0.0;

  getCheckOutData() async{
    var list =  await CartServices.getCheckoutData();
    var allPrice = CheckOutServices.getAllPrice(list);

    print("allPrice: ${allPrice}");
    setState(() {
      checkOutData = list;
      this.allPrice = allPrice;
    });
  }

  getDefaultAddress() async{
    List userinfo = await UserServices.getUserInfo();


    var tempJson = {
      "uid":userinfo[0]["_id"],
      "salt":userinfo[0]["salt"],
    };

    var sign = SignServices.getSign(tempJson);
    var api = '${Config.domain}api/oneAddressList?uid=${userinfo[0]["_id"]}&sign=${sign}';
    var response = await Dio().get(api);

    setState(() {
      this.addressList = response.data['result'];
    });
  }
  Widget checkOutItem(productContentitem) {
    var pic = productContentitem?['pic'];
    return Row(
      children: [
        Container(
          width: ScreenAdapter.width(160),
          child: Image.network(
            pic,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
            flex: 1,
            child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${productContentitem?['title']}",
                      maxLines: 2,
                    ),
                    Text(
                      "${productContentitem?['selectedAttr']}",
                      maxLines: 2,
                    ),
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "\$${productContentitem?['price']}",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text("x${productContentitem['count']}"),
                        ),
                      ],
                    )
                  ],
                )))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('结算页面'),
        ),
        body: this.checkOutData.length>0 ? Stack(
          children: [
            ListView(
              children: [
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      this.addressList.length > 0  ?  ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${this.addressList[0]['name'] } ${this.addressList[0]['phone'] }'),
                            SizedBox(height: 10,),
                            Text('${this.addressList[0]['address'] }')
                          ],
                        ),
                        trailing: Icon(Icons.navigate_next),
                        onTap: (){
                          Navigator.pushNamed(context, '/addressList');
                        },
                      ) : ListTile(
                        leading: Icon(Icons.add_location),
                        title: Text('请添加收货地址'),
                        trailing: Icon(Icons.navigate_next),
                        onTap: (){
                          Navigator.pushNamed(context, '/addressList');
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: this.checkOutData.map((e){
                      return checkOutItem(e);
                    }).toList(),
                  ),
                ) ,
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("商品总金额: 100"),
                      Divider(),
                      Text('立减:5'),
                      Divider(),
                      Text('运费:0')
                    ],
                  ),
                )
              ],
            ),
            Positioned(
                bottom: 0,
                width: ScreenAdapter.width(750),
                height: ScreenAdapter.height(100),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 1,
                        color: Colors.black26
                      )
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('总价:\$${allPrice.toStringAsFixed(1)}',style: TextStyle(color: Colors.red),),
                      RaisedButton(
                        color: Colors.red,
                        onPressed: () async {

                          if(this.addressList.isEmpty){
                            Fluttertoast.showToast(msg: '填写收货地址');
                            return;
                          }
                          List userinfo=await UserServices.getUserInfo();
                          //注意：商品总价保留一位小数
                          var allPrice=CheckOutServices.getAllPrice(checkOutData).toStringAsFixed(1);

                          //获取签名
                          var sign=SignServices.getSign({
                            "uid": userinfo[0]["_id"],
                            "phone": this.addressList[0]["phone"],
                            "address": this.addressList[0]["address"],
                            "name": this.addressList[0]["name"],
                            "all_price":allPrice,
                            "products": json.encode(checkOutData),
                            "salt":userinfo[0]["salt"]   //私钥
                          });
                          //请求接口
                          var api = '${Config.domain}api/doOrder';
                          var response = await Dio().post(api, data: {
                            "uid": userinfo[0]["_id"],
                            "phone": this.addressList[0]["phone"],
                            "address": this.addressList[0]["address"],
                            "name": this.addressList[0]["name"],
                            "all_price":allPrice,
                            "products": json.encode(checkOutData),
                            "sign": sign
                          });
                          print(response);
                          if(response.data["success"]){
                            //删除购物车选中的商品数据
                            // await CheckOutServices.removeUnSelectedCartItem();

                            //调用CartProvider更新购物车数据
                            // cartProvider.updateCartList();


                            //跳转到支付页面
                            Navigator.pushNamed(context, '/pay');
                          }
                      },child: Text('立即下单',style: TextStyle(color: Colors.white)),)
                    ],
                  ),
                ))
          ],
        ): Center(
            child:Text('购物车没有数据')
        ));
  }
}
