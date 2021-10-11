import 'package:flutter/material.dart';
import 'pong.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Pong pong = new Pong();
    return MaterialApp(
      title: 'Pong Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Simple Pong'),
          // actions: [
          //   IconButton(
          //     onPressed: onPressed,
          //     icon: Icon(Icons.replay),
          //   )
          // ],
        ),
        body: SafeArea(child: Pong()),
      ),
    );
  }
}
