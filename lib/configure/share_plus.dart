import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

export 'package:share_plus/share_plus.dart';

class Sharer {
  static Future<ShareResult> shareFiles(
    List<XFile> files, {
    String? text,
    String? title,
    String? subject,
    XFile? previewThumbnail,
    Rect? sharePositionOrigin,
    List<String>? fileNameOverrides,
    bool downloadFallbackEnabled = true,
    bool mailToFallbackEnabled = true,
  }) async {
    return SharePlus.instance.share(
      ShareParams(
        files: files,
        text: text,
        title: title,
        subject: subject,
        previewThumbnail: previewThumbnail,
        sharePositionOrigin: sharePositionOrigin,
        downloadFallbackEnabled: downloadFallbackEnabled,
        mailToFallbackEnabled: mailToFallbackEnabled,
        fileNameOverrides: fileNameOverrides,
      ),
    );
  }

  static Future<ShareResult> shareUri(
    Uri uri, {
    String? title,
    String? subject,
    XFile? previewThumbnail,
    Rect? sharePositionOrigin,
    List<String>? fileNameOverrides,
    bool downloadFallbackEnabled = true,
    bool mailToFallbackEnabled = true,
  }) async {
    return SharePlus.instance.share(
      ShareParams(
        uri: uri,
        title: title,
        subject: subject,
        previewThumbnail: previewThumbnail,
        sharePositionOrigin: sharePositionOrigin,
        downloadFallbackEnabled: downloadFallbackEnabled,
        mailToFallbackEnabled: mailToFallbackEnabled,
        fileNameOverrides: fileNameOverrides,
      ),
    );
  }

  static Future<ShareResult> share(
    String text, {
    String? title,
    String? subject,
    XFile? previewThumbnail,
    Rect? sharePositionOrigin,
    List<String>? fileNameOverrides,
    bool downloadFallbackEnabled = true,
    bool mailToFallbackEnabled = true,
  }) async {
    return SharePlus.instance.share(
      ShareParams(
        text: text,
        title: title,
        subject: subject,
        previewThumbnail: previewThumbnail,
        sharePositionOrigin: sharePositionOrigin,
        downloadFallbackEnabled: downloadFallbackEnabled,
        mailToFallbackEnabled: mailToFallbackEnabled,
        fileNameOverrides: fileNameOverrides,
      ),
    );
  }
}
