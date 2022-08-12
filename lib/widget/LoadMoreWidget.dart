import 'package:flutter/material.dart';

class LoadMoreWidget extends StatefulWidget {
  bool? hasMore;
  LoadMoreWidget({Key? key,this.hasMore}) : super(key: key);

  @override
  State<LoadMoreWidget> createState() => _LoadMoreWidgetState();
}

class _LoadMoreWidgetState extends State<LoadMoreWidget> {
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: widget.hasMore??false? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              strokeWidth: 1.0,
            ),Text(
              '加载中...',
              style: TextStyle(fontSize: 16.0),
            )
          ],
        ) : Text("没有更多了",style: TextStyle(fontSize: 16.0)),
      ),
    );;
  }
}