import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ImagePickerDialog extends StatefulWidget {
  final Function(List<XFile>?) onImageSelected;
  ImagePickerDialog({required this.onImageSelected});
  @override
  State<ImagePickerDialog> createState() => _ImagePickerDialogState();
}

class _ImagePickerDialogState extends State<ImagePickerDialog> {
  List<XFile>? _files;
  void _setImageFileListFromFile(XFile? value) {
    _files = value == null ? null : <XFile>[value];
  }
  dynamic _pickImageError;
  bool isVideo = false;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;
  String? _retrieveDataError;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Chọn ảnh"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () async {
              //final files = await _pickImage(ImageSource.gallery);
              await _onImageButtonPressed(ImageSource.gallery, context: context);
              widget.onImageSelected(_files);
              // Delay việc pop dialog để đảm bảo setState đã hoàn thành.
              Future.delayed(Duration.zero, () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              });
            },
            child: Text("Chọn từ thư viện ảnh"),
          ),
          ElevatedButton(
            onPressed: () async {
              _onImageButtonPressed(ImageSource.camera, context: context);
              widget.onImageSelected(_files);
              Navigator.of(context).pop(); // Đóng hộp thoại
            },
            child: Text("Chụp ảnh"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Đóng hộp thoại
          },
          child: Text("Hủy"),
        ),
      ],
    );
  }

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }
  Future<void> _playVideo(XFile? file) async {
    if (file != null && mounted) {
      await _disposeVideoController();
      late VideoPlayerController controller;
      if (kIsWeb) {
        // TODO(gabrielokura): remove the ignore once the following line can migrate to
        // use VideoPlayerController.networkUrl after the issue is resolved.
        // https://github.com/flutter/flutter/issues/121927
        // ignore: deprecated_member_use
        controller = VideoPlayerController.network(file.path);
      } else {
        controller = VideoPlayerController.file(File(file.path));
      }
      _controller = controller;
      // In web, most browsers won't honor a programmatic call to .play
      // if the video has a sound track (and is not muted).
      // Mute the video so it auto-plays in web!
      // This is not needed if the call to .play is the result of user
      // interaction (clicking on a "play" button, for example).
      const double volume = kIsWeb ? 0.0 : 1.0;
      await controller.setVolume(volume);
      await controller.initialize();
      await controller.setLooping(true);
      await controller.play();
      setState(() {});
    }
  }
  Future<void> _onImageButtonPressed(
      ImageSource source, {
        required BuildContext context,
        bool isMultiImage = false,
        bool isMedia = false,
      }) async {
    if (_controller != null) {
      await _controller!.setVolume(0.0);
    }
    if (context.mounted) {
      if (isVideo) {
        final XFile? file = await _picker.pickVideo(
            source: source, maxDuration: const Duration(seconds: 10));
        await _playVideo(file);
      } else if (isMultiImage) {
        await _displayPickImageDialog(context,
                (double? maxWidth, double? maxHeight, int? quality) async {
              try {
                final List<XFile> pickedFileList = isMedia
                    ? await _picker.pickMultipleMedia(
                  maxWidth: maxWidth,
                  maxHeight: maxHeight,
                  imageQuality: quality,
                )
                    : await _picker.pickMultiImage(
                  maxWidth: maxWidth,
                  maxHeight: maxHeight,
                  imageQuality: quality,
                );
                widget.onImageSelected(pickedFileList);
                setState(() {
                  _files = pickedFileList;
                });
              } catch (e) {
                setState(() {
                  _pickImageError = e;
                });
              }
            });
      } else if (isMedia) {
        await _displayPickImageDialog(context,
                (double? maxWidth, double? maxHeight, int? quality) async {
              try {
                final List<XFile> pickedFileList = <XFile>[];
                final XFile? media = await _picker.pickMedia(
                  maxWidth: maxWidth,
                  maxHeight: maxHeight,
                  imageQuality: quality,
                );
                if (media != null) {
                  pickedFileList.add(media);
                  widget.onImageSelected(pickedFileList);
                  setState(() {
                    _files = pickedFileList;
                  });
                }
              } catch (e) {
                setState(() {
                  _pickImageError = e;
                });
              }
            });
      } else {
        await _displayPickImageDialog(context,
                (double? maxWidth, double? maxHeight, int? quality) async {
              try {
                final XFile? pickedFile = await _picker.pickImage(
                  source: source,
                  maxWidth: maxWidth,
                  maxHeight: maxHeight,
                  imageQuality: quality,
                );
                setState(() {
                  _setImageFileListFromFile(pickedFile);
                });
              } catch (e) {
                setState(() {
                  _pickImageError = e;
                });
              }
            });
      }
    }
  }
  Future<void> _displayPickImageDialog(
      BuildContext context,
      void Function(double? maxWidth, double? maxHeight, int? quality) onPick
      ) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add optional parameters'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: maxWidthController,
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      hintText: 'Enter maxWidth if desired'),
                ),
                TextField(
                  controller: maxHeightController,
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      hintText: 'Enter maxHeight if desired'),
                ),
                TextField(
                  controller: qualityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Enter quality if desired'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('PICK'),
                  onPressed: () {
                    final double? width = maxWidthController.text.isNotEmpty
                        ? double.parse(maxWidthController.text)
                        : null;
                    final double? height = maxHeightController.text.isNotEmpty
                        ? double.parse(maxHeightController.text)
                        : null;
                    final int? quality = qualityController.text.isNotEmpty
                        ? int.parse(qualityController.text)
                        : null;
                    onPick(width, height, quality);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
}

