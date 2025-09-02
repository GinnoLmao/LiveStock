import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class ScanningPage extends StatefulWidget {
  const ScanningPage({super.key});

  @override
  State<ScanningPage> createState() => _ScanningPageState();
}

class _ScanningPageState extends State<ScanningPage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    try {
      // Request storage permission
      PermissionStatus storageStatus = await Permission.storage.request();
      PermissionStatus photosStatus = await Permission.photos.request();

      bool permissionGranted =
          storageStatus.isGranted || photosStatus.isGranted;

      // For Android 13+, request specific media permission
      if (Platform.isAndroid) {
        PermissionStatus mediaStatus = await Permission.manageExternalStorage
            .request();
        permissionGranted = permissionGranted || mediaStatus.isGranted;
      }

      if (permissionGranted) {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80, // Compress image to 80% quality
        );

        if (image != null) {
          setState(() {
            _selectedImage = File(image.path);
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Image selected successfully!"),
              backgroundColor: Color(0xFF1ACF68),
              duration: Duration(seconds: 2),
            ),
          );

          print("Selected image path: ${image.path}");
        }
      } else {
        // Permission denied
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Gallery access permission is required to select images",
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: "Settings",
              textColor: Colors.white,
              onPressed: () => openAppSettings(),
            ),
          ),
        );
      }
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error selecting image: $e"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 85),
              Text(
                "Live Scanning",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 15),
              Text(
                "External device camera",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              Container(
                width: 370,
                height: 340,
                decoration: BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(15),
                  border: _selectedImage != null
                      ? Border.all(color: Color(0xFF1ACF68), width: 2)
                      : null,
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                          width: 370,
                          height: 340,
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 60,
                              color: Colors.grey[600],
                            ),
                            SizedBox(height: 10),
                            Text(
                              "No image selected",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Upload an image to scan",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              SizedBox(height: 40),
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
                      "Start Scanning",
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
                  border: Border.all(width: 1, color: Color(0xFF1ACF68)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: _pickImageFromGallery,
                  borderRadius: BorderRadius.circular(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload, color: Color(0xFF1ACF68), size: 28),
                      SizedBox(width: 4),
                      Text(
                        "Upload File",
                        style: TextStyle(
                          color: Color(0xFF1ACF68),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
