# YOLO Model Files

To enable real-time livestock detection and weight estimation, you need to add the following files to this directory:

## Required Files:

1. **yolov8n.tflite** - The YOLOv8 nano model converted to TensorFlow Lite format
2. **labels.txt** - The class labels file containing livestock categories

## How to get the model files:

### Option 1: Use pre-trained COCO model (includes some livestock)
1. Download YOLOv8n model from: https://github.com/ultralytics/ultralytics
2. Convert to TensorFlow Lite format using:
   ```bash
   yolo export model=yolov8n.pt format=tflite
   ```

### Option 2: Use custom trained model (recommended)
1. Train a YOLOv8 model specifically on livestock images
2. Export to TensorFlow Lite format
3. Create custom labels.txt file

## Sample labels.txt for livestock:
```
cow
cattle
bull
pig
swine
sheep
lamb
goat
horse
chicken
duck
```

## Note:
Without these model files, the app will fall back to simulated weight computation.
The app will still work for demonstration purposes, but won't perform actual AI detection.

## Model Performance:
- File size should be under 10MB for mobile deployment
- YOLOv8n (nano) is recommended for mobile devices
- Consider quantization for better performance
dsadd
## Custom Training:
For best results with livestock, train the model on:
- Various livestock breeds
- Different lighting conditions
- Multiple camera angles
- Different farm environments
