import 'package:flutter/material.dart';
import 'package:flutter_jdshop/services/ScreenAdaper.dart';

class JdTextField extends StatelessWidget {
  final String? hint;
  final bool? password;
  // final Object? onChanged;
  final Function(String)? onChanged;
  final int maxLines;
  final double height;
  TextEditingController? controller;

  JdTextField({Key? key,this.hint="输入内容",this.password=false,this.onChanged=null,this.maxLines = 1,this.height = 68,this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller:controller,
        maxLines: maxLines,
        obscureText: this.password ?? false,
        decoration: InputDecoration(
            hintText: this.hint,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none)),
        onChanged: this.onChanged,
      ),
      height: ScreenAdapter.height(height),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1,
                  color: Colors.black12
              )
          )
      ),
    );
  }
}
