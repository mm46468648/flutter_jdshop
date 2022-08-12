import 'package:flutter/material.dart';
import 'package:flutter_jdshop/config/Config.dart';
import 'package:flutter_jdshop/services/ScreenAdaper.dart';
import 'package:dio/dio.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key? key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with AutomaticKeepAliveClientMixin {
  int _selectIndex = 0;

  @override
  void initState() {
    super.initState();


  }
  Widget _leftWidget(leftWidth){
    return Container(
      child: ListView.builder(
          itemCount: 18,
          itemBuilder: (context, index) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      this._selectIndex = index;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color:
                    _selectIndex == index?Color.fromRGBO(240, 246, 246, 0.9) : Colors.white,
                    child: Text(
                      "第${index}行",
                    ),
                    width: double.infinity,
                    height: ScreenAdapter.height(84),
                  ),
                ),
                Divider(
                  height: 1,
                )
              ],
            );
          }),
      height: double.infinity,
      width: leftWidth,
    );
  }

  Widget _rightWidget(rightItemWidth,rightItemHeight){
    return Expanded(
        flex: 1,
        child: Container(
          padding: EdgeInsets.all(ScreenAdapter.width(20)),
          height: double.infinity,
          color: Color.fromRGBO(240, 246, 246, 0.9),
          child: GridView.builder(
              itemCount: 18,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: rightItemWidth/rightItemHeight
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, '/productList',arguments: {
                      "cid":"1"
                    });
                  },
                  child: Container(
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1/1.2,
                          child: Image.network("https://www.itying.com/images/flutter/list${_selectIndex}.jpg",fit: BoxFit.cover,),
                        ),
                        Container(
                          height: ScreenAdapter.height(28),
                          child:  Text('女装',),
                        )
                      ],
                    ),
                  ),
                );
              }),
        ));
  }

  @override
  Widget build(BuildContext context) {
    //计算右侧GridView宽高比
    var leftWidth = ScreenAdapter.getScreenWidth()/4;
    var rightItemWidth = (ScreenAdapter.getScreenWidth() - leftWidth - 20 - 20)/3;
    var rightItemHeight = rightItemWidth * 1.2 + ScreenAdapter.height(28);
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
      body: Row(
        children: [
          _leftWidget(leftWidth),
          _rightWidget(rightItemWidth,rightItemHeight)
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
