import 'package:image_picker/image_picker.dart';
export 'package:image_picker/image_picker.dart';

class MediaPicker {
  static final ImagePicker imagePicker = ImagePicker();

  // 获取单个资源
  static Future<XFile?> pickMedia({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    bool requestFullMetadata = true,
  }) async {
    return imagePicker.pickMedia(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      requestFullMetadata: requestFullMetadata,
    );
  }

  // 获取多个资源
  static Future<List<XFile>> pickMultiMedia({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    int? limit,
    bool requestFullMetadata = true,
  }) async {
    return imagePicker.pickMultipleMedia(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      requestFullMetadata: requestFullMetadata,
      limit: limit,
    );
  }

  // 获取多张图片资源
  static Future<List<XFile>> pickMultiImage({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    return imagePicker.pickMultiImage(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
  }

  // 获取单张图片资源
  static Future<XFile?> pickImage({
    required ImageSource source,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    return imagePicker.pickImage(
      source: source,
      preferredCameraDevice: preferredCameraDevice,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
  }

  // 获取单个视频资源
  static Future<XFile?> pickVideo({
    required ImageSource source,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    Duration? maxDuration,
  }) async {
    return imagePicker.pickVideo(
      source: source,
      preferredCameraDevice: preferredCameraDevice,
      maxDuration: maxDuration,
    );
  }
}
