import 'package:flutter/material.dart';
import 'package:numerical_techniques/MyHome.dart';
import 'package:flutter/services.dart';
void main()=>runApp(new MaterialApp(home: new MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Numerical Techniques',
      color: Colors.black,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context)=>MyHome(),
      }, 
    );
  }
}