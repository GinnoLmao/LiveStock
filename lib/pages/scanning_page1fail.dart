import 'package:flutter/material.dart';

class ScanningPage1Fail extends StatefulWidget {
  final String? errorMessage;
  final String? imagePath;

  const ScanningPage1Fail({super.key, this.errorMessage, this.imagePath});

  @override
  State<ScanningPage1Fail> createState() => _ScanningPage1FailState();
}

class _ScanningPage1FailState extends State<ScanningPage1Fail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F7F9),
      appBar: AppBar(
        backgroundColor: Color(0xFFF6F7F9),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Weight Computation',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 90),
            Text(
              "Weight Computation",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 15),
            Text(
              "Analysis failed",
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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 50,
                        color: Colors.red[400],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Analysis Failed",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
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
                    left: BorderSide(color: Color(0xFFFF4444), width: 5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // First row: "Computation Failed" with error icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Computation Failed",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                          SizedBox(width: 160),
                          Text(
                            "Just Now",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      // Second section: Error information
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Error occurred:",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            widget.errorMessage ??
                                "Unable to compute weight from image.\nPlease try with a clearer photo.",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              height: 1.0,
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
              child: InkWell(
                onTap: () {
                  // Navigate back to scanning page to try computation again
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Try Again",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
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
              child: InkWell(
                onTap: () {
                  // Navigate back to home page (BottomNavigation)
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                borderRadius: BorderRadius.circular(20),
                child: Center(
                  child: Text(
                    "Back to Home",
                    style: TextStyle(
                      color: Color(0xFF1ACF68),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
