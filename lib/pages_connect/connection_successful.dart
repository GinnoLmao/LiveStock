import 'package:flutter/material.dart';

class ConnectionSuccessful extends StatelessWidget {
  const ConnectionSuccessful({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: ListView(
            children: [
              const SizedBox(height: 60),
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
                  ConnectionSteps(),
                  SizedBox(height: 60),
                  ConnectDevice(),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
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

// ─────────────────────────────── DeviceStatus ───────────────────────────────
class DeviceStatus extends StatelessWidget {
  const DeviceStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370,
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFF1ACF68),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 22),
            child: Material(
              elevation: 6,
              shape: const CircleBorder(),
              shadowColor: Colors.black54,
              child: Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 48, // adjust size as you like
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            "Connected Successfully!",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const Text(
            "Device is ready for scanning",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Color(0xFF043778),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────── ConnectionSteps ───────────────────────────────
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
              color: const Color(0xFF1ACF68),
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
          color: const Color(0xFF1ACF68),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            "Go to Camera",
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
