import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_jdshop/model/ProductContentModel.dart';

class ProductDetail extends StatefulWidget {

  ProductContentitem? contentitem;



  ProductDetail({Key? key,this.contentitem}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> with AutomaticKeepAliveClientMixin{

  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false
      ),
      android: AndroidInAppWebViewOptions(
          useHybridComposition: true
      ),
      ios: IOSInAppWebViewOptions(
          allowsInlineMediaPlayback: true
      )
  );

  @override
  Widget build(BuildContext context) {

    var url = "https://jdmall.itying.com/pcontent?id=${widget.contentitem?.sId}";
    // var url = "https://jdmall.itying.com/pcontent?id=5a0432f4010e71123466144c";
    // var url = "https://www.baidu.com";
    print("loadurl------------------${url}");
    return Container(
      child: InAppWebView(
        key: webViewKey,
        initialUrlRequest: URLRequest(url: Uri.parse(url)),
        initialOptions: options,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}