import 'package:flutter/material.dart';
import 'package:livestock_prototype/pages/home_page.dart';
import 'package:livestock_prototype/pages/scanning_page.dart';
import 'package:livestock_prototype/pages/scanning_page1.dart';
import 'package:livestock_prototype/pages_connect/connecting_page.dart';
import 'package:livestock_prototype/pages_connect/connection_failed.dart';
import 'package:livestock_prototype/pages_connect/connection_page.dart';
import 'package:livestock_prototype/pages_connect/connection_successful.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}
