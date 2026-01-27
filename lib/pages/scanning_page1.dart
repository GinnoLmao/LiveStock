import 'package:flutter/material.dart';
import 'dart:io';

class ScanningPage1 extends StatefulWidget {
  final double? computedWeight;
  final String? imagePath;

  const ScanningPage1({super.key, this.computedWeight, this.imagePath});

  @override
  State<ScanningPage1> createState() => _ScanningPage1State();
}

class _ScanningPage1State extends State<ScanningPage1> {
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
            SizedBox(height: 96),
            Text(
              "Weight Computation",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 15),
            Text(
              "Image analysis complete",
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
                child: widget.imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          File(widget.imagePath!),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey[600],
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
                  color: Color(0xFFE8F5E8),
                  borderRadius: BorderRadius.circular(10),
                  border: Border(
                    left: BorderSide(color: Color(0XFF1ACF68), width: 5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // First row: "Computation Complete" with check icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Computation Complete",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 20,
                          ),
                          SizedBox(width: 140),
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
                      // Second section: Weight information
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Livestock detected:",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "ID: LV-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}\nWeight: ~ ${widget.computedWeight?.toStringAsFixed(1) ?? "0.0"} kg",
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
                  // Navigate back to scanning page to compute again
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.straighten, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Compute Again",
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
                  // Save result and go back to home page
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                borderRadius: BorderRadius.circular(20),
                child: Center(
                  child: Text(
                    "Save Result",
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
