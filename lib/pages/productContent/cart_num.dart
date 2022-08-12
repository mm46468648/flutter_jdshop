import 'package:flutter/material.dart';
import 'package:flutter_jdshop/model/ProductContentModel.dart';
import 'package:flutter_jdshop/services/ScreenAdaper.dart';

class CartNum extends StatefulWidget {
  ProductContentitem? productContent;
  CartNum({Key? key,this.productContent}) : super(key: key);

  @override
  _CartNumState createState() => _CartNumState();
}

class _CartNumState extends State<CartNum> {
  double _btnHeight = 45;
  ProductContentitem? productContent;

  @override
  void initState() {
    super.initState();

    productContent = widget.productContent;
    print("initState:=========${this.productContent?.count}");

  }

  Widget _leftBtn() {
    return InkWell(
        child: Container(
      alignment: Alignment.center,
      width: ScreenAdapter.width(_btnHeight),
      height: ScreenAdapter.width(_btnHeight),
      child: Text("-"),
    ),
      onTap: (){
          print("${this.productContent?.count}");
          var count = this.productContent?.count??0;
          if(count>1){
            setState(() {
              int originCount = this.productContent?.count??0;
              print("originCount:=======${originCount}");
              int newCount = originCount - 1;
              print("newCount:=======${newCount}");
              this.productContent?.count = newCount;
            });
          }
      },
    );
  }

  Widget _rightBtn() {
    return InkWell(
        child: Container(
      alignment: Alignment.center,
      width: ScreenAdapter.width(_btnHeight),
      height: ScreenAdapter.width(_btnHeight),
      child: Text("+"),
    ),
      onTap: (){
        setState(() {
          int originCount = this.productContent?.count??0;
          print("originCount:=======${originCount}");
          int newCount = originCount + 1;
          print("newCount:=======${newCount}");
          this.productContent?.count = newCount;
        });
      },
    );
  }

  Widget _middleArea() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(width:  ScreenAdapter.width(1), color: Colors.black12),
              right: BorderSide(width:  ScreenAdapter.width(1), color: Colors.black12))),
      alignment: Alignment.center,
      width: ScreenAdapter.width(70),
      height: ScreenAdapter.width(_btnHeight),
      child: Text("${this.productContent?.count ?? 1}"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenAdapter.width(164),
      decoration: BoxDecoration(border: Border.all(color: Colors.black12,width: ScreenAdapter.width(1))),
      child: Row(
        children: [
          _leftBtn(),
          _middleArea(),
          _rightBtn()
        ],
      ),
    );
  }
}
