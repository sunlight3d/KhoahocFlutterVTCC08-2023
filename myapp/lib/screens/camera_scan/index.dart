import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/constants/app_icons.dart';
import 'package:path_provider/path_provider.dart';

class CameraScan extends StatefulWidget {
  CameraScan({super.key});

  @override
  State<CameraScan> createState() => _CameraScanState();
}

class _CameraScanState extends State<CameraScan> {
  CameraController? controller;
  late List<CameraDescription> _cameras;
  bool _isAutomatic = false;

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
              (item) => item.lensDirection == CameraLensDirection.front,
        ).first;
        controller = CameraController(_selectedCamera, ResolutionPreset.max);
        controller?.initialize().then((_) {
          if (!mounted) {
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
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }

    final int cameraRotation = controller!.description.sensorOrientation!;
    final double rotationDegrees = cameraRotation.toDouble();
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            RotatedBox(
              quarterTurns: rotationDegrees ~/ 90,
              child: AspectRatio(
                aspectRatio: controller!.value.aspectRatio,
                child: CameraPreview(controller!),
              ),
            ),
            CustomPaint(
              size: Size(deviceWidth, deviceHeight),
              painter: OvalPainter(),
            ),
            Positioned(
              left: deviceWidth * 0.15,
              right: deviceWidth * 0.15,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite, size: 24, color: Colors.red),
                    ),
                    Text(
                      'Đưa mặt vào khung hình',
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Container(
                          child: SvgPicture.asset(
                            AppIcons.ICON_CLOSE,
                            colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                          ),
                          width: 30,
                          height: 30,
                        ),
                        onTap: () {
                          print("haha");
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Chụp ảnh chân dung',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Xử lý sự kiện khi người dùng bấm vào biểu tượng dấu hỏi
                        },
                        icon: Icon(
                          Icons.help_outline,
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ),
                  height: 50,
                ),
                Expanded(child: Container()),
                Container(
                  decoration: BoxDecoration(color: Colors.grey),
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: IconButton(
                                  onPressed: null,
                                  icon: Icon(Icons.favorite, size: 20, color: Colors.red),
                                ),
                              ),
                              Text(
                                'Flash',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          onTap: () {
                            print('Tap left');
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            try {
                              final image = await controller?.takePicture();
                              final appDir = await getApplicationDocumentsDirectory();
                              final fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
                              final newPath = '${appDir.path}/$fileName';
                              final File newImage = await File(image!.path).copy(newPath);
                              print('Ảnh đã chụp: ${image!.path}');
                            } catch (e) {
                              print('Lỗi chụp ảnh: $e');
                            }
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: FittedBox(
                                child: Switch(
                                  value: _isAutomatic,
                                  activeColor: Colors.white,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _isAutomatic = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Text(
                              'Chụp tự động',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    final redPaint = Paint()
      ..color = Colors.grey;

    final center = Offset(size.width / 2, size.height / 2);
    final radiusX = size.width / 2 - 0.9 * size.width;
    final radiusY = size.height / 2 - 0.9 * size.height;

    final path = Path()
      ..addOval(Rect.fromCenter(center: center, width: radiusX * 2, height: radiusY * 2));

    canvas.drawPath(path, strokePaint);

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        path,
      ),
      redPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
