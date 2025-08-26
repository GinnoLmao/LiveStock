import 'package:flutter/material.dart';

class ConnectionSteps extends StatelessWidget {
  const ConnectionSteps({Key? key}) : super(key: key);

  Widget buildStep(String text, int number) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: Color(0xFF1ACF68),
              borderRadius: BorderRadius.circular(45),
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 400,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Padding(
              padding: EdgeInsets.only(top: 24, left: 18),
              child: Text(
                "Connection Steps",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 10),

            // Steps in a column
            buildStep("Turn on your external device", 1),
            buildStep("Enable Bluetooth on this device", 2),
            buildStep("Tap the connect button below", 3),
          ],
        ),
      ),
    );
  }
}
