import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'connecting_page.dart';
import 'connection_successful.dart';
import 'connection_failed.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage>
    with WidgetsBindingObserver {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  List<BluetoothDevice> devices = <BluetoothDevice>[];
  Map<String, String> deviceNames = <String, String>{}; // Store device names
  BluetoothDevice? selectedDevice;
  bool isBluetoothEnabled = false;
  bool isScanning = false;
  bool isConnecting = false;
  BluetoothConnectionState connectionState =
      BluetoothConnectionState.disconnected;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestPermissions();
    _initBluetooth();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (isBluetoothEnabled) {
        _getConnectedDevices();
      }
    }
  }

  Future<void> _requestPermissions() async {
    // Request necessary permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      Permission.location,
    ].request();

    print("Permission statuses: $statuses");
  }

  Future<void> _initBluetooth() async {
    // Get adapter state
    _adapterState = await FlutterBluePlus.adapterState.first;
    isBluetoothEnabled = _adapterState == BluetoothAdapterState.on;

    if (isBluetoothEnabled) {
      await _getConnectedDevices();
    }

    // Listen to adapter state changes
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      _adapterState = state;
      isBluetoothEnabled = state == BluetoothAdapterState.on;
      if (isBluetoothEnabled) {
        _getConnectedDevices();
      } else {
        devices.clear();
        selectedDevice = null;
      }
      print("Bluetooth State: $state");
      if (mounted) setState(() {});
    });

    if (mounted) setState(() {});
  }

  Future<void> _getConnectedDevices() async {
    try {
      devices = FlutterBluePlus.connectedDevices;
      if (mounted) setState(() {});
    } catch (e) {
      print("Error getting connected devices: $e");
    }
  }

  Future<void> _toggleBluetooth() async {
    try {
      if (isBluetoothEnabled) {
        await FlutterBluePlus.turnOff();
      } else {
        await FlutterBluePlus.turnOn();
      }
    } catch (e) {
      print("Error toggling Bluetooth: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enable Bluetooth manually in Settings")),
      );
    }
  }

  Future<void> _startDiscovery() async {
    if (!isBluetoothEnabled) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please enable Bluetooth first")));
      return;
    }

    setState(() {
      isScanning = true;
      devices.clear(); // Clear previous results for fresh scan
      deviceNames.clear(); // Clear device names map
    });

    try {
      // Get already connected devices first
      await _getConnectedDevices();

      // Start scanning with enhanced parameters to find more devices
      await FlutterBluePlus.startScan(
        timeout: Duration(seconds: 20), // Longer scan time
        androidUsesFineLocation: true,
      );

      // Listen to scan results
      FlutterBluePlus.scanResults.listen((results) {
        Set<String> deviceIds = devices.map((d) => d.remoteId.str).toSet();

        for (ScanResult r in results) {
          // Debug prints to see what we're getting
          print("=== SCAN RESULT DEBUG ===");
          print("Full ScanResult r: $r");
          print("r.device: ${r.device}");
          print("r.device.platformName: '${r.device.platformName}'");
          print(
            "r.device.platformName.isEmpty: ${r.device.platformName.isEmpty}",
          );
          print("r.device.remoteId: ${r.device.remoteId}");
          print("r.rssi: ${r.rssi}");
          print("r.advertisementData: ${r.advertisementData}");
          print(
            "r.advertisementData.localName: '${r.advertisementData.localName}'",
          );
          print("=========================");

          // Add device if not already in list
          if (!deviceIds.contains(r.device.remoteId.str)) {
            devices.add(r.device);
            deviceIds.add(r.device.remoteId.str);

            // Try multiple ways to get device name
            String deviceName = '';
            if (r.device.platformName.isNotEmpty) {
              deviceName = r.device.platformName;
              print("Using platformName: $deviceName");
            } else if (r.advertisementData.localName.isNotEmpty) {
              deviceName = r.advertisementData.localName;
              print("Using advertisementData.localName: $deviceName");
            } else if (r.advertisementData.advName.isNotEmpty) {
              deviceName = r.advertisementData.advName;
              print("Using advertisementData.advName: $deviceName");
            } else {
              // Create a more descriptive name based on available data
              String deviceInfo = 'BLE Device';
              String extraInfo = '';

              // Check for manufacturer dat a
              if (r.advertisementData.manufacturerData.isNotEmpty) {
                var firstManufacturer =
                    r.advertisementData.manufacturerData.keys.first;
                // Common manufacturer IDs
                switch (firstManufacturer) {
                  case 76:
                    extraInfo += ' (Apple)';
                    break;
                  case 6:
                    extraInfo += ' (Microsoft)';
                    break;
                  case 224:
                    extraInfo += ' (Google)';
                    break;
                  case 117:
                    extraInfo += ' (Samsung)';
                    break;
                  default:
                    extraInfo += ' (Mfg:$firstManufacturer)';
                }
              }

              // Check for service data
              if (r.advertisementData.serviceData.isNotEmpty) {
                var serviceUuid = r.advertisementData.serviceData.keys.first;
                if (serviceUuid.toString().toLowerCase().contains('fef3')) {
                  extraInfo += ' [Nearby Share]';
                }
              }

              // Check RSSI to give distance hint
              if (r.rssi > -50) {
                extraInfo += ' [Very Close]';
              } else if (r.rssi > -70) {
                extraInfo += ' [Close]';
              } else if (r.rssi > -85) {
                extraInfo += ' [Medium]';
              } else {
                extraInfo += ' [Far]';
              }

              deviceName = deviceInfo + extraInfo;
              print("No name found, using: $deviceName");
            }

            // Store the device name in our map
            deviceNames[r.device.remoteId.str] = deviceName;

            print(
              "Found device: $deviceName - ${r.device.remoteId} - RSSI: ${r.rssi}",
            );
          }
        }

        if (mounted) setState(() {});
      });

      // Also refresh connected devices after scan starts
      await _getConnectedDevices();
    } catch (e) {
      print("Error during discovery: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during device discovery: $e")),
      );
    }

    // Stop scanning after timeout and update UI
    Future.delayed(Duration(seconds: 20), () {
      if (mounted) {
        setState(() {
          isScanning = false;
        });
        print("Scan completed. Found ${devices.length} devices total.");
        if (devices.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "No devices found. Make sure your phone is discoverable in Bluetooth settings.",
              ),
              duration: Duration(seconds: 4),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Found ${devices.length} BLE devices. Most phones hide their names for privacy.",
              ),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    if (isConnecting) return;

    setState(() {
      isConnecting = true;
    });

    // Navigate to connecting page
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ConnectingPage()));

    try {
      // Connect to the device (flutter_blue_plus 2.1.0)
      await device.connect(
        timeout: const Duration(seconds: 15),
        mtu: null,
        license: License.free, // Required in flutter_blue_plus 2.1.0
      );

      // Listen to connection state
      device.connectionState.listen((BluetoothConnectionState state) {
        setState(() {
          connectionState = state;
        });

        if (state == BluetoothConnectionState.connected) {
          // Navigate to success page
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const ConnectionSuccessful(),
            ),
          );
        } else if (state == BluetoothConnectionState.disconnected &&
            isConnecting) {
          // Navigate to failed page if we were trying to connect
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ConnectionFailed()),
          );
        }
      });

      print("Connected to ${device.platformName}");
    } catch (e) {
      print("Connection failed: $e");
      // Navigate to failed page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ConnectionFailed()),
      );
    } finally {
      setState(() {
        isConnecting = false;
      });
    }
  }

  Widget _buildScanButton() {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 370,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: GestureDetector(
            onTap: _startDiscovery,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xFF1ACF68),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Scan for Devices",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanningIndicator() {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 370,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF1ACF68)),
              SizedBox(height: 12),
              Text(
                "Scanning for devices...",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1ACF68),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                    deviceNames: deviceNames,
                    selectedDevice: selectedDevice,
                    onDeviceSelected: (device) {
                      setState(() {
                        selectedDevice = device;
                      });
                    },
                    onRefreshPressed: _startDiscovery,
                    isScanning: isScanning,
                  ),
                // Show scan button when Bluetooth is enabled but no devices
                if (isBluetoothEnabled && devices.isEmpty && !isScanning)
                  _buildScanButton(),
                // Show scanning indicator
                if (isScanning) _buildScanningIndicator(),
                SizedBox(height: 20),
                // ConnectionSteps already uses elevated Material and step numbers
                ConnectionSteps(),
                SizedBox(height: 40),
                ConnectDevice(
                  selectedDevice: selectedDevice,
                  isEnabled: selectedDevice != null,
                  onConnect: _connectToDevice,
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
  final List<BluetoothDevice> devices;
  final Map<String, String> deviceNames;
  final BluetoothDevice? selectedDevice;
  final Function(BluetoothDevice) onDeviceSelected;
  final VoidCallback onRefreshPressed;
  final bool isScanning;

  const DeviceList({
    super.key,
    required this.devices,
    required this.deviceNames,
    required this.selectedDevice,
    required this.onDeviceSelected,
    required this.onRefreshPressed,
    required this.isScanning,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 370,
        constraints: BoxConstraints(maxHeight: 250),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 24,
                left: 18,
                bottom: 10,
                right: 18,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Available Devices",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  GestureDetector(
                    onTap: isScanning ? null : onRefreshPressed,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isScanning ? Colors.grey : Color(0xFF1ACF68),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isScanning ? Icons.hourglass_empty : Icons.refresh,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            isScanning ? "Scanning..." : "Scan",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];
                  final isSelected =
                      selectedDevice?.remoteId == device.remoteId;

                  return ListTile(
                    leading: Icon(
                      Icons.bluetooth,
                      color: isSelected ? Color(0xFF1ACF68) : Colors.grey,
                    ),
                    title: Text(
                      deviceNames[device.remoteId.str] ??
                          (device.platformName.isNotEmpty
                              ? device.platformName
                              : "Unknown Device"),
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.normal,
                        color: isSelected ? Color(0xFF1ACF68) : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      device.remoteId.toString(),
                      style: TextStyle(fontSize: 11),
                    ),
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
  final BluetoothDevice? selectedDevice;
  final bool isEnabled;
  final Function(BluetoothDevice)? onConnect;

  const ConnectDevice({
    super.key,
    this.selectedDevice,
    required this.isEnabled,
    this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: isEnabled && selectedDevice != null
            ? () {
                if (onConnect != null) {
                  onConnect!(selectedDevice!);
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
                  ? "Connect to ${selectedDevice!.platformName.isNotEmpty ? selectedDevice!.platformName : 'Device'}"
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
}
