import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
export 'package:image_picker/image_picker.dart';

class MediaPicker {
  static final ImagePicker imagePicker = ImagePicker();

  // 获取单个资源
  static Future<Uint8List?> pickMedia({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    bool requestFullMetadata = true,
  }) async {
    final media = await imagePicker.pickMedia(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      requestFullMetadata: requestFullMetadata,
    );

    return media?.readAsBytes();
  }

  // 获取多个资源
  static Future<List<Uint8List>> pickMultiMedia({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    int? limit,
    bool requestFullMetadata = true,
  }) async {
    final medias = await imagePicker.pickMultipleMedia(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      requestFullMetadata: requestFullMetadata,
      limit: limit,
    );

    return await Future.wait(medias.map((image) => image.readAsBytes()));
  }

  // 获取多张图片资源
  static Future<List<Uint8List>> pickMultiImage({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    final images = await imagePicker.pickMultiImage(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );

    return await Future.wait(images.map((image) => image.readAsBytes()));
  }

  // 获取单张图片资源
  static Future<Uint8List?> pickImage({
    required ImageSource source,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    final image = await imagePicker.pickImage(
      source: source,
      preferredCameraDevice: preferredCameraDevice,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );

    return image?.readAsBytes();
  }

  // 获取单个视频资源
  static Future<Uint8List?> pickVideo({
    required ImageSource source,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    Duration? maxDuration,
  }) async {
    final video = await imagePicker.pickVideo(
      source: source,
      preferredCameraDevice: preferredCameraDevice,
      maxDuration: maxDuration,
    );

    return video?.readAsBytes();
  }
}
