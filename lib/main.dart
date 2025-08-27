import 'package:flutter/material.dart';
import 'package:livestock_prototype/navigation/bottom_nav.dart';
import 'package:livestock_prototype/pages_connect/connecting_page.dart';
import 'package:livestock_prototype/pages_connect/connection_failed.dart';
import 'package:livestock_prototype/pages_connect/connection_page.dart';
import 'package:livestock_prototype/pages_connect/connection_successful.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF1ACF68),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF1ACF68),
          secondary: Color(0xFF1ACF68),
        ),
      ),
      home: ConnectionPage(),
    );
  }
}
