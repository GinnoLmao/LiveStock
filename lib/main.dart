import 'package:flutter/material.dart';
import 'package:livestock_prototype/navigation/bottom_nav.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      home: BottomNavigation(),
    );
  }
}
