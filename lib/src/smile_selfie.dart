import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:smile_selfie/smile_selfie.dart';
import 'package:smile_selfie/src/view/selfie_capture_view.dart';

class SmileSelfie {
  static List<CameraDescription> _cameras = [];
  factory SmileSelfie() {
    _instance ??= SmileSelfie._internal();
    return _instance!;
  }

  SmileSelfie._internal();

  static SmileSelfie? _instance;

  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (!_isInitialized && _cameras.isEmpty) {
      _cameras = await availableCameras();
      _isInitialized = true;
    }
  }

  static List<CameraDescription> get getCameras {
    if (!_isInitialized) {
      throw SelfieCaptureException('Plugin not initialized');
    } else if (_cameras.isEmpty) {
      throw SelfieCaptureException('No cameras found');
    }
    return _cameras;
  }

  static Future<String> captureSelfie(BuildContext context,
      {SmileSelfieOptions? smileSelfieOptions}) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelfieCaptureWidget(
                  smileSelfieOptions:
                      smileSelfieOptions ?? const SmileSelfieOptions(),
                )));

    return result.toString();
  }
}
