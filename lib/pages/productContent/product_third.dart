import 'package:flutter/material.dart';
import 'package:flutter_jdshop/model/ProductContentModel.dart';

class ProductThird extends StatefulWidget {

  ProductContentitem? contentitem;

  ProductThird({Key? key,this.contentitem}) : super(key: key);

  @override
  _ProductThirdState createState() => _ProductThirdState();
}

class _ProductThirdState extends State<ProductThird> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('评价'),
    );
  }

  @override
  bool get wantKeepAlive => true;
}