import 'package:flutter/material.dart';
import 'package:flutter_jdshop/model/ProductContentModel.dart';
import 'package:flutter_jdshop/pages/cart/cart_item.dart';
import 'package:flutter_jdshop/provider/Cart.dart';
import 'package:flutter_jdshop/provider/Counter.dart';
import 'package:flutter_jdshop/services/ScreenAdaper.dart';
import 'package:flutter_jdshop/services/UserServices.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var _isEdit = false;

  /**
   * 去结算
   */
  docheckOut() async {
    //判断是否有选中的数据

    //4、判断用户有没有登录
    var loginState = await UserServices.getUserLoginState();
    if (loginState) {
      Navigator.pushNamed(context, '/checkOut');
    } else {
      Fluttertoast.showToast(
        msg: '您还没有登录，请登录以后再去结算',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Cart>(context);
    List productList = cartProvider.cartList;

    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
        actions: [
          InkWell(
              onTap: () {
                setState(() {
                  this._isEdit = !this._isEdit;
                });
              },
              child: Container(
                padding: EdgeInsets.only(right: 20),
                child: _isEdit ? Text("取消") : Text("管理"),
                alignment: Alignment.center,
              ))
        ],
      ),
      body: productList.length > 0
          ? Stack(
              children: [
                Container(
                  child: ListView(
                    children: productList.map((e) {
                      return CartItem(
                        productContentitem: e,
                      );
                    }).toList(),
                  ),
                  margin: EdgeInsets.only(bottom: ScreenAdapter.height(80)),
                ),
                Positioned(
                    width: ScreenAdapter.width(750),
                    height: ScreenAdapter.height(80),
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              top:
                                  BorderSide(color: Colors.black12, width: 1))),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: ScreenAdapter.width(60),
                                  child: Checkbox(
                                    value: cartProvider.isCheckedAll,
                                    activeColor: Colors.pink,
                                    onChanged: (val) {
                                      cartProvider.checkAll(val);
                                    },
                                  ),
                                ),
                                Text("全选"),
                                SizedBox(
                                  width: 20,
                                ),
                                _isEdit ? Text("") : Text('合计'),
                                _isEdit
                                    ? Text("")
                                    : Text(
                                        '\$${cartProvider.allPrice}',
                                        style: TextStyle(color: Colors.red),
                                      )
                              ],
                            ),
                          ),
                          _isEdit
                              ? Align(
                                  alignment: Alignment.centerRight,
                                  child: RaisedButton(
                                    child: Text("删除",
                                        style: TextStyle(color: Colors.white)),
                                    color: Colors.red,
                                    onPressed: () {
                                      cartProvider.removeItem();
                                    },
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.centerRight,
                                  child: RaisedButton(
                                    child: Text("结算",
                                        style: TextStyle(color: Colors.white)),
                                    color: Colors.red,
                                    onPressed: () {
                                      docheckOut();
                                    },
                                  ),
                                )
                        ],
                      ),
                    ))
              ],
            )
          : Center(
              child: Text("购物车空空的"),
            ),
    );
  }
}
