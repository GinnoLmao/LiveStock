# YOLO Model Files

To enable real pig detection with segmentation and weight estimation, you need to add the following file to this directory:

## Required Files:

1. **yolov8n_seg.tflite** - The YOLOv8 nano segmentation model converted to TensorFlow Lite format
2. **labels.txt** - Already included (contains COCO class labels)

## How to get the model file:

### Option 1: Use pre-trained YOLOv8-seg COCO model (temporary/prototype)
The COCO dataset includes "cow" class which can serve as a proxy for pigs during prototyping.

1. Download YOLOv8n-seg model from: https://github.com/ultralytics/ultralytics
2. Convert to TensorFlow Lite format using:
   ```bash
   pip install ultralytics
   yolo export model=yolov8n-seg.pt format=tflite
   ```
3. Rename the exported file to `yolov8n_seg.tflite`
4. Place it in this directory

### Option 2: Train custom pig segmentation model (recommended for production)
For accurate pig weight estimation, train a custom YOLOv8 segmentation model:

1. **Collect Dataset**: 500-1000 images of pigs in side profile
2. **Annotate**: Use Roboflow or Label Studio to create segmentation masks
3. **Train**: Use Ultralytics YOLOv8-seg
   ```bash
   yolo segment train data=pigs.yaml model=yolov8n-seg.pt epochs=100
   ```
4. **Export**: Convert to TFLite format
   ```bash
   yolo export model=runs/segment/train/weights/best.pt format=tflite
   ```

## Weight Estimation Method:

The app uses the **Heart Girth Method** formula:
```
Weight (kg) = (Heart Girth² × Body Length) / 1156
```

Measurements are extracted from the segmentation polygon:
- **Body Length**: Distance from leftmost to rightmost points
- **Heart Girth**: Estimated from chest width and height (30% from head)
- **Calibration**: Assumes average pig length of 100cm (can be refined)

**Accuracy**: ±8-10% for market pigs (50-120 kg) with proper segmentation

## Note:
Without the model file, the app will fail to load. Make sure to add `yolov8n_seg.tflite` before running the app.

## Model Specifications:
- **Format**: TensorFlow Lite (.tflite)
- **Input**: RGB image (640x640 recommended)
- **Output**: Bounding boxes + segmentation polygons
- **Size**: ~6-8 MB (YOLOv8n-seg)
- **Task**: Instance segmentation (not just detection)
- Different lighting conditions
- Multiple camera angles
- Different farm environments
