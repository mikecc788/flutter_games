import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:future_app/key_pad.dart';
import 'package:future_app/scroll_page.dart';
import 'package:future_app/slivers_page.dart';

import 'network_check.dart';


void main() {

  scheduleMicrotask(()=>print('scheduleMicrotask'));
  print('main1');
  Future.sync(() => print('sync1'));
  Future.value(getName());
  var future = getNetworkData();
  future.then((value){
    print(value);
  },onError: (e){
    print(e);
  });
  print(future);
  print('main2');

  printOrderMessage();

  runApp(const MyApp());
}

Future<void> printOrderMessage() async{
  print('Awaiting user order...');
  var order = await fetchUserOrder();
  print('You order is:$order');
}

Future<String> fetchUserOrder(){
  return Future.delayed(const Duration(seconds: 2),(){
    return 'Large Latte';
  });
}

Future<String> getNetworkData() {
  return Future(() {
    //执行其他耗时操作
    int result = 0;
    for (int i = 0; i < 100000; i++) {
      result += i;
    }
    //抛出异常
    return throw Exception('this is ');
    return "result:$result";
  });
}

String getName(){
  print('get name');
  return 'bbb';
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
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
  // 创建一个 StreamController
  StreamController<int> _counterStreamController = StreamController<int>(
    onCancel: (){
      print('cancel');
    },
    onListen: (){
      print('listen');
    },
  );


  int _counter = 0;
  Stream? _counterStream;
  StreamSink? _counterSink;


  Future<String> getFuture(){
    return Future(()=>'alice');
  }

  // 主动关闭流
  void _closeStream() {
    //stream流
    // _counterStreamController.close();
    //滚动控件
    Navigator.push(context,MaterialPageRoute(builder:
        (BuildContext context)=> ScrollPage()));

  }
  void _incrementCounter() {

    if(_counter>9){
      _counterSink?.close();
      return;
    }
    _counter++;
    _counterSink?.add(_counter);



    // getFuture().then((value) => print(value));
    // print('hi ');


  }


  final future =Future.delayed(Duration(seconds: 1),()=>42);
  final stream =Stream.periodic(Duration(seconds: 1),(_)=>42);
// 整数流
  Stream<int> intStream = StreamController<int>().stream;

  Stream<int> countStream(int to) async* {
    for (int i = 1; i <= to; i++) {
      yield i;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // future.then((value) => print(value));
    // stream.listen((value) => print('==$value'));
    //
    // Stream stream1 = countStream(18);
    // stream1.listen((event) {
    //   print(event);
    // });

    _counterSink = _counterStreamController.sink;
    _counterStream = _counterStreamController.stream;

    super.initState();

  }
  @override
  void dispose() {
    super.dispose();
    _counterSink?.close();
    _counterStreamController.close();
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
        // child: futureWidget(),
        //测试stream流
        child: streamWidget(counterStream: _counterStream, counter: _counter),
      ),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          SizedBox(width: 24.0),
          TextButton(
            onPressed: _closeStream,

            child: Text('滚动控件'),
          ),
          SizedBox(width: 24.0),
          TextButton(
            onPressed:(){
              Navigator.push(context,MaterialPageRoute(builder:
                  (BuildContext context)=> NetWorkCheck()));
            },
            child: Text('网络监测'),
          ),
          TextButton(
            onPressed:(){
              Navigator.push(context,MaterialPageRoute(builder:
                  (BuildContext context)=> KeyPad()));
            },
            child: Text('小游戏',style: TextStyle(color: Colors.deepPurpleAccent,fontSize: 30),),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}



class futureWidget extends StatelessWidget {
  const futureWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 2),()=> 456),
      builder: (BuildContext context,AsyncSnapshot snapshot){
        if(snapshot.hasData){
          return Text("${snapshot.data}");
        }
        if(snapshot.hasError){
          throw 'shold not happen';
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class streamWidget extends StatelessWidget {
  const streamWidget({
    Key? key,
    required Stream? counterStream,
    required int counter,
  }) : _counterStream = counterStream, _counter = counter, super(key: key);

  final Stream? _counterStream;
  final int _counter;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:<Widget> [
        Text('You have pushed the button this many times:'),
        StreamBuilder(
            stream: _counterStream,
            initialData: _counter,
            builder: (context, AsyncSnapshot snapshot){
              if (snapshot.connectionState == ConnectionState.done) {
                return Text(
                  'Done',
                  style: Theme.of(context).textTheme.bodyText2,
                );
              }
              int number = snapshot.data;
              return Text(
                '$number',
                style: Theme.of(context).textTheme.bodyText2,
              );

        }),

        ElevatedButton(onPressed:(){
          Navigator.push(context,MaterialPageRoute(builder:
          (BuildContext context)=> SliversPage()));
        }, child: Text('slivers')),

      ],
    );
  }
}
