import 'package:flutter/material.dart';
import 'package:flutter_jdshop/pages/Pay.dart';
import 'package:flutter_jdshop/pages/address/address_add_page.dart';
import 'package:flutter_jdshop/pages/address/address_edit_page.dart';
import 'package:flutter_jdshop/pages/address/address_list.dart';
import 'package:flutter_jdshop/pages/check_out_page.dart';
import 'package:flutter_jdshop/pages/login_page.dart';
import 'package:flutter_jdshop/pages/order/Order.dart';
import 'package:flutter_jdshop/pages/order/OrderInfo.dart';
import 'package:flutter_jdshop/pages/product_content.dart';
import 'package:flutter_jdshop/pages/product_list.dart';
import 'package:flutter_jdshop/pages/rigister/register_page.dart';
import 'package:flutter_jdshop/pages/rigister/register_page_second.dart';
import 'package:flutter_jdshop/pages/rigister/register_page_third.dart';
import 'package:flutter_jdshop/pages/search_page.dart';
import 'package:flutter_jdshop/pages/tabs/Cart.dart';
import 'package:flutter_jdshop/pages/tabs/Tabs.dart';
import 'package:flutter_jdshop/pages/test/default_tab_controller_sample.dart';
import 'package:flutter_jdshop/pages/test/textfield_sample.dart';

final routes = {
  '/': (contxt) => Tabs(),
  '/search': (contxt) => SearchPage(),
  '/cart': (contxt) => CartPage(),
  '/login': (contxt) => LoginPage(),
  '/register': (contxt) => RegisterPage(),
  '/registerSecond': (contxt,{arguments}) => RegisterSecondPage(arguments: arguments,),
  '/registerThird': (contxt,{arguments}) => RegisterThirdPage(arguments: arguments,),
  '/productList':(contxt,{arguments}) => ProductList(argument: arguments),
  '/productContent':(context,{arguments}) => ProductContent(argument: arguments),
  '/checkOut':(context,{arguments}) => CheckOutPage(),
  '/addressAdd':(context,{arguments}) => AddressAddPage(),
  '/addressList':(context,{arguments}) => AddressListPage(),
  '/addressEdit':(context,{arguments}) => AddressEditPage(arguments: arguments,),
  '/order':(context,{arguments}) => OrderPage(),
  '/pay':(context,{arguments}) => PayPage(),
  '/orderinfo': (context) => OrderInfoPage()
};

//固定写法
var onGenerateRoute = (RouteSettings settings) {
// 统一处理
  final String name = settings.name ?? '';
  final Function pageContentBuilder = routes[name] as Function;
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
      MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};