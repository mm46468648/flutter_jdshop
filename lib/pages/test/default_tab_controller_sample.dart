import 'package:flutter/material.dart';

class DefaultTabControllerSample extends StatelessWidget {
  final List<Tab> myTabs = [
    Tab(
      text: "选项卡一",
    ),
    Tab(
      text: "选项卡一",
    ),
    Tab(
      text: "选项卡四",
    ),
    Tab(
      text: "选项卡五百",
    ),
    Tab(
      text: "选项卡六百八",
    )
  ];



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text('选项卡测试'),
            bottom: TabBar(
              tabs: myTabs,
            ),
          ),
          body: TabBarView(
            children: myTabs.map((Tab e) {
              return Center(
                child: Text(e.text ?? ""),
              );
            }).toList(),
          ),
          floatingActionButton: Builder(
            builder: (BuildContext context) {
              return FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    // Scaffold.of(context)
                    //     .showSnackBar(SnackBar(content: Text("哈哈哈")));
                  });
            },
          ),
        ),
      ),
    );
  }
}
