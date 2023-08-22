import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScan extends StatefulWidget {
  CameraScan({super.key});

  @override
  State<CameraScan> createState() => _CameraScanState();
}

class _CameraScanState extends State<CameraScan> {
  CameraController? controller;
  late List<CameraDescription> _cameras;
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }
  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      setState(() {
        _cameras = cameras;
        CameraDescription _selectedCamera = _cameras.where(
                (item) => item.lensDirection == CameraLensDirection.front).first;
        controller = CameraController(_selectedCamera, ResolutionPreset.max);
        controller?.initialize().then((_) {
          if (!mounted) {
            int xx;
            return;
          }
          setState(() {
            //reload build function
          });
        });
      });
    } on CameraException catch (e) {
      if (e.code == 'CameraAccessDenied') {
        // Handle access errors here.
      } else {
        // Handle other errors here.
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(controller == null ) {
      return Container();
    }
    if(!controller!.value.isInitialized) {
      return Container();
    }
    // Xác định hướng hiển thị dựa trên sensorOrientation
    final int cameraRotation = controller!.description.sensorOrientation!;
    final double rotationDegrees = cameraRotation.toDouble();
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              RotatedBox(
                quarterTurns: rotationDegrees ~/ 90, // Xác định số lần quay hình ảnh
                child: AspectRatio(
                  aspectRatio: controller!.value.aspectRatio,
                  child: CameraPreview(controller!),
                ),
              ),
              /*
              Opacity(
                opacity: 0.5, // Độ mờ của hình oval
                child: Container(
                  width: 200,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.black,
                  ),
                ),
              ),
              */
              CustomPaint(
                size: Size(deviceWidth - 20, deviceHeight - 30), // Kích thước của hình vẽ
                painter: OvalPainter(), // Sử dụng OvalPainter để vẽ
              )
            ],
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}
class OvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = Colors.white // Màu viền trắng
      ..strokeWidth = 5.0 // Độ dày viền
      ..style = PaintingStyle.stroke; // Loại của viền

    final redPaint = Paint()
      ..color = Colors.red; // Màu đỏ

    final center = Offset(size.width / 2, size.height / 2); // Tọa độ tâm của hình oval
    final radiusX = size.width / 2; // Bán kính theo trục X
    final radiusY = size.height / 2; // Bán kính theo trục Y

    // Vẽ hình oval rỗng với viền trắng và màu đỏ phía bên ngoài
    canvas.drawOval(Rect.fromCenter(center: center, width: radiusX * 2, height: radiusY * 2), strokePaint);
    //canvas.drawOval(Rect.fromCenter(center: center, width: radiusX * 2, height: radiusY * 2), redPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

