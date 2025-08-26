import 'package:flutter/material.dart';

class ScanningPage1 extends StatelessWidget {
  const ScanningPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              Text(
                "Live Scanning",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 15),
              Text(
                "External device camera",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 30),
              Container(
                width: 370,
                height: 230,
                decoration: BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              SizedBox(height: 30),

              Container(
                width: 370,
                height: 120,
                decoration: BoxDecoration(
                  color: Color(0xFF000000),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(),
              ),

              SizedBox(height: 30),

              Container(
                width: 370,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFF1ACF68),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, color: Colors.white),

                    SizedBox(width: 10),

                    Text(
                      "Start Scanning",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),

              Container(
                width: 370,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFF1ACF68), width: 1),
                ),
                child: Center(
                  child: Text(
                    "New Scan",
                    style: TextStyle(
                      color: Color(0xFF1ACF68),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.bluetooth),
              label: 'Connect',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'Scan'),
          ],
        ),
      ),
    );
  }
}
