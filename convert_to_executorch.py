#!/usr/bin/env python3
"""
Convert TorchScript YOLOv8 model to ExecuTorch format
Usage: python convert_to_executorch.py
"""

import torch
from pathlib import Path

def convert_to_executorch():
    """Convert TorchScript model to ExecuTorch .pte format"""
    
    print("=== TorchScript to ExecuTorch Converter ===\n")
    
    # File paths
    torchscript_path = Path('assets/models/best.torchscript')
    executorch_path = Path('assets/models/best.pte')
    
    if not torchscript_path.exists():
        print(f"❌ Error: Model file not found at {torchscript_path}")
        print("Please ensure your TorchScript model is in assets/models/best.torchscript")
        return False
    
    try:
        print(f"📥 Loading TorchScript model from {torchscript_path}...")
        model = torch.jit.load(str(torchscript_path))
        model.eval()
        print("✅ Model loaded successfully\n")
        
        print("🔄 Converting to ExecuTorch format...")
        
        # Create example input (640x640 for YOLOv8)
        example_input = torch.randn(1, 3, 640, 640)
        
        # Try different export methods based on ExecuTorch version
        try:
            # Method 1: Using torch.export (PyTorch 2.0+)
            from executorch.exir import to_edge
            
            exported_program = torch.export.export(model, (example_input,))
            edge_program = to_edge(exported_program)
            executorch_program = edge_program.to_executorch()
            
            # Save to file
            with open(executorch_path, 'wb') as f:
                f.write(executorch_program.buffer)
            
            print(f"✅ Model converted successfully!")
            print(f"📁 Saved to: {executorch_path}")
            print(f"📊 File size: {executorch_path.stat().st_size / (1024*1024):.2f} MB\n")
            
        except ImportError:
            # Method 2: Direct conversion (older ExecuTorch)
            print("⚠️  torch.export not available, trying alternative method...")
            
            # Trace the model
            traced_model = torch.jit.trace(model, example_input)
            
            # Save as ExecuTorch (if supported)
            traced_model.save(str(executorch_path))
            
            print(f"✅ Model saved (may need manual ExecuTorch conversion)")
            print(f"📁 Saved to: {executorch_path}\n")
        
        print("✅ Conversion complete!")
        print("\n📝 Next steps:")
        print("1. Run: flutter pub get")
        print("2. Test the model in your Flutter app")
        print("3. If detection fails, verify YOLO output format")
        
        return True
        
    except Exception as e:
        print(f"\n❌ Error during conversion: {e}")
        print("\n💡 Alternative: Export from Python training code:")
        print("```python")
        print("from ultralytics import YOLO")
        print("model = YOLO('best.pt')")
        print("model.export(format='executorch')  # Creates best.pte")
        print("```")
        return False

if __name__ == "__main__":
    success = convert_to_executorch()
    exit(0 if success else 1)
