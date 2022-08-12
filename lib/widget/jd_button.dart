import 'package:flutter/material.dart';
import 'package:flutter_jdshop/services/ScreenAdaper.dart';

class JdButton extends StatelessWidget {
  Color color;
  String text;
  double height;
  Function()? cb;

  JdButton({Key? key, this.color = Colors.black, this.text = "",this.height = 68, this.cb})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: cb,
        child: Container(
          height: ScreenAdapter.height(height),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ));
  }
}
