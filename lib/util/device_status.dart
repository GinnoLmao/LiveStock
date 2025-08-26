import 'package:flutter/material.dart';

class DeviceStatus extends StatelessWidget {
  const DeviceStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 180, // 170 original
      decoration: BoxDecoration(
        color: Color(0xFFEDE9FE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 22),
            child: Material(
              elevation: 6, // shadow depth
              shape: const CircleBorder(),
              shadowColor: Colors.black54,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  color: Colors.white,
                ),
                child: const Icon(
                  Icons.bluetooth,
                  size: 36,
                  color: Color(0xFFBA31E4),
                ),
              ),
            ),
          ),
          SizedBox(height: 26),
          Container(
            child: Text(
              "Ready to Connect",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            child: Text(
              "Please connect your device",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Color(0xFF043778),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
