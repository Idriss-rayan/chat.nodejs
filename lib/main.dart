//import 'package:chat/assign-0/formular.dart';
//import 'package:chat/assign-1/contactf.dart';
//import 'package:chat/assign-2/contact2.dart';
import 'package:chat/assign-3/listcont.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Listcont(),
    );
  }
}

void main() {
  runApp(MyApp());
}
