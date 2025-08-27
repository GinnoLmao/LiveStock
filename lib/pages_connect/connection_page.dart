import 'package:flutter/material.dart';

class ConnectionPage extends StatelessWidget {
  const ConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            SizedBox(height: 60),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  "Device Connection",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 15),
                Text(
                  "Connect your external device",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 40),
                DeviceStatus(),
                SizedBox(height: 20),
                // ConnectionSteps already uses elevated Material and step numbers
                ConnectionSteps(),
                SizedBox(height: 60),
                ConnectDevice(),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────── DeviceStatus ───────────────────────────────
class DeviceStatus extends StatelessWidget {
  const DeviceStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370,
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

// ─────────────────────────────── ConnectionSteps ───────────────────────────────
class ConnectionSteps extends StatelessWidget {
  const ConnectionSteps({super.key});

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
        width: 370,
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

// ─────────────────────────────── ConnectDevice ───────────────────────────────
class ConnectDevice extends StatelessWidget {
  const ConnectDevice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 370,
        height: 60,
        decoration: BoxDecoration(
          color: Color(0xFFBA31E4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            "Connect Device",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
