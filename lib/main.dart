

import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rust/rust_http_generated.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String result = "";


  @override
  void initState() {
    super.initState();
  }

  Future<void> flutterRustRequest() async {
    try {
      final RustHttp rustHttp= RustHttpImpl(Platform.isAndroid ? DynamicLibrary.open('librust_http.so') : DynamicLibrary
          .executable());
      Ip ip = await rustHttp.getItem();
      result=ip.origin;
      setState(() {
      });
      print('aa变量返回的结果: ${ip.toString()},具体的值为：${ip.origin}');
    } catch (e) {
      print(e);
    }
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Text(widget.title),
    ),
    body: Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'flutter_rust_request result:$result',
            style: Theme
                .of(context)
                .textTheme
                .headline4,
          ),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: flutterRustRequest,
      tooltip: 'flutter_rust_request',
      child: const Icon(Icons.airline_seat_legroom_extra_outlined),
    ), // This trailing comma makes auto-formatting nicer for build methods.
  );
}}
