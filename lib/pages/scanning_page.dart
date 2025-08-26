import 'package:flutter/material.dart';

class ScanningPage extends StatelessWidget {
  const ScanningPage({Key? key}) : super(key: key);

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
                height: 450,
                decoration: BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(15),
                ),
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
