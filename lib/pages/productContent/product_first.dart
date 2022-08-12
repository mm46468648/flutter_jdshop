import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jdshop/config/Config.dart';
import 'package:flutter_jdshop/model/ProductContentModel.dart';
import 'package:flutter_jdshop/pages/productContent/cart_num.dart';
import 'package:flutter_jdshop/provider/Cart.dart';
import 'package:flutter_jdshop/provider/Counter.dart';
import 'package:flutter_jdshop/services/CartServices.dart';
import 'package:flutter_jdshop/services/EventBus.dart';
import 'package:flutter_jdshop/services/ScreenAdaper.dart';
import 'package:flutter_jdshop/widget/jd_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ProductFirst extends StatefulWidget {
  ProductContentitem? contentitem;

  ProductFirst({Key? key, this.contentitem}) : super(key: key);

  @override
  _ProductFirstState createState() => _ProductFirstState();
}

class _ProductFirstState extends State<ProductFirst>
    with AutomaticKeepAliveClientMixin {
  ProductContentitem? contentitem;

  List<Attr> _attr = [];

  String _selectValue = "";

  StreamSubscription? evebutDes = null;

  @override
  void initState() {
    super.initState();

    print("productFirst initstate--------------");
    this.contentitem = widget.contentitem;
    this._attr = contentitem?.attr ?? [];

    _initAttr();
    _getSelectedAttrValue();
    //接受广播
    evebutDes = eventBus.on<ProductContentEvent>().listen((event) {
      print("eventbus===============${event.str}");
      _showBottomSheet();
    });
  }

  @override
  void dispose() {
    super.dispose();
    evebutDes?.cancel();
  }

  //初始化attr格式化数据
  _initAttr() {
    var attr = this._attr;
    for (var i = 0; i < attr.length; i++) {
      var listLength = attr[i].list?.length ?? 0;
      for (var j = 0; j < listLength; j++) {
        _attr[i].listMap?.add(
            {"title": attr[i].list?[j], "checked": j == 0 ? true : false});
      }
    }
  }

  _changeAttr(cate, title, Counter counterProvider) {
    print("cate------${cate}         title------${title}");
    // var attr = this._attr;
    var attr = counterProvider.attr;
    for (var i = 0; i < attr.length; i++) {
      if (attr[i].cate == cate) {
        var listLength = attr[i].listMap?.length ?? 0;
        for (var j = 0; j < listLength; j++) {
          var map = _attr[i].listMap?[j];
          map?['checked'] = map['title'] == title;
        }
      }
    }

    counterProvider.setSelectAttr(attr);
    _getSelectedAttrValue();

    setState(() {
      this._attr = attr;
    });

  }

  _getSelectedAttrValue() {
    var attr = this._attr;
    List tempAttr = [];
    for (var i = 0; i < attr.length; i++) {
      var listLength = attr[i].listMap?.length ?? 0;
      for (var j = 0; j < listLength; j++) {
        var map = _attr[i].listMap?[j];
        if (map?['checked']) {
          tempAttr.add(map?['title']);
        }
      }
    }


    _selectValue = tempAttr.join(",");
    this.contentitem?.selectedAttr = this._selectValue;

  }

  List<Widget> _getAttrWidget(Counter counterProvider) {
    var attr = counterProvider.attr;

    return attr.map((e) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              '${e.cate}: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            width: ScreenAdapter.width(130),
          ),
          Expanded(
              child: Wrap(
                  children: e.listMap?.map((attr) {
                        return Container(
                          margin: EdgeInsets.all(5),
                          child: InkWell(
                              onTap: () {
                                _changeAttr(
                                    e.cate, attr['title'], counterProvider);
                              },
                              child: Chip(
                                backgroundColor: attr['checked']
                                    ? Colors.red
                                    : Colors.black26,
                                label: Text(
                                  "${attr['title']}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                padding: EdgeInsets.all(10),
                              )),
                        );
                      }).toList() ??
                      []))
        ],
      );
    }).toList();
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          var counterProvider = Provider.of<Counter>(context);
          var cartProvider = Provider.of<Cart>(context);
          return Container(
            height: 400,
            child: Stack(
              children: [
                ListView(
                  children: [
                    Column(children: _getAttrWidget(counterProvider)),
                    Divider(),
                    Container(
                      height: ScreenAdapter.height(80),
                      child: InkWell(
                        child: Row(
                          children: [
                            Text(
                              '数量: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            CartNum(productContent: contentitem)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Positioned(
                    width: ScreenAdapter.width(750),
                    height: ScreenAdapter.height(86),
                    bottom: 0,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                            child: JdButton(
                              text: "加入购物车",
                              color: Color.fromRGBO(253, 1, 0, 0.9),
                              cb: () async{
                                await CartServices.addCart(this.contentitem);
                                Navigator.of(context).pop();
                                //通知provider更新
                                cartProvider.updateCartList();

                                Fluttertoast.showToast(
                                    msg: "加入购物车成功",
                                    toastLength: Toast.LENGTH_SHORT,);
                              },
                            ),
                        ),
                        Expanded(
                          child: JdButton(
                            text: "立即购买",
                            color: Color.fromRGBO(225, 165, 0, 0.9),
                          ),
                          flex: 1,
                        )
                      ],
                    ))
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var counterProvider = Provider.of<Counter>(context);
    counterProvider.initAttr(this._attr);

    var pic = "${Config.domain}${this.contentitem?.pic?.replaceAll("\\", "/")}";
    return Container(
      child: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.network(
              pic,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              this.contentitem?.title ?? "",
              style: TextStyle(
                  color: Colors.black87, fontSize: ScreenAdapter.sp(36)),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              this.contentitem?.subTitle ?? "",
              style: TextStyle(
                  color: Colors.black87, fontSize: ScreenAdapter.sp(28)),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Text('价格: '),
                        Text(
                          '\$${this.contentitem?.price}',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: ScreenAdapter.sp(36)),
                        ),
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('原价: '),
                        Text(
                          '\$${this.contentitem?.oldPrice}',
                          style: TextStyle(
                              fontSize: ScreenAdapter.sp(36),
                              decoration: TextDecoration.lineThrough),
                        )
                      ],
                    ))
              ],
            ),
          ),
          //筛选
          this._attr.length > 0
              ? Container(
                  height: ScreenAdapter.height(80),
                  child: InkWell(
                    child: Row(
                      children: [
                        Text(
                          '已选: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${_selectValue}')
                      ],
                    ),
                    onTap: () {
                      _showBottomSheet();
                    },
                  ),
                )
              : Container(),
          Divider(
            height: 1,
          ),
          Container(
            height: ScreenAdapter.height(80),
            child: Row(
              children: [
                Text(
                  '运费: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('免运费')
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
