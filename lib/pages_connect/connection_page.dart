import 'package:flutter/material.dart';

import '../util/connect_device.dart';
import '../util/connection_steps.dart';
import '../util/device_status.dart';

class ConnectionPage extends StatelessWidget {
  ConnectionPage({Key? key}) : super(key: key);

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
                // ConnectionSteps already uses elevated Material and step numbers in util/connection_steps.dart
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
