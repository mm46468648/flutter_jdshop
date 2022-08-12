
import 'package:flutter/material.dart';
import 'package:flutter_jdshop/model/ProductContentModel.dart';

class Counter with ChangeNotifier{
  int _count = 0;
  int get count=> _count;

  List<Attr> _attr = [];
  List<Attr> get attr => _attr;

  incCount(){
    this._count++;
    notifyListeners();
  }

  initAttr(attr){
    this._attr = attr;
  }

  setSelectAttr(attr){
    this._attr = attr;
    notifyListeners();
  }
}