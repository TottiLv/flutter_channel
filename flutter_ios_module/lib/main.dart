import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
/*
* Flutter与iOS通信，需要创建module
* flutter create -t module flutter_ios_module
* //flutter_ios_module 为模块名称
* */
void main() {
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //此处的名字，需要告知原生项目，channel必须名称相同，否则无法通信
  final _messageChannel = BasicMessageChannel("message_channel", StandardMessageCodec());
  final _firstPageChannel = MethodChannel("first_channel");
  final _secondPageChannel = MethodChannel("second_channel");
  String _pageIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _messageChannel.setMessageHandler((message) {
      print("接收到来自原生App的消息${message}");
      return null;
    });
    _firstPageChannel.setMethodCallHandler((call) {
      print(call.method);
      setState(() {
        _pageIndex = call.method;
      });
      return null;
    });
    _secondPageChannel.setMethodCallHandler((call) {
      setState(() {
        _pageIndex = call.method;
      });
      return null;
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _rootPage(_pageIndex),
    );
  }

  Widget _rootPage(String pageIndex) {
    //pageIndex中的名称，为原生项目传入的，注意名称必须与原生项目一致
    switch (pageIndex) {
      case 'first':
        return Scaffold(
          appBar: AppBar(
            title: Text(pageIndex),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  //exit这个名称，需要告知原生项目，然后进行响应
                  _firstPageChannel.invokeMapMethod('exit');
                },
                child: Text(pageIndex),
              ),
              TextField(
                onChanged: (String str) {
                  _messageChannel.send(str);
                },
              )
            ],
          ),
        );
        break;
      case 'second':
        return Scaffold(
          appBar: AppBar(
            title: Text(pageIndex),
          ),
          body: Center(
              child: RaisedButton(
                onPressed: () {
                  _secondPageChannel.invokeMapMethod('exit');
                },
                child: Text(pageIndex),
              )),
        );
        break;
      default:
        return Scaffold(
          appBar: AppBar(
            title: Text("default"),
          ),
          body: Center(
              child: RaisedButton(
                onPressed: () {
                  MethodChannel('default_page').invokeMapMethod('exit');
                },
                child: Text(pageIndex),
              )),
        );
    }
  }
}