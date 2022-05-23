import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class KeyPad extends StatefulWidget {


  KeyPad({Key? key}) : super(key: key);

  @override
  State<KeyPad> createState() => _KeyPadState();
}

class _KeyPadState extends State<KeyPad> {
  final _controller = StreamController.broadcast();
  final _scoreStream = StreamController.broadcast();
  int score = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
            stream: _scoreStream.stream,
            builder: (context,  AsyncSnapshot snapshot) {
              if(snapshot.hasData){
                score += snapshot.data as int;
                if(score>100){

                  Fluttertoast.showToast(msg: 'AA太棒了',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      fontSize: 28
                  );
                }
              }

              print('score in:${score}');
              return Text('Score: $score');
            }
        ),
      ),
      body:  Stack(
        children: [

          ...List.generate(10, (index) =>Puzzle(_controller.stream,_scoreStream)),

          Align(
            alignment: Alignment.bottomCenter,
            child: KeyPad1(_controller),),
        ],

      ),
    );
  }

}

class Puzzle extends StatefulWidget{

  final Stream inputStream;
  final StreamController scoreStream;
  Puzzle(this.inputStream, this.scoreStream);

  @override
  State<StatefulWidget> createState() =>_PuzzleState();

}

class _PuzzleState extends State<Puzzle> with SingleTickerProviderStateMixin{

    int? a,b;
    Color? color;
    double x = 0.0;
    AnimationController? _controller ;

    reset([from=0.0]){
      a = Random().nextInt(5)+1;
      b= Random().nextInt(5);
      x = Random().nextDouble()*300;
      color = Colors.primaries[Random().nextInt(Colors.primaries.length)][200];
      _controller?.duration = Duration(milliseconds: Random().nextInt(5000)+5000);
      _controller?.forward(from: from);
    }

    @override
    void initState(){

      super.initState();



      _controller = AnimationController(vsync: this,);
      reset(Random().nextDouble());//第一次随机开始

      _controller?.addStatusListener((status) {
        if(status == AnimationStatus.completed){
            reset();
            widget.scoreStream.add(-5);
        }
      });

      widget.inputStream.listen((event) {
        if(event== a! + b!){
          reset();
          //+ 答对了 点击了数字键盘 监听到
          widget.scoreStream.add(5);
        }
      });
    }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AnimatedBuilder(
      animation: _controller!,
      builder: (context,child){
        return Positioned(
          left: x,
          top: 700 * _controller!.value -100,
          child: Container(
            decoration: BoxDecoration(
              color: color?.withOpacity(0.5),
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(24),

            ),
            padding: EdgeInsets.all(8),
            child: Text('$a + $b',style: TextStyle(fontSize: 24),),
          ),
        );
      }
    );
  }
}

class KeyPad1 extends StatelessWidget {
  final _controller;
   KeyPad1(this._controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: GridView.count(
        padding: EdgeInsets.all(0.0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        childAspectRatio: 2/1,
        children: List.generate(9, (index){
          return TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                backgroundColor: MaterialStateProperty.all(Colors.primaries[index][200]),
              ),
              onPressed:(){
                _controller.add(index+1);
              }, child: Text("${index + 1}", style: TextStyle(
              fontSize: 24,
              color: Colors.black),

          ));
        }),


      ),
    );
  }
}