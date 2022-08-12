import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jdshop/config/Config.dart';
import 'package:flutter_jdshop/model/ProductContentModel.dart';
import 'package:flutter_jdshop/pages/productContent/product_detail.dart';
import 'package:flutter_jdshop/pages/productContent/product_first.dart';
import 'package:flutter_jdshop/pages/productContent/product_third.dart';
import 'package:flutter_jdshop/provider/Cart.dart';
import 'package:flutter_jdshop/services/CartServices.dart';
import 'package:flutter_jdshop/services/EventBus.dart';
import 'package:flutter_jdshop/services/ScreenAdaper.dart';
import 'package:flutter_jdshop/widget/LoadingWidget.dart';
import 'package:flutter_jdshop/widget/jd_button.dart';
import 'package:provider/provider.dart';

class ProductContent extends StatefulWidget {
  final Map? argument;

  ProductContent({Key? key, this.argument}) : super(key: key);

  @override
  _ProductContentState createState() => _ProductContentState();
}

class _ProductContentState extends State<ProductContent> {
  var _tabs = ['商品', '详情', '评价'];
  ProductContentitem? contentitem;

  @override
  void initState() {
    _getContentData();
    super.initState();
  }

  _getContentData() async {
    var api = "${Config.domain}api/pcontent?id=${widget.argument?['pid']}";

    try {
      var resoult = await Dio().get(api);
      var productContent = new ProductContentModel.fromJson(resoult.data);
      setState(() {
        this.contentitem = productContent.result;
      });
      print(productContent.result?.pic ?? "");
    } catch (e) {
      print("请求异常:--------${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<Cart>(context);

    return DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: ScreenAdapter.width(400),
                    child: TabBar(
                      indicatorColor: Colors.red,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: _tabs.map((e) {
                        return Tab(
                          child: Text(
                            e,
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: IconButton(
                    icon: Icon(Icons.more_horiz),
                    onPressed: () {
                      showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(
                              ScreenAdapter.width(600),
                              ScreenAdapter.height(100),
                              10,
                              0),
                          items: [
                            PopupMenuItem(
                                child: Row(
                              children: [
                                Icon(Icons.home),
                                Text('首页'),
                              ],
                            )),
                            PopupMenuItem(
                                child: Row(
                              children: [
                                Icon(Icons.search),
                                Text('搜索'),
                              ],
                            )),
                          ]);
                    },
                  ),
                )
              ],
            ),
            body: this.contentitem == null
                ? LoadingWidget()
                : Stack(
                    children: [
                      TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          ProductFirst(
                            contentitem: this.contentitem,
                          ),
                          ProductDetail(contentitem: this.contentitem),
                          ProductThird(contentitem: this.contentitem)
                        ],
                      ),
                      Positioned(
                          width: ScreenAdapter.width(750),
                          height: ScreenAdapter.height(100),
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    top: BorderSide(
                                        color: Colors.black38, width: 1))),
                            child: Row(
                              children: [
                                InkWell(
                                  child: Container(
                                    width: 100,
                                    height: ScreenAdapter.height(100),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.shopping_cart),
                                        Text("购物车")
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/cart');
                                  },
                                ),
                                Expanded(
                                  flex: 1,
                                  child: JdButton(
                                    text: "加入购物车",
                                    color: Color.fromRGBO(253, 1, 0, 0.9),
                                    cb: () async {
                                      if (contentitem?.attr?.isNotEmpty ==
                                          true) {
                                        eventBus
                                            .fire(ProductContentEvent('打开购物车'));
                                      } else {
                                        print('直接加入购物车');
                                        await CartServices.addCart(
                                            this.contentitem);
                                        //通知provider更新
                                        cartProvider.updateCartList();
                                      }
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: JdButton(
                                    text: "立即购买",
                                    color: Color.fromRGBO(225, 165, 0, 0.9),
                                    cb: () {
                                      if (contentitem?.attr?.isNotEmpty ==
                                          true) {
                                        eventBus
                                            .fire(ProductContentEvent('立即购买'));
                                      } else {
                                        print('立即购买');
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ))
                    ],
                  )));
  }
}
