import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      // App名字
      title: '简易刷新',
      // App主题
      theme: new ThemeData(
        primarySwatch: Colors.orange,
      ),
      // 主页
      home: _Example(),
      localizationsDelegates: [
        GlobalEasyRefreshLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('zh', 'CN')
    ]
    );
  }
}

class _Example extends StatefulWidget {
  @override
  _ExampleState createState() {
    return _ExampleState();
  }
}

class _ExampleState extends State<_Example> {
  EasyRefreshController _controller;

  // 条目总数
  int _count = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("快速刷新"),
        ),
        body: EasyRefresh.custom(
          enableControlFinishRefresh: false,
          enableControlFinishLoad: true,
          controller: _controller,
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2), () {
              print('onRefresh');
              setState(() {
                _count = 20;
              });
              _controller.resetLoadState();
            });
          },
          onLoad: () async {
            await Future.delayed(Duration(seconds: 2), () {
              print('onLoad');
              setState(() {
                _count += 10;
              });
              _controller.finishLoad(noMore: _count >= 40);
            });
          },
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    width: 60.0,
                    height: 60.0,
                    child: Center(
                      child: Text('$index'),
                    ),
                    color:
                        index % 2 == 0 ? Colors.grey[300] : Colors.transparent,
                  );
                },
                childCount: _count,
              ),
            ),
          ],
        ),
        persistentFooterButtons: <Widget>[
          FlatButton(
              onPressed: () {
                _controller.callRefresh();
              },
              child: Text("刷新", style: TextStyle(color: Colors.black))),
          FlatButton(
              onPressed: () {
                _controller.callLoad();
              },
              child: Text("加载更多", style: TextStyle(color: Colors.black))),
        ]);
  }

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
  }
}
