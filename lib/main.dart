import 'package:flutter/material.dart';
import 'package:flutter_jdshop/pages/tabs/Tabs.dart';
import 'package:flutter_jdshop/provider/Counter.dart';
import 'package:flutter_jdshop/routers/Router.dart';
import 'package:provider/provider.dart';

import 'provider/Cart.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Counter()),
      ChangeNotifierProvider(create: (context) => Cart()),],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      theme: ThemeData(
          colorScheme: const ColorScheme.light(
        primary: Colors.white, onPrimary: Colors.black, //主题字体
      )),
      onGenerateRoute: onGenerateRoute,
    );
  }
}
