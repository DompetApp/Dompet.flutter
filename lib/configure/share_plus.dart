import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

export 'package:share_plus/share_plus.dart';

class Sharer {
  static Future<ShareResult> shareFiles(
    List<XFile> files, {
    String? text,
    String? subject,
    List<String>? fileNameOverrides,
    Rect? sharePositionOrigin,
  }) async {
    return Share.shareXFiles(
      files,
      text: text,
      subject: subject,
      fileNameOverrides: fileNameOverrides,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  static Future<ShareResult> shareUri(Uri uri, {Rect? position}) async {
    return Share.shareUri(uri, sharePositionOrigin: position);
  }

  static Future<ShareResult> share(
    String text, {
    String? subject,
    Rect? position,
  }) async {
    assert(text.isNotEmpty);
    return Share.share(text, subject: subject, sharePositionOrigin: position);
  }
}
