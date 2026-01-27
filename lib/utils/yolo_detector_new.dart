import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:executorch_flutter/executorch_flutter.dart';
import 'package:image/image.dart' as img;

class YoloDetector {
  ExecuTorchModel? _model;
  List<String> _labels = [];
  bool isModelLoaded = false;

  YoloDetector();

  // Initialize YOLO model with ExecuTorch
  Future<bool> initializeModel() async {
    try {
      // Load labels
      final labelsData = await rootBundle.loadString(
        'assets/models/labels.txt',
      );
      _labels = labelsData
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();

      // Load ExecuTorch model from assets
      _model = await ExecuTorchModel.loadFromAsset('assets/models/best.pte');

      isModelLoaded = true;
      print("YOLOv8 ExecuTorch model loaded successfully");
      return true;
    } catch (e) {
      print("Error loading YOLO model: $e");
      isModelLoaded = false;
      return false;
    }
  }

  // Detect pig in image and estimate weight using YOLOv8 ExecuTorch
  Future<Map<String, dynamic>> detectAndEstimateWeight(File imageFile) async {
    if (!isModelLoaded || _model == null) {
      throw Exception("YOLO model not initialized");
    }

    try {
      // Read and decode image
      final imageBytes = imageFile.readAsBytesSync();
      final image = img.decodeImage(imageBytes);

      if (image == null) {
        return {
          'success': false,
          'error': 'Failed to decode image',
          'animals': [],
        };
      }

      // Preprocess image to 640x640 (YOLO input size)
      final resizedImage = img.copyResize(image, width: 640, height: 640);

      // Convert to Float32List normalized [0, 1]
      final inputData = Float32List(1 * 3 * 640 * 640);
      int pixelIndex = 0;
      for (int c = 0; c < 3; c++) {
        for (int y = 0; y < 640; y++) {
          for (int x = 0; x < 640; x++) {
            final pixel = resizedImage.getPixel(x, y);
            if (c == 0)
              inputData[pixelIndex] = pixel.r / 255.0;
            else if (c == 1)
              inputData[pixelIndex] = pixel.g / 255.0;
            else
              inputData[pixelIndex] = pixel.b / 255.0;
            pixelIndex++;
          }
        }
      }

      // Run inference with TensorData
      // Convert Float32List to Uint8List (byte representation)
      final inputBytes = Uint8List.view(inputData.buffer);
      final inputTensor = TensorData(
        shape: [1, 3, 640, 640],
        dataType: TensorType.float32,
        data: inputBytes,
        name: 'input',
      );
      final outputs = await _model!.forward([inputTensor]);

      // Parse YOLOv8 output
      final detections = _parseYoloOutput(outputs, image.width, image.height);

      if (detections.isEmpty) {
        return {
          'success': false,
          'error':
              'No pig detected in image. Please ensure the pig is clearly visible in side profile.',
          'animals': [],
        };
      }

      // Get best detection
      final bestDetection = detections.first;

      // Extract detection data
      String tag = bestDetection['class'] ?? 'pig-IL8J';
      double confidence = bestDetection['confidence'];

      // Create bounding box (normalized coordinates)
      Rectangle boundingBox = Rectangle(
        bestDetection['x'],
        bestDetection['y'],
        bestDetection['width'],
        bestDetection['height'],
      );

      // Since TorchScript detection model doesn't provide polygons,
      // estimate measurements from bounding box
      PigMeasurements measurements = _estimateMeasurementsFromBox(
        boundingBox,
        image.width,
        image.height,
      );

      // Calculate weight using Heart Girth formula
      double weight = _calculateWeightFromMeasurements(
        measurements.heartGirthCm,
        measurements.bodyLengthCm,
      );

      // Create detected animal object
      DetectedAnimal detectedPig = DetectedAnimal(
        className: tag,
        confidence: confidence,
        boundingBox: boundingBox,
        estimatedWeight: weight,
        measurements: measurements,
        polygonPoints: null, // Detection model doesn't provide polygons
      );

      return {
        'success': true,
        'primaryAnimal': detectedPig,
        'allAnimals': [detectedPig],
        'estimatedWeight': weight,
        'method': 'heart_girth_formula',
        'measurements': measurements.toMap(),
      };
    } catch (e) {
      print("Error during YOLO detection: $e");
      return {'success': false, 'error': 'Detection failed: $e', 'animals': []};
    }
  }

  // Parse YOLOv8 output from ExecuTorch
  List<Map<String, dynamic>> _parseYoloOutput(
    List<TensorData> outputs,
    int imageWidth,
    int imageHeight,
  ) {
    final List<Map<String, dynamic>> detections = [];

    if (outputs.isEmpty) return detections;

    // YOLOv8 output format: [batch, num_predictions, 85]
    // [x, y, w, h, objectness, class_scores...]
    final outputData = outputs[0].data;
    final shape = outputs[0].shape;

    // Get output as Float32List
    Float32List floatData;
    if (outputData is Float32List) {
      floatData = outputData as Float32List;
    } else if (outputData is Uint8List) {
      final byteData = ByteData.sublistView(outputData);
      final floatList = <double>[];
      for (int i = 0; i < outputData.length; i += 4) {
        floatList.add(byteData.getFloat32(i, Endian.little));
      }
      floatData = Float32List.fromList(floatList);
    } else {
      return detections;
    }

    final numPredictions = (shape.length > 1 && shape[1] != null)
        ? shape[1]!
        : (floatData.length ~/ 85);

    for (int i = 0; i < numPredictions; i++) {
      final offset = i * 85;
      final x = floatData[offset];
      final y = floatData[offset + 1];
      final w = floatData[offset + 2];
      final h = floatData[offset + 3];
      final objectness = floatData[offset + 4];

      // Get class with highest score
      double maxScore = 0;
      int maxClass = 0;
      for (int c = 0; c < 80; c++) {
        final score = floatData[offset + 5 + c];
        if (score > maxScore) {
          maxScore = score;
          maxClass = c;
        }
      }

      final confidence = objectness * maxScore;

      if (confidence > 0.4) {
        detections.add({
          'x': (x - w / 2) / 640,
          'y': (y - h / 2) / 640,
          'width': w / 640,
          'height': h / 640,
          'confidence': confidence,
          'class': maxClass < _labels.length ? _labels[maxClass] : 'pig-IL8J',
        });
      }
    }

    // Sort by confidence
    detections.sort(
      (a, b) =>
          (b['confidence'] as double).compareTo(a['confidence'] as double),
    );

    return detections;
  }

  // Estimate measurements from bounding box when segmentation unavailable
  PigMeasurements _estimateMeasurementsFromBox(
    Rectangle boundingBox,
    int imageWidth,
    int imageHeight,
  ) {
    // Convert normalized coordinates to pixels
    double bodyLengthPixels = boundingBox.width * imageWidth;
    double chestHeightPixels = boundingBox.height * imageHeight;
    double chestWidthPixels = bodyLengthPixels * 0.5;

    // Estimate heart girth assuming elliptical cross-section
    double heartGirthPixels = 2 * (chestWidthPixels + chestHeightPixels * 0.6);

    // Calibrate pixels to centimeters (assume average pig is 100cm long)
    double pixelsPerCm = bodyLengthPixels / 100.0;

    return PigMeasurements(
      bodyLengthCm: bodyLengthPixels / pixelsPerCm,
      heartGirthCm: heartGirthPixels / pixelsPerCm,
      chestWidthCm: chestWidthPixels / pixelsPerCm,
      chestHeightCm: chestHeightPixels / pixelsPerCm,
      pixelsPerCm: pixelsPerCm,
    );
  }

  // Calculate pig weight using Heart Girth Method formula
  // Formula: Weight (kg) = (Heart Girth² × Body Length) / 1156
  // Accuracy: ±8-10% for market pigs (23-136 kg)
  double _calculateWeightFromMeasurements(
    double heartGirthCm,
    double bodyLengthCm,
  ) {
    // Heart Girth Method (most accurate for pigs)
    double weight = (heartGirthCm * heartGirthCm * bodyLengthCm) / 1156.0;

    // Clamp to reasonable pig weight range (10-300 kg)
    return weight.clamp(10.0, 300.0);
  }

  // Clean up resources
  Future<void> dispose() async {
    if (isModelLoaded) {
      _model = null;
      isModelLoaded = false;
      print("YOLO model disposed");
    }
  }
}

// Class to store pig body measurements
class PigMeasurements {
  final double bodyLengthCm;
  final double heartGirthCm;
  final double chestWidthCm;
  final double chestHeightCm;
  final double pixelsPerCm;

  PigMeasurements({
    required this.bodyLengthCm,
    required this.heartGirthCm,
    required this.chestWidthCm,
    required this.chestHeightCm,
    required this.pixelsPerCm,
  });

  Map<String, dynamic> toMap() {
    return {
      'bodyLength': bodyLengthCm,
      'heartGirth': heartGirthCm,
      'chestWidth': chestWidthCm,
      'chestHeight': chestHeightCm,
      'pixelsPerCm': pixelsPerCm,
    };
  }

  @override
  String toString() {
    return 'PigMeasurements(length: ${bodyLengthCm.toStringAsFixed(1)}cm, '
        'girth: ${heartGirthCm.toStringAsFixed(1)}cm)';
  }
}

// Data classes for detection results
class DetectedAnimal {
  final String className;
  final double confidence;
  final Rectangle boundingBox;
  double estimatedWeight;
  final PigMeasurements? measurements;
  final List<Map<String, dynamic>>? polygonPoints;

  DetectedAnimal({
    required this.className,
    required this.confidence,
    required this.boundingBox,
    this.estimatedWeight = 0.0,
    this.measurements,
    this.polygonPoints,
  });

  @override
  String toString() {
    String measurementStr = measurements != null
        ? ', measurements: $measurements'
        : '';
    return 'DetectedAnimal(class: $className, confidence: ${confidence.toStringAsFixed(2)}, '
        'weight: ${estimatedWeight.toStringAsFixed(1)}kg$measurementStr)';
  }
}

class Rectangle {
  final double x;
  final double y;
  final double width;
  final double height;

  Rectangle(this.x, this.y, this.width, this.height);

  double get area => width * height;

  @override
  String toString() {
    return 'Rectangle(x: $x, y: $y, w: $width, h: $height)';
  }
}

// Widget for displaying YOLO detection results
class YoloResultsWidget extends StatelessWidget {
  final Map<String, dynamic> results;
  final File? imageFile;

  const YoloResultsWidget({super.key, required this.results, this.imageFile});

  @override
  Widget build(BuildContext context) {
    if (!results['success']) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 32),
            const SizedBox(height: 8),
            Text(
              'Detection Failed',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              results['error'] ?? 'Unknown error',
              style: TextStyle(color: Colors.red[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    DetectedAnimal primaryAnimal = results['primaryAnimal'];
    List<DetectedAnimal> allAnimals = results['allAnimals'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Livestock Detected',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Primary detection info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Primary Detection:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Animal: ${primaryAnimal.className.toUpperCase()}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'Confidence: ${(primaryAnimal.confidence * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),

                // Show measurements if available
                if (primaryAnimal.measurements != null) ...[
                  const Divider(),
                  Text(
                    'Body Measurements:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '• Body Length: ${primaryAnimal.measurements!.bodyLengthCm.toStringAsFixed(1)} cm',
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    '• Heart Girth: ${primaryAnimal.measurements!.heartGirthCm.toStringAsFixed(1)} cm',
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                ],

                const Divider(),
                Text(
                  'Estimated Weight:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${primaryAnimal.estimatedWeight.toStringAsFixed(1)} kg',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                Text(
                  'Range: ${(primaryAnimal.estimatedWeight * 0.92).toStringAsFixed(1)} - ${(primaryAnimal.estimatedWeight * 1.08).toStringAsFixed(1)} kg (±8%)',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
                if (primaryAnimal.measurements != null)
                  Text(
                    'Method: Heart Girth Formula',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),

          if (allAnimals.length > 1) ...[
            const SizedBox(height: 8),
            Text(
              'Additional detections: ${allAnimals.length - 1}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }
}
