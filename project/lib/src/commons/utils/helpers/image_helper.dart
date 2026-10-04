import 'dart:ui' as ui;
import 'package:flutter/services.dart';

abstract class ImageHelper {
  // Method that gets the bytes from an asset.
  static Future<Uint8List> getBytesFromAsset({ required String path, int? width }) async {
    ByteData data = await rootBundle.load(path);

    if (width == null) {
      return data.buffer.asUint8List();
    }

    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  // Method that gets the bytes from an image in bytes.
  static Future<Uint8List> getBytesFromImageBytes({ required List<int> bytes, required int width }) async {
    ui.Codec codec = await ui.instantiateImageCodec(Uint8List.fromList(bytes), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }
}