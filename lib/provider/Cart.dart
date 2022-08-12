import 'package:flutter/material.dart';
import 'package:flutter_jdshop/model/ProductContentModel.dart';
import 'dart:convert';

import '../services/Storage.dart';
class Cart with ChangeNotifier{

  List _cartList = [];

  List get cartList => this._cartList;
  int get cartNum => this._cartList.length;

  bool _isCheckedAll = false;    //是否全选,默认false
  bool get isCheckedAll => this._isCheckedAll;

  double _allPrice = 0; //总价
  double get allPrice => this._allPrice;

  Cart(){
    _initData();
  }

  _initData() async{
    try{
      var value = await Storage.getString('cartList');
      if(value == null){
        return;
      }
      List cartListData = json.decode(value);
      this._cartList = cartListData;
    }catch(e){
      this._cartList = [];
    }

    _isCheckedAll = isCheckAll();
    computeAllPrice();
    notifyListeners();
  }
  addList(value){
    this._cartList.add(value);
    notifyListeners();
  }

  updateCartList(){
    _initData();
  }

  itemCountChange() {
    Storage.setString("cartList", json.encode(this._cartList));
    computeAllPrice();
    notifyListeners();
  }

  checkAll(value){
    _cartList.forEach((element) {
      element['checked'] = value;
    });

    _isCheckedAll = value;
    Storage.setString("cartList", json.encode(this._cartList));
    computeAllPrice();
    notifyListeners();
  }

  bool isCheckAll(){
    var all =  !_cartList.any((element) => element['checked'] == false);
    return all;
  }

  itemCheckedChange(){
    _isCheckedAll = isCheckAll();
    Storage.setString("cartList", json.encode(this._cartList));
    computeAllPrice();
    notifyListeners();
  }

  computeAllPrice(){
    double tempAllPrice = 0;
    for (var i = 0; i < this._cartList.length; i++) {
      if (this._cartList[i]["checked"] == true) {
        tempAllPrice += this._cartList[i]["price"] * this._cartList[i]["count"];
      }
    }
    this._allPrice = tempAllPrice;
    // notifyListeners();
  }

  removeItem(){
    //遍历出没有勾选的数据,重新赋值给新的list
    List tempList=[];
    for (var i = 0; i < this._cartList.length; i++) {
      if (this._cartList[i]["checked"] == false) {
        tempList.add(this._cartList[i]);
      }
    }
    this._cartList=tempList;
    //计算总价
    this.computeAllPrice();
    Storage.setString("cartList", json.encode(this._cartList));

    print("removeItem after ${tempList}");
    notifyListeners();
  }

}