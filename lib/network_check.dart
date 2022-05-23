import 'dart:async';

import 'package:http/http.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetWorkCheck extends StatefulWidget {
  const NetWorkCheck({Key? key}) : super(key: key);

  @override
  State<NetWorkCheck> createState() => _NetWorkCheckState();
}

class _NetWorkCheckState extends State<NetWorkCheck> {
  StreamController<ConnectivityResult> _streamController = StreamController<ConnectivityResult>();
  StreamSink? _streamSink;
  Stream? _stream;
  String? _result;

  void _checkStatus() async{
    final ConnectivityResult result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.mobile) {
      _result = 'mobile';
    } else if (result == ConnectivityResult.wifi) {
      _result = 'wifi';
    } else if (result == ConnectivityResult.none) {
      _result = 'none';
    }
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _stream = _streamController.stream;
    _streamSink = _streamController.sink;
    _checkStatus();

    Connectivity().onConnectivityChanged.listen(
          (ConnectivityResult result) {
        _streamSink?.add(result);
      },
    );
  }

  @override
  dispose() {
    super.dispose();
    _streamSink?.close();
    _streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network Status'),
      ),
      body: Center(
        child: StreamBuilder(
          stream: _stream,
          builder: (context, AsyncSnapshot snapshot){
            if (snapshot.data == ConnectivityResult.mobile) {
              _result = 'mobile';
            } else if (snapshot.data == ConnectivityResult.wifi) {
              _result = 'wifi';
            } else if (snapshot.data == ConnectivityResult.none) {
              return Text('还没有链接网络');
            }
            if (_result == null) {
              return CircularProgressIndicator();
            }

            return ResultText(_result!);

          }

        ),
      ),
    );
  }
}

class ResultText extends StatelessWidget {
  final String result;

  const ResultText(this.result);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.black),
        text: '正在使用',
        children: [
          TextSpan(
            text: ' $result ',
            style: TextStyle(
              color: Colors.red,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: '链接网络'),
        ],
      ),
    );
  }
}
