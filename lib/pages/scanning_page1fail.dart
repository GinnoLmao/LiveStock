import 'package:flutter/material.dart';

class ScanningPage1Fail extends StatelessWidget {
  const ScanningPage1Fail({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 90),
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
              Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: 370,
                  height: 230,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 15),

              Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 370,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xFFF4C7C7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border(
                      left: BorderSide(color: Color(0XFFEF2C2C), width: 5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // First row: "Scan Complete" with check icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "No Swine Detected",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 8), // Space between text and icon
                            Icon(
                              Icons.cancel_outlined,
                              color: Color(0xFFEF2C2C),
                              size: 20,
                            ),
                            SizedBox(width: 150),
                            Text(
                              "Just Now",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 8), // Space between rows
                        // Second section: Detection information
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Please try again.",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
                      "Start Again",
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
      ),
    );
  }
}
