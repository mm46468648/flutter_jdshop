import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jdshop/config/Config.dart';
import 'package:flutter_jdshop/model/ProductModel.dart';
import 'package:flutter_jdshop/services/ScreenAdaper.dart';
import 'package:flutter_jdshop/widget/LoadMoreWidget.dart';
import 'package:flutter_jdshop/widget/LoadingWidget.dart';

class ProductList extends StatefulWidget {
  Map? argument;

  ProductList({Key? key, this.argument}) : super(key: key);

  @override
  _ProductLIstState createState() => _ProductLIstState(argument);
}

class _ProductLIstState extends State<ProductList> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  _ProductLIstState(Map<dynamic, dynamic>? argument) {
    print(argument?['cid']);
  }

  ScrollController _scrollController = new ScrollController();

  var _initKeywordsController=new TextEditingController();

  List _subTitleList = [
    {"title": "综合", "index": 0},
    {"title": "销量", "index": 1},
    {"title": "价格", "index": 2},
    {"title": "筛选", "index": 3}
  ];
  var _subTitleIndex = 0;

  @override
  void initState() {
    _getProductListData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 20) {
        _getProductListData();
      }
    });

    if(widget.argument?['keywords'] != null){
      _initKeywordsController.text = widget.argument?['keywords'];
    }
  }

  List<ProductItemModel> productList = [];
  var page = 0;
  var limit = 10;
  var hasMore = true;

  _getProductListData() {
    if (!hasMore) return;
    var api = "${Config.domain}api/plist?cid=${widget.argument?['cid']}&page=1";
    // var result = await Dio().get(api);
    List<ProductItemModel> list = [];
    for (int i = 0; i < limit; i++) {
      if (page == 5) {
        break;
      }
      var p = ProductItemModel();
      list.add(p);
    }

    if (list.length < limit) {
      hasMore = false;
    }
    setState(() {
      if (page == 0) {
        this.productList.clear();
      }
      page += 1;
      this.productList.addAll(list);
    });
  }

  Widget _ProductListBody() {
    if (this.productList.length == 0) {
      return LoadingWidget();
    }
    return Container(
      margin: EdgeInsets.only(top: ScreenAdapter.height(80)),
      padding: EdgeInsets.all(10),
      child: ListView.builder(
          itemCount: productList.length + 1,
          controller: _scrollController,
          itemBuilder: (context, index) {
            // print("index: ${index}  ----length: ${this.productList.length}");
            return index == this.productList.length
                ? LoadMoreWidget(hasMore: this.hasMore)
                : _productItem();
          }),
    );
  }

  Widget _productItem() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: ScreenAdapter.width(180),
              height: ScreenAdapter.width(180),
              child: Image.network(
                "https://www.itying.com/images/flutter/list${_subTitleIndex + 1}.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  height: ScreenAdapter.height(180),
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "戴尔(DELL)灵越3670 英特尔酷睿i5 高性能 台式电脑整机(第九代)",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Container(
                            height: ScreenAdapter.height(36),
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromRGBO(230, 230, 230, 0.9)),
                            child: Text('4g'),
                          ),
                          Container(
                            height: ScreenAdapter.height(36),
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromRGBO(230, 230, 230, 0.9)),
                            child: Text('128G'),
                          )
                        ],
                      ),
                      Text(
                        "\$990",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      )
                    ],
                  ),
                ))
          ],
        ),
        Divider(
          height: 20,
        )
      ],
    );
  }

  Widget _headWidget() {
    return Positioned(
        top: 0,
        width: ScreenAdapter.getScreenWidth(),
        height: ScreenAdapter.height(80),
        child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1, color: Color.fromRGBO(233, 233, 233, 0.9)))),
            width: ScreenAdapter.getScreenWidth(),
            height: ScreenAdapter.height(80),
            child: Row(
              children: _subTitleList.map((e) {
                return Expanded(
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${e['title']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: _subTitleIndex == e['index']
                                  ? Colors.red
                                  : Colors.black54),
                        ),
                        Icon(Icons.arrow_drop_down)
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        var index = e['index'];
                        if (index == 3) {
                          _globalKey.currentState?.openEndDrawer();
                        } else {
                          setState(() {
                            _subTitleIndex = index;
                            page = 0;
                            hasMore = true;
                            _scrollController.jumpTo(0);
                            _getProductListData();
                          });
                        }
                        print("========" + e.toString());
                      });
                    },
                  ),
                  flex: 1,
                );
              }).toList(),
            )));
  }

  Widget _getDrawer() {
    return Drawer(
        child: Container(
          height: ScreenAdapter.height(80),
      child: ListView(
        children: [
          Container(
            color: Colors.green,
            child: Icon(Icons.arrow_drop_up),
          ),
          Container(
            color: Colors.red,
            child: Icon(Icons.arrow_drop_down),
          ),
          Container(
            height: ScreenAdapter.height(80),
            color: Colors.black,
          ),
        ],
      ),
    ));
  }

  AppBar _getAppBar(){
    if(widget.argument?['keywords']!=null) {
      return AppBar(
        title: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/search');
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              height: ScreenAdapter.height(80),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(233, 233, 233, 0.8),
                  borderRadius: BorderRadius.circular(30)),
              child: TextField(
                controller: this._initKeywordsController,
                autofocus: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30))),
                onChanged: (v){
                  print("---------${v}");
                },
              ),
            )),
        leading: IconButton(
          icon: Icon(Icons.center_focus_weak),
          onPressed: () {},
        ),
        actions: [
          InkWell(
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 10),
                child: Text('搜索')
            ),
            onTap: () {
              // Navigator.pushReplacementNamed(
              //     context, '/productList', arguments: {'keyboard': ''});
              print(_initKeywordsController.text);
            },
          )
        ],
      );
    }
    return AppBar(
      title: Text('商品列表'),
      actions: [Text('')],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: _getAppBar(),
      endDrawer: _getDrawer(),
      body: Stack(children: <Widget>[_ProductListBody(), _headWidget()]),
    );
  }
}
