import 'package:flutter/material.dart';

class TextFieldSample extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print("TextFieldSample初始化");
    var _controller = TextEditingController();

    _controller.addListener(() {
      print(_controller.text);
    });

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('选项卡测试'),
        ),
        body: Center(
          child: TextField(
            controller: _controller,
            onChanged: (text){
              print("onChange${text}");

            },
          ),
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
    );
  }
}
