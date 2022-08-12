import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jdshop/config/Config.dart';
import 'package:flutter_jdshop/model/FocusModel.dart';
import 'package:flutter_jdshop/model/ProductModel.dart';
import 'package:flutter_jdshop/services/ScreenAdaper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  List<FocusItemModel> _focusData = [];
  List<ProductItemModel> _bestProductList = [];

  @override
  void initState() {
    super.initState();

    _getFocusData();
    _getBestProductData();
  }

  Widget _titleWidget(data) {
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.red, width: 3))),
      child: Text(
        data,
        style: TextStyle(color: Colors.black87),
      ),
    );
  }

  _getFocusData() async {
    var path = Config.domain + 'api/focus';
    var focusData = await Dio().get(path);
    var focusList = FocusModel.fromJson(focusData.data);
    setState(() {
      this._focusData = focusList.result ?? [];
    });
    print(focusData);
  }

  //获取热门推荐的数据
  _getBestProductData() async {
    var api = '${Config.domain}api/plist?is_best=1';
    var result = await Dio().get(api);
    var bestProductList = ProductModel.fromJson(result.data);
    setState(() {
      this._bestProductList = bestProductList.result??[];
    });
  }

  /**
   * 轮播图
   */
  Widget _getSwiper() {
    return this._focusData.length > 0 ? Container(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Swiper(
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return Image.network(
              "${Config.domain}${_focusData[index].pic?.replaceAll("\\", "/")}",
              fit: BoxFit.fill,
            );
          },
          pagination: SwiperPagination(),
          autoplay: true,
        ),
      ),
    ) : Text("加载中...");
  }

  /**
   * 猜你喜欢
   */
  Widget _guessLisk() {
    return Container(
      height: ScreenUtil().setHeight(230),
      padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 80,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                width: ScreenUtil().setWidth(140),
                height: ScreenUtil().setHeight(140),
                child: Image.network(
                  "https://www.itying.com/images/flutter/hot${index + 1}.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                height: ScreenUtil().setHeight(54),
                child: Text('第${index}个'),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _recProductWidgetList() {
    var itemWidth = (ScreenAdapter.getScreenWidth() - 30) / 2;
    // var itemWidth = 100.0;
    return Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black12, width: 1)),
        width: itemWidth,
        padding: EdgeInsets.all(10),
        child: InkWell(
          onTap: (){
            Navigator.pushNamed(context, '/productContent',arguments: {'pid':'5a0425bc010e711234661439'});
          },
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Image.network(
                      "https://www.itying.com/images/flutter/list1.jpg",
                      fit: BoxFit.cover,
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenAdapter.height(20)),
                child: Text(
                  "阿斯蒂芬阿斯蒂芬阿斯蒂芬撒旦法撒旦法阿斯蒂芬",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenAdapter.height(20)),
                child: Stack(
                  children: [
                    Align(
                      child: Text(
                        '1111',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    Align(
                      child: Text('1111',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough)),
                      alignment: Alignment.centerRight,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  /**
   * 热门推荐
   */
  Widget _hotRecommed() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: [
          _recProductWidgetList(),
          _recProductWidgetList(),
          _recProductWidgetList(),
          _recProductWidgetList(),
          _recProductWidgetList(),
          _recProductWidgetList(),
        ],
      ),
    );
  }

  //热门商品

  Widget _hotProductListWidget() {
    var itemWidth = (ScreenAdapter.getScreenWidth() - 30) / 2;
    return Container(
      padding: EdgeInsets.all(10),
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: this._bestProductList.map((value) {
          //图片
          String sPic = value.sPic??'';
          sPic = Config.domain + sPic.replaceAll('\\', '/');

          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/productContent',
                  arguments: {"pid": value.sId});
            },
            child: Container(
              padding: EdgeInsets.all(10),
              width: itemWidth,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromRGBO(233, 233, 233, 0.9), width: 1)),
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: AspectRatio(
                      //防止服务器返回的图片大小不一致导致高度不一致问题
                      aspectRatio: 1 / 1,
                      child: Image.network(
                        "${sPic}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenAdapter.height(20)),
                    child: Text(
                      "${value.title}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenAdapter.height(20)),
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "¥${value.price}",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text("¥${value.oldPrice}",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(750, 1334));
    return Scaffold(
      appBar: AppBar(
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.search),
                  Text(
                    "笔记本",
                    style: TextStyle(fontSize: ScreenAdapter.sp(28)),
                  )
                ],
              ),
            )),
        leading: IconButton(
          icon: Icon(Icons.center_focus_weak),
          onPressed: () {},
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.message,
                size: 28,
              ))
        ],
      ),
      body: ListView(
        children: [
          _getSwiper(),
          SizedBox(
            height: 10,
          ),
          _titleWidget('猜你喜欢'),
          _guessLisk(),
          SizedBox(
            height: 10,
          ),
          _titleWidget('热门推荐'),
          _hotProductListWidget(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
