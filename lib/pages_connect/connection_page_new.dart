import 'package:flutter/material.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  bool isBluetoothEnabled = false;
  List<String> devices = [];
  String? selectedDevice;

  // Mock devices for demonstration
  final List<String> mockDevices = [
    "ESP32-CAM-001",
    "ESP32-CAM-002",
    "Arduino-BT-001",
    "HC-05 Device",
  ];

  void _toggleBluetooth() {
    setState(() {
      isBluetoothEnabled = !isBluetoothEnabled;
      if (isBluetoothEnabled) {
        // Simulate device discovery
        devices = mockDevices;
      } else {
        devices.clear();
        selectedDevice = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            SizedBox(height: 60),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                DeviceStatus(
                  isBluetoothEnabled: isBluetoothEnabled,
                  onBluetoothToggle: _toggleBluetooth,
                ),
                SizedBox(height: 20),
                // Show device list when Bluetooth is enabled
                if (isBluetoothEnabled && devices.isNotEmpty)
                  DeviceList(
                    devices: devices,
                    selectedDevice: selectedDevice,
                    onDeviceSelected: (device) {
                      setState(() {
                        selectedDevice = device;
                      });
                    },
                  ),
                SizedBox(height: 20),
                // ConnectionSteps already uses elevated Material and step numbers
                ConnectionSteps(),
                SizedBox(height: 40),
                ConnectDevice(
                  selectedDevice: selectedDevice,
                  isEnabled: selectedDevice != null,
                ),
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
  final bool isBluetoothEnabled;
  final VoidCallback onBluetoothToggle;

  const DeviceStatus({
    super.key,
    required this.isBluetoothEnabled,
    required this.onBluetoothToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBluetoothToggle,
      child: Container(
        width: 370,
        height: 180,
        decoration: BoxDecoration(
          color: isBluetoothEnabled ? Color(0xFFE8F5E8) : Color(0xFFEDE9FE),
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45),
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.bluetooth,
                    size: 36,
                    color: isBluetoothEnabled
                        ? Color(0xFF1ACF68)
                        : Color(0xFFBA31E4),
                  ),
                ),
              ),
            ),
            SizedBox(height: 26),
            Container(
              child: Text(
                isBluetoothEnabled ? "Bluetooth Enabled" : "Bluetooth Disabled",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              child: Text(
                isBluetoothEnabled ? "Tap to turn off" : "Tap to turn on",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF043778),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────── DeviceList ───────────────────────────────
class DeviceList extends StatelessWidget {
  final List<String> devices;
  final String? selectedDevice;
  final Function(String) onDeviceSelected;

  const DeviceList({
    super.key,
    required this.devices,
    required this.selectedDevice,
    required this.onDeviceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 370,
        constraints: BoxConstraints(maxHeight: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 24, left: 18, bottom: 10),
              child: Text(
                "Available Devices",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];
                  final isSelected = selectedDevice == device;

                  return ListTile(
                    leading: Icon(
                      Icons.bluetooth,
                      color: isSelected ? Color(0xFF1ACF68) : Colors.grey,
                    ),
                    title: Text(
                      device,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.normal,
                        color: isSelected ? Color(0xFF1ACF68) : Colors.black,
                      ),
                    ),
                    subtitle: Text("MAC: ${_generateMockMAC(index)}"),
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: Color(0xFF1ACF68))
                        : null,
                    onTap: () => onDeviceSelected(device),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _generateMockMAC(int index) {
    final macs = [
      "AA:BB:CC:DD:EE:01",
      "AA:BB:CC:DD:EE:02",
      "AA:BB:CC:DD:EE:03",
      "AA:BB:CC:DD:EE:04",
    ];
    return macs[index % macs.length];
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
  final String? selectedDevice;
  final bool isEnabled;

  const ConnectDevice({Key? key, this.selectedDevice, required this.isEnabled})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: isEnabled
            ? () {
                // Handle device connection here
                if (selectedDevice != null) {
                  _connectToDevice(context, selectedDevice!);
                }
              }
            : null,
        child: Container(
          width: 370,
          height: 60,
          decoration: BoxDecoration(
            color: isEnabled ? Color(0xFFBA31E4) : Colors.grey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              selectedDevice != null
                  ? "Connect to $selectedDevice"
                  : "Select a Device First",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _connectToDevice(BuildContext context, String device) {
    // Show connection dialog or navigate to connection process
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Connect Device"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Connecting to $device..."),
            SizedBox(height: 8),
            Text(
              "Please wait...",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
