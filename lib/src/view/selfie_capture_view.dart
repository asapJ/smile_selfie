import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:smile_selfie/smile_selfie.dart';
import 'dart:ui' as ui;

class SelfieCaptureWidget extends StatefulWidget {
  SelfieCaptureWidget({Key? key, required this.smileSelfieOptions})
      : assert(smileSelfieOptions.smileTreshold < 1.0,
            "Invalid Smile Treshold: ${smileSelfieOptions.smileTreshold}"),
        assert(smileSelfieOptions.eyesOpenTreshold < 1.0,
            "Invalid Eyes Open Treshold Treshold: ${smileSelfieOptions.smileTreshold}"),
        super(key: key);

  final SmileSelfieOptions smileSelfieOptions;

  @override
  State<SelfieCaptureWidget> createState() => _SelfieCaptureWidgetState();
}

class _SelfieCaptureWidgetState extends State<SelfieCaptureWidget> {
  CameraController? _controller;
  int _cameraIndex = 0;
  bool _isBusy = false;
  bool _cameraFound = false;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
    ),
  );

  List<CameraDescription> _cameras = [];

  void setup() {
    try {
      _cameras = SmileSelfie.getCameras;
      if (_cameras.any(
        (element) =>
            element.lensDirection == CameraLensDirection.front &&
            element.sensorOrientation == 90,
      )) {
        _cameraIndex = _cameras.indexOf(
          _cameras.firstWhere((element) =>
              element.lensDirection == CameraLensDirection.front &&
              element.sensorOrientation == 90),
        );
      } else {
        _cameraIndex = _cameras.indexOf(
          _cameras.firstWhere(
            (element) => element.lensDirection == CameraLensDirection.front,
          ),
        );
      }
      setState(() {
        _cameraFound = true;
      });
      _startLiveFeed();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  void dispose() {
    _stopLiveFeed();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const Padding(
            padding: EdgeInsets.all(24),
            child: SizedBox(
              height: 30,
            )),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: _liveFeed()),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              widget.smileSelfieOptions.title,
              textAlign: TextAlign.center,
            )
          ],
        ));
  }

  Widget _liveFeed() {
    if (_controller?.value.isInitialized == false || !_cameraFound) {
      return Container();
    }

    final size = MediaQuery.of(context).size;
    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * _controller!.value.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return ClipRRect(
      borderRadius:
          BorderRadius.circular(widget.smileSelfieOptions.imagePreviewSize * 2),
      child: Container(
        height: widget.smileSelfieOptions.imagePreviewSize,
        width: widget.smileSelfieOptions.imagePreviewSize,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
        child: Transform.scale(
          scale: scale,
          child: Center(
            child: CameraPreview(_controller!),
          ),
        ),
      ),
    );
  }

  Future _startLiveFeed() async {
    final camera = _cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    // await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final camera = _cameras[_cameraIndex];
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (imageRotation == null) return;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) return;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    await _processInpuImage(inputImage);
  }

  Future<void> _processInpuImage(InputImage inputImage) async {
    final imageData = inputImage;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {});
    final faces = await _faceDetector.processImage(imageData);

    if (faces.isNotEmpty) {
      if (faces.length > 1) {
        //multiple faces found
        _isBusy = false;
        return;
      } else {
        Face face = faces.first;
        double smile = face.smilingProbability ?? 0;
        double leftEyesOpen = face.leftEyeOpenProbability ?? 0;
        double rightEyesOpen = face.rightEyeOpenProbability ?? 0;
        if (smile >= widget.smileSelfieOptions.smileTreshold &&
            leftEyesOpen >= widget.smileSelfieOptions.eyesOpenTreshold &&
            rightEyesOpen >= widget.smileSelfieOptions.eyesOpenTreshold) {
          final file = await _takePicture();
          if (file != null) {
            Navigator.of(context).pop(file.path);
          }
          // return;
        }
      }
    }

    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<XFile?> _takePicture() async {
    final CameraController? cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      _controller?.stopImageStream();

      XFile file = await cameraController.takePicture();

      return file;
    } on CameraException catch (e) {
      _showCameraException(e);

      return null;
    }
  }

  void _showCameraException(CameraException e) {
    print('DATA  ${e.description}');
  }
}

class SelfieFoundView extends StatelessWidget {
  const SelfieFoundView({Key? key, required this.data}) : super(key: key);
  final String data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Image.file(File(data)));
  }

  static Future<ui.Image> bytesToImage(Uint8List imgBytes) async {
    ui.Codec codec = await ui.instantiateImageCodec(imgBytes);
    ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
  }
}
