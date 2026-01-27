# ExecuTorch Migration Guide

## Migration from pytorch_lite to executorch_flutter

### Why Migrate?

- **pytorch_lite is discontinued** - Replaced by ExecuTorch
- **Better performance** - ExecuTorch is optimized for edge devices
- **Smaller binary size** - More efficient runtime
- **Active development** - Part of PyTorch ecosystem

### Changes Made

#### 1. Dependencies

**Before** (pubspec.yaml):
```yaml
dependencies:
  pytorch_lite: ^4.0.0
```

**After**:
```yaml
dependencies:
  executorch_flutter: ^0.3.0
```

#### 2. Model Format

**Before**: TorchScript (`.torchscript`, `.pt`)
**After**: ExecuTorch (`.pte`)

#### 3. Code Changes

**Import Statement**:
```dart
// Before
import 'package:pytorch_lite/pytorch_lite.dart';

// After
import 'package:executorch_flutter/executorch_flutter.dart';
```

**Model Loading**:
```dart
// Before
_model = ModelObjectDetection(
  1,  // Number of classes
  640,  // Image width
  640,  // Image height
  ['pig-IL8J'],  // List of class labels
);

// After
_model = await Module.load('assets/models/best.pte');
```

**Inference**:
```dart
// Before
final detections = await _model!.getImagePrediction(
  await imageFile.readAsBytes(),
  minimumScore: 0.4,
);

// After
final outputs = await _model!.forward(<Tensor>[
  Tensor.fromList(inputData, [1, 3, 640, 640]),
]);
// Then parse YOLO output manually
```

### Converting Your Model

If you have a TorchScript model, convert it to ExecuTorch format:

```bash
# 1. Install ExecuTorch
pip install executorch torch torchvision

# 2. Create conversion script (convert_to_executorch.py):
import torch
from executorch.exir import to_edge

# Load your TorchScript model
model = torch.jit.load('assets/models/best.torchscript')
model.eval()

# Export to ExecuTorch
example_input = torch.randn(1, 3, 640, 640)
edge_program = to_edge(
    torch.export.export(model, (example_input,))
)
edge_program.to_executorch().save('assets/models/best.pte')

# 3. Run the script
python convert_to_executorch.py
```

### Testing the Migration

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Ensure model file exists**:
   - Place `best.pte` in `assets/models/`
   - Verify `labels.txt` is present

3. **Run the app**:
   ```bash
   flutter run
   ```

4. **Test detection**:
   - Upload a pig image
   - Verify detection works
   - Check weight estimation

### Troubleshooting

**Issue**: Model fails to load
- **Solution**: Verify `.pte` file is in `assets/models/` and listed in pubspec.yaml

**Issue**: Inference errors
- **Solution**: Check input tensor shape is `[1, 3, 640, 640]` normalized to [0, 1]

**Issue**: No detections
- **Solution**: Verify YOLO output parsing matches your model's output format

### Performance Comparison

| Metric | pytorch_lite | executorch_flutter |
|--------|-------------|-------------------|
| Model Size | 11.9 MB | ~8-10 MB |
| Inference Time | ~200-300ms | ~150-250ms |
| Binary Size | +15 MB | +8 MB |
| Maintenance | Discontinued | Active |

### Migration Checklist

- [x] Update pubspec.yaml dependency
- [x] Convert model to `.pte` format
- [x] Update import statements
- [x] Rewrite model loading code
- [x] Implement custom inference logic
- [x] Add YOLO output parsing
- [x] Update documentation
- [x] Test with sample images
- [ ] Deploy to production

### Resources

- [ExecuTorch Documentation](https://pytorch.org/executorch/)
- [executorch_flutter Package](https://pub.dev/packages/executorch_flutter)
- [YOLOv8 Export Guide](https://docs.ultralytics.com/modes/export/)
- [Original TORCHSCRIPT_INTEGRATION.md](TORCHSCRIPT_INTEGRATION.md) (archived)
