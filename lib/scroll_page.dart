import 'package:flutter/material.dart';
class ScrollPage extends StatefulWidget {
  const ScrollPage({Key? key}) : super(key: key);

  @override
  State<ScrollPage> createState() => _ScrollPageState();
}

class _ScrollPageState extends State<ScrollPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scroll',)),
      body: ListView.builder(

          itemCount: 10,
          itemExtent: 60,//强制设置item大小
          itemBuilder: (context,index){
            return ListTile(
              leading: Icon(Icons.person),
              title: Text('Name'),
              subtitle: Text('Subtitle'),
              trailing: IconButton(
                icon: Icon(Icons.delete_outline),
              onPressed: () {

              },
              ),
            );
      }),
    );
  }
}
