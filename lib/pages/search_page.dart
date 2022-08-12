import 'package:flutter/material.dart';
import 'package:flutter_jdshop/services/ScreenAdaper.dart';
import 'package:flutter_jdshop/services/SearchService.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  List<String> _hostSearch = [
    '女装',
    '超大码男装',
    '超酷阿斯蒂芬阿萨德',
    '女装超大码男装',
    '超酷',
    '薇娅',
    '李佳琪推荐'
  ];

  String _keywords = '';

  @override
  void initState() {
    super.initState();
    print("initState===========${_historyListData.length}");
    _getHistoryData();
  }

  @override
  Widget build(BuildContext context) {
    print("build===========${_historyListData.length}");
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              height: ScreenAdapter.height(80),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(233, 233, 233, 0.8),
                  borderRadius: BorderRadius.circular(30)),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30))),
                onChanged: (value) {
                  this._keywords = value;
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
              if (_keywords.isNotEmpty) {
                _turnToProductPage(_keywords);
              }
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Container(
              child: Text("热搜", style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium,),
            ),
            Divider(),
            Wrap(
              children:
              _hostSearch.map((e) {
                return InkWell(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(233, 233, 233, 0.9),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text("$e"),
                  ),
                  onTap: () {
                    _turnToProductPage(e);
                  },
                );
              }).toList()
              ,
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("历史记录", style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium,),
                  InkWell(
                    child:  Icon(Icons.delete),
                    onTap: (){
                      SearchService.clearHistory();
                      _getHistoryData();
                    },
                  )

                ],
              ),
            ),
            Divider(),
            _historyListData.length == 0 ? Container(
              child: Text('暂无历史'),
            ) : Column(
              children: _historyListData.map((e) {
                return Column(
                  children: [
                      ListTile(
                        title: Text('$e'),
                        onLongPress: (){
                          _alertDialog(e);
                        },
                      ),
                    Divider(),
                  ],
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }

  _alertDialog(keyword) async{
    await showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('提示信息'),
        content: Text('您确定要删除么?'),
        actions: [
          FlatButton(onPressed: (){
            Navigator.pop(context,'Cancle');
          }, child: Text('取消')),
          FlatButton(onPressed: () async {
            Navigator.pop(context,'Ok');
            await SearchService.deleteHistoryWord(keyword);
            _getHistoryData();
          }, child: Text('确定'))
        ],
      );
    });
  }

  List _historyListData= [];
  _getHistoryData() async{
    var _historyListData = await SearchService.getSearchHistory();
    // this._historyListData = _historyListData;
    setState(() {
      print("search_page=======${_historyListData}");
      this._historyListData = _historyListData;
    });
  }

  _turnToProductPage(keyword) {
    Navigator.pushReplacementNamed(
        context, '/productList', arguments: {'keywords': keyword});

    SearchService.setSearchHistory(keyword);
  }
}
