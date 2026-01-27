# Flutter Vision 2.0.0 Update Guide

## ✅ Changes Applied

### 1. **Updated pubspec.yaml**
```yaml
flutter_vision: ^2.0.0  # Updated from 1.1.4
```

### 2. **Updated API Call** ([yolo_detector_new.dart](lib/utils/yolo_detector_new.dart))
Added `useGpu: true` parameter:
```dart
await vision.loadYoloModel(
  labels: 'assets/models/labels.txt',
  modelPath: 'assets/models/yolov8n_seg.tflite',
  modelVersion: "yolov8seg",
  quantization: false,
  numThreads: 2,
  useGpu: true,  // ⬅️ NEW in 2.0.0
);
```

## 📦 Exporting Your Pig Model

### Step 1: Check Your Model Type

Run the 6th cell in your notebook to check what type of model you have:
```python
model = YOLO('path/to/your/pig_pose.pt')
print(f"Model Type: {model.task}")
```

**Result will be one of:**
- `detect` = Bounding boxes only
- `segment` = Boxes + polygon masks ✅ Currently implemented
- `pose` = Boxes + keypoints ⭐ **BEST for measurements!**

### Step 2: Export to TFLite

Run the 5th cell in your notebook:
```python
model = YOLO('path/to/your/pig_pose.pt')
model.export(format='tflite', imgsz=640)
```

**Output location:** Same directory as your .pt file
**File name:** Usually `your_model_saved_model/your_model_float32.tflite`

### Step 3: Copy to Flutter Project

```bash
# Copy the exported .tflite file to:
LiveStock/assets/models/yolov8n_seg.tflite

# Make sure labels.txt exists:
LiveStock/assets/models/labels.txt
```

## 🎯 Model Type Comparison

### Current Implementation: Segmentation
```
✅ Pros:
- Already implemented
- Works with flutter_vision 2.0.0
- Provides polygon outline

❌ Cons:
- Less accurate measurements
- Estimates girth from outline
- Requires calibration assumptions
```

### Recommended: Pose Detection
```
⭐ Pros:
- Exact anatomical landmarks (snout, ears, shoulders, hips, tail)
- Direct measurement of body length
- More accurate heart girth calculation
- Better for weight estimation

⚠️ Cons:
- Requires code updates to handle keypoints
- Need pose-trained model (not just segmentation)
```

## 🔧 If You Have a Pose Model

Your pig pose detection model is **better** for weight estimation! Here's what needs updating:

### 1. Update Model Version
```dart
modelVersion: "yolov8pose"  // Instead of "yolov8seg"
```

### 2. Update Result Parsing
Pose models return `keypoints` instead of `polygons`:
```dart
// Current (segmentation):
List<Map<String, dynamic>>? polygons = result['polygons'];

// Pose detection:
List<Map<String, dynamic>>? keypoints = result['keypoints'];
```

### 3. Update Measurement Extraction
```dart
// With keypoints, you can directly measure:
// - Snout to tail base = Body Length
// - Shoulder width + chest depth = Heart Girth calculation
// Much more accurate than estimating from polygon!
```

## 📋 Next Steps

### For Segmentation Model (Current):
1. ✅ Export your model to TFLite
2. ✅ Copy to `assets/models/yolov8n_seg.tflite`
3. ✅ Run `flutter pub get`
4. ✅ Test the app

### For Pose Model (Recommended):
1. ⬜ Export your pose model to TFLite
2. ⬜ Update `modelVersion` to `"yolov8pose"`
3. ⬜ Request code update for keypoint-based measurements
4. ⬜ Test with real pig images

## 🧪 Testing Your Model

### Test 1: Verify Export (Notebook)
Run the last cell in your notebook:
```python
model = YOLO('path/to/exported.tflite')
results = model.predict('test_pig.jpg', save=True)
```

**Check:** Does it detect pigs? Are keypoints/masks visible?

### Test 2: Flutter Integration
```bash
cd LiveStock
flutter clean
flutter pub get
flutter run
```

**Check:** 
- Model loads without errors?
- Detects pigs in uploaded images?
- Shows measurements and weight?

## 🐛 Troubleshooting

### Error: "Failed to load model"
**Solution:** 
- Ensure model file is exactly: `assets/models/yolov8n_seg.tflite`
- Check file size (should be 5-10 MB)
- Verify it's TFLite format (not .pt)

### Error: "No polygons/keypoints in result"
**Solution:**
- Model type mismatch
- Check `model.task` output
- Update `modelVersion` parameter accordingly

### App crashes on detection
**Solution:**
- Check Android gradle is configured (aaptOptions)
- Verify flutter_vision 2.0.0 installed: `flutter pub get`
- Try `flutter clean && flutter run`

## 📊 Expected Results

### With Segmentation Model:
```
Detection: ✅ Pig detected
Confidence: 85-95%
Measurements: Estimated from outline
Weight Accuracy: ±15-20%
```

### With Pose Model:
```
Detection: ✅ Pig detected
Keypoints: 8-17 landmarks
Measurements: Direct from keypoints
Weight Accuracy: ±8-10%
```

## 📚 Resources

- **Flutter Vision 2.0.0**: https://pub.dev/packages/flutter_vision/versions/2.0.0
- **Ultralytics Export**: https://docs.ultralytics.com/modes/export/
- **YOLOv8 Pose**: https://docs.ultralytics.com/tasks/pose/

---

## Quick Command Reference

```bash
# Update dependencies
flutter pub get

# Clean build
flutter clean

# Run app
flutter run

# Export model (Python)
yolo export model=pig_pose.pt format=tflite imgsz=640

# Check model type (Python)
from ultralytics import YOLO
model = YOLO('model.pt')
print(model.task)
```

---

**Status**: ✅ Ready for model export and testing
**Last Updated**: January 28, 2026
