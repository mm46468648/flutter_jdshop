import 'package:flutter/material.dart';
import 'package:flutter_jdshop/provider/Counter.dart';
import 'package:flutter_jdshop/services/ScreenAdaper.dart';
import 'package:flutter_jdshop/services/UserServices.dart';
import 'package:flutter_jdshop/widget/jd_button.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  bool _isLogin = false;
  List _userInfo = [];
  @override
  void initState() {
    super.initState();

    //获取登录信息
    getUserInfo();
  }

  getUserInfo() async{
    bool login = await UserServices.getUserLoginState();
    List userInfo = await UserServices.getUserInfo();
    setState(() {
      _isLogin = login;
      _userInfo = userInfo;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/user_bg.jpg'),
                    fit: BoxFit.cover)),
            height: ScreenAdapter.height(220),
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/user.png',
                      fit: BoxFit.cover,
                      width: ScreenAdapter.width(100),
                      height: ScreenAdapter.width(100),
                    ),
                  ),
                ),
                _isLogin ?  Expanded(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('用户名:${this._userInfo[0]['username']}',style: TextStyle(color: Colors.white,fontSize: ScreenAdapter.sp(32)),),
                    Text('普通会员',style: TextStyle(color: Colors.white,fontSize: ScreenAdapter.sp(24)),),
                  ],
                )) : Expanded(
                    flex: 1,
                    child: InkWell(
                        child: Text(
                      '登录/注册',
                      style: TextStyle(color: Colors.white),
                        ),
                      onTap: () async {
                          var result = await Navigator.pushNamed(context, '/login');
                          if(result == 'ok'){
                            getUserInfo();
                          }
                      },
                    )
                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.assignment, color: Colors.red),
            title: Text("全部订单"),
            onTap: (){
              Navigator.pushNamed(context, '/order');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment, color: Colors.green),
            title: Text("待付款"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.local_car_wash, color: Colors.orange),
            title: Text("待收货"),
          ),
          Container(
              width: double.infinity,
              height: 10,
              color: Color.fromRGBO(242, 242, 242, 0.9)),
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.lightGreen),
            title: Text("我的收藏"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.people, color: Colors.black54),
            title: Text("在线客服"),
          ),
          Divider(),
          this._isLogin?
          JdButton(text: "退出登录",color:Colors.black12,cb:(){
            UserServices.loginOut();
            this.getUserInfo();
          }):Container()
        ],
      ),
    );
  }
}
