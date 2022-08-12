
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenAdapter{

  static init(context){
    ScreenUtil.init(context, designSize: const Size(750, 1334));
  }
  static height(double value){
     return ScreenUtil().setHeight(value);
  }
  static width(double value){
      return ScreenUtil().setWidth(value);
  }
  static getScreenHeight(){
    return ScreenUtil().screenHeight;
  }
  static getScreenWidth(){
    return ScreenUtil().screenWidth;
  }

  static sp(double value){
    return ScreenUtil().setSp(value);
  }
  // ScreenUtil.screenHeight 
}

// ScreenAdaper