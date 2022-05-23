import 'package:flutter/material.dart';
class SliversPage extends StatelessWidget {
  const SliversPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return sliver_test1();
    return  sliver_test2();
  }

  Scaffold sliver_test2() {
    return Scaffold(
        appBar: AppBar(title: Text('slivers'),),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: FlutterLogo(size: 200,),
            ),


            SliverGrid(delegate: SliverChildBuilderDelegate((context,index){
              return Container(
                height: 200,
                color: Colors.primaries[index%18],
              );
            },childCount: 18), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4)),

            SliverList(delegate: SliverChildBuilderDelegate((context,index){
              return Container(
                height: 200,
                color: Colors.primaries[index%18],
              );
            })
            )
          ],
        )
    );
  }


  Scaffold sliver_test1() {
    return Scaffold(
    appBar: AppBar(title: Text('slivers'),),
    body: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: FlutterLogo(size: 200,),
        ),


        SliverGrid(delegate: SliverChildBuilderDelegate((context,index){
          return Container(
            height: 200,
            color: Colors.primaries[index%18],
          );
        },childCount: 18), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4)),

        SliverList(delegate: SliverChildBuilderDelegate((context,index){
          return Container(
            height: 200,
            color: Colors.primaries[index%18],
              );
            })
          )
        ],
      )
    );
  }
}
