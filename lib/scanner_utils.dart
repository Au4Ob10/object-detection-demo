// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.



import 'dart:async';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_ml_vision/google_ml_vision.dart';

class ScannerUtils {
  ScannerUtils._();

  static Future<CameraDescription> getCamera(CameraLensDirection dir) async {
    return availableCameras().then(
      (List<CameraDescription> cameras) => cameras.firstWhere(
        (CameraDescription camera) => camera.lensDirection == dir,
      ),
    );
  }

  static Future<dynamic> detect({
   required CameraImage? image,
   required Future<dynamic> Function(GoogleVisionImage image) detectInImage,
   required int? imageRotation,
  }) async { 
    
    return detectInImage(
      GoogleVisionImage.fromBytes(
        _concatenatePlanes(image!.planes),
        _buildMetaData (image, _rotationIntToImageRotation(imageRotation!))
    )
    );
  }

  static Uint8List _concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    for (var plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  static GoogleVisionImageMetadata _buildMetaData(
    CameraImage image,
    ImageRotation? rotation,
  ) {
    return GoogleVisionImageMetadata(
      rawFormat: image.format.raw,
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation!,
      planeData: image.planes.map(
        (Plane plane) {
          return GoogleVisionImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList(),
    );
  }

  static ImageRotation? _rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 0:
        return ImageRotation.rotation0;
      case 90:
        return ImageRotation.rotation90;
      case 180:
        return ImageRotation.rotation180;
      default:
        assert(rotation == 270);
        return ImageRotation.rotation270;
    }
  }
}
