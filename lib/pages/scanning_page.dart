import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'scanning_page1.dart';
import 'scanning_page1fail.dart';

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

  Future<void> _computeWeight() async {
    if (_selectedImage == null) {
      // Show error if no image is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select an image first"),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Text("Computing weight..."),
            ],
          ),
          backgroundColor: Color(0xFF1ACF68),
          duration: Duration(seconds: 3),
        ),
      );

      // Simulate computation delay
      await Future.delayed(Duration(seconds: 2));

      // TODO: Implement actual weight computation logic here
      // For now, we'll simulate success/failure randomly
      bool computationSuccess = DateTime.now().millisecond % 2 == 0;

      if (computationSuccess) {
        // Navigate to success page with computed weight
        double computedWeight =
            85.5 + (DateTime.now().millisecond % 20); // Simulated weight
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScanningPage1(
              computedWeight: computedWeight,
              imagePath: _selectedImage?.path,
            ),
          ),
        );
      } else {
        // Navigate to failure page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScanningPage1Fail(
              errorMessage:
                  "Unable to detect livestock in the image. Please try with a clearer photo.",
              imagePath: _selectedImage?.path,
            ),
          ),
        );
      }
    } catch (e) {
      // Handle computation errors
      print("Error during weight computation: $e");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanningPage1Fail(
            errorMessage: "Computation failed: $e",
            imagePath: _selectedImage?.path,
          ),
        ),
      );
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
              // Show different button based on whether image is selected
              _selectedImage == null
                  ? Container(
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
                            Icon(
                              Icons.upload,
                              color: Color(0xFF1ACF68),
                              size: 28,
                            ),
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
                    )
                  : Container(
                      width: 370,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1, color: Color(0xFF1ACF68)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: _computeWeight,
                        borderRadius: BorderRadius.circular(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.straighten,
                              color: Color(0xFF1ACF68),
                              size: 28,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Compute Weight",
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
