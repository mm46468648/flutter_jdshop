import 'package:flutter/material.dart';
import 'package:flutter_jdshop/config/Config.dart';
import 'package:flutter_jdshop/model/ProductContentModel.dart';
import 'package:flutter_jdshop/pages/cart/CartNum.dart';
import 'package:flutter_jdshop/provider/Cart.dart';
import 'package:flutter_jdshop/services/ScreenAdaper.dart';
import 'package:provider/provider.dart';

class CartItem extends StatefulWidget {

  var productContentitem;
  CartItem({Key? key,this.productContentitem}) : super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {

  var productContentitem;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    this.productContentitem = widget.productContentitem;

    var pic = productContentitem?['pic'];
    var cartProvider = Provider.of<Cart>(context);
    return Container(
      height: ScreenAdapter.height(200),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: Row(
        children: [
          Container(
            width: ScreenAdapter.width(60),
            child: Checkbox(
              value: productContentitem['checked'],
              onChanged: (val) {
                  productContentitem['checked'] = !productContentitem['checked'];
                  cartProvider.itemCheckedChange();
              },
              activeColor: Colors.pink,
            ),
          ),
          Container(
            width: ScreenAdapter.width(160),
            child: Image.network(
              pic,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${productContentitem?['title']}",
                    maxLines: 2,
                  ),
                  Text(
                    "${productContentitem?['selectedAttr']}",
                    maxLines: 2,
                  ),
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "\$${productContentitem?['price']}",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: CartNum(productContentitem),
                      ),
                    ],
                  )
                ],
              )))
        ],
      ),
    );
  }
}
