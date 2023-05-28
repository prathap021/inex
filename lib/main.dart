// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:inex/view/homepage.dart';

import 'common/Scroll_Behaviour.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
      home: InEx(),
    );
  }
}
