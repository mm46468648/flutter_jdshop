
import '../services/Storage.dart';
import 'dart:convert';

class UserServices{
  static getUserInfo() async{
     List userinfo = [];
     try {
       var userInfo = await Storage.getString('userInfo');
       if(userInfo != null){
         List userInfoData = json.decode(userInfo);
         userinfo = userInfoData;
       }

       print("userInfo:--------------${userInfo}");
    } catch (e) {
     userinfo = [];
    }
    return userinfo;      
  }
  static Future<bool> getUserLoginState() async{
      var userInfo=await UserServices.getUserInfo();
      if(userInfo.length>0&&userInfo[0]["username"]!=""){
        return true;
      }
      return false;
  }
  static loginOut(){
    Storage.remove('userInfo');
  }
}