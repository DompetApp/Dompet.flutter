import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
export 'package:dompet/pages/scanner/controller.dart';
import 'package:dompet/pages/scanner/controller.dart';
import 'package:dompet/configure/permission_handler.dart';
import 'package:dompet/configure/image_picker.dart';
import 'package:dompet/routes/navigator.dart';
import 'package:dompet/extension/size.dart';
import 'package:dompet/models/channel.dart';

class PageScanner extends GetView<PageScannerController> {
  const PageScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final animation = controller.animation;
      final audioPlayer = controller.audioPlayer;
      final scanController = controller.scanController;
      final mediaQueryController = controller.mediaQueryController;
      final mediaPadding = mediaQueryController.padding.value;
      final mediaTopBar = mediaQueryController.topBar.value;

      final scanArea = Rect.fromCenter(
        center: MediaQuery.sizeOf(context).center(Offset.zero),
        height: 640.wmax * 248.sr,
        width: 640.wmax * 248.sr,
      );

      return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            MobileScanner(
              scanWindow: scanArea,
              controller: scanController,
              onDetectError: (error, stackTrace) {
                GetNavigate.back(
                  result: ChannelResult.failure(message: error.toString()),
                );
              },
              onDetect: (result) async {
                if (Get.currentRoute != GetRoutes.scanner) {
                  return;
                }

                try {
                  final source = AssetSource('medias/scanner.mp3');
                  await audioPlayer.play(source, volume: 0.5);
                } catch (e) {
                  /* e */
                }

                if (result.barcodes.isEmpty) {
                  GetNavigate.back(
                    result: ChannelResult.failure(
                      message: 'Scanned result unknown',
                    ),
                  );
                  return;
                }

                GetNavigate.back(
                  result: ChannelResult.success(
                    result: result.barcodes.first.rawValue ?? '',
                  ),
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: scanController,
              builder: (context, value, child) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    final top = scanArea.top;
                    final height = scanArea.height;
                    final scanLine = top + animation.value * height;

                    return CustomPaint(
                      painter: PageScanOverlay(
                        scanArea: scanArea,
                        scanLine: scanLine,
                      ),
                    );
                  },
                );
              },
            ),
            Positioned(
              top: max(mediaPadding.top, 640.wmax * 20.sr),
              left: 640.wmax * 20.sr,
              child: Container(
                alignment: Alignment.centerLeft,
                height: max(640.wmax * 40.sr, mediaTopBar),
                child: Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Image(
                        image: const AssetImage(
                          'lib/assets/images/scanner/back.png',
                        ),
                        height: 640.wmax * 36.sr,
                        width: 640.wmax * 36.sr,
                        fit: BoxFit.fill,
                      ),
                      onTap: () {
                        GetNavigate.back(
                          result: ChannelResult.failure(
                            message: 'Scanning has been canceled',
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: max(mediaPadding.top, 640.wmax * 20.sr),
              right: max(mediaPadding.right, 640.wmax * 20.sr),
              child: Container(
                alignment: Alignment.centerRight,
                height: max(640.wmax * 40.sr, mediaTopBar),
                child: buildAlbum(context),
              ),
            ),
            Positioned(
              bottom: max(mediaPadding.bottom, 640.wmax * 90.sr),
              child: Container(
                alignment: Alignment.centerRight,
                child: buildTorch(context),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xff000000),
      );
    });
  }

  Widget buildAlbum(BuildContext context) {
    return Obx(() {
      final audioPlayer = controller.audioPlayer;
      final scanController = controller.scanController;

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.all(640.wmax * 10.sr),
          child: Image(
            image: AssetImage('lib/assets/images/scanner/photo.png'),
            height: 640.wmax * 30.sr,
            width: 640.wmax * 36.sr,
          ),
        ),
        onTap: () async {
          final storage = await Permissioner.storage().catchError((_) => false);
          final photos = await Permissioner.photos().catchError((_) => false);

          if (Platform.isAndroid && !photos && !storage) {
            controller.showAlertDialog('Scanner_Photo_permission_request'.tr);
            return;
          }

          if (Platform.isIOS && !photos) {
            controller.showAlertDialog('Scanner_Photo_permission_request'.tr);
            return;
          }

          final file = await MediaPicker.pickImage(source: ImageSource.gallery);

          if (file == null) {
            return;
          }

          final analyze = scanController.analyzeImage;
          final formats = controller.scanBarcodeFormats;
          final result = await analyze(file.path, formats: formats);

          try {
            final source = AssetSource('medias/scanner.mp3');
            await audioPlayer.play(source, volume: 0.5);
          } catch (e) {
            /* e */
          }

          if (result == null || result.barcodes.isEmpty) {
            GetNavigate.back(
              result: ChannelResult.failure(message: 'Scanned result unknown'),
            );
            return;
          }

          GetNavigate.back(
            result: ChannelResult.success(
              result: result.barcodes.first.rawValue ?? '',
            ),
          );
        },
      );
    });
  }

  Widget buildTorch(BuildContext context) {
    return Obx(() {
      final torchOpened = controller.torchOpened;
      final scanController = controller.scanController;

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          child: Image(
            image: AssetImage(
              'lib/assets/images/scanner/${torchOpened.value ? 'torch_open' : 'torch_close'}.png',
            ),
            fit: BoxFit.fill,
            height: 640.wmax * 48.sr,
            width: 640.wmax * 36.sr,
          ),
        ),
        onTap: () {
          torchOpened.value = !torchOpened.value;
          scanController.toggleTorch();
        },
      );
    });
  }
}

class PageScanOverlay extends CustomPainter {
  const PageScanOverlay({
    required this.scanLine,
    required this.scanArea,
    this.cornerColor = const Color(0xFF4CAF50),
    this.scanLineColor = const Color(0xFF66BB6A),
  });

  final Rect scanArea;
  final double scanLine;
  final Color cornerColor;
  final Color scanLineColor;

  @override
  bool shouldRepaint(PageScanOverlay oldDelegate) {
    var repaint = false;
    repaint = repaint || scanArea != oldDelegate.scanArea;
    repaint = repaint || scanLine != oldDelegate.scanLine;
    repaint = repaint || cornerColor != oldDelegate.cornerColor;
    repaint = repaint || scanLineColor != oldDelegate.scanLineColor;
    return repaint;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // 1.
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRRect(RRect.fromRectAndCorners(scanArea)),
      ),

      Paint()
        ..color = const Color.fromRGBO(0, 0, 0, 0.45)
        ..blendMode = BlendMode.dstOut,
    );

    // 2.
    final corner = Paint();

    corner.strokeWidth = 1.6;
    corner.style = PaintingStyle.stroke;
    corner.color = cornerColor;

    canvas.drawPath(
      Path()
        ..moveTo(scanArea.left, scanArea.top + 20)
        ..lineTo(scanArea.left, scanArea.top)
        ..lineTo(scanArea.left + 20, scanArea.top),
      corner,
    );

    canvas.drawPath(
      Path()
        ..moveTo(scanArea.right - 20, scanArea.top)
        ..lineTo(scanArea.right, scanArea.top)
        ..lineTo(scanArea.right, scanArea.top + 20),
      corner,
    );

    canvas.drawPath(
      Path()
        ..moveTo(scanArea.right, scanArea.bottom - 20)
        ..lineTo(scanArea.right, scanArea.bottom)
        ..lineTo(scanArea.right - 20, scanArea.bottom),
      corner,
    );

    canvas.drawPath(
      Path()
        ..moveTo(scanArea.left + 20, scanArea.bottom)
        ..lineTo(scanArea.left, scanArea.bottom)
        ..lineTo(scanArea.left, scanArea.bottom - 20),
      corner,
    );

    // 3.
    final line = Paint();

    final recter = Rect.fromLTRB(
      scanArea.left,
      scanLine - 1,
      scanArea.right,
      scanLine + 1,
    );

    final gradient = LinearGradient(
      stops: const [0.01, 0.5, 0.99],
      colors: [
        Colors.transparent,
        scanLineColor.withValues(alpha: 0.9),
        Colors.transparent,
      ],
    );

    line.shader = gradient.createShader(recter);
    line.strokeWidth = 1.5;

    canvas.drawLine(
      Offset(scanArea.left, scanLine),
      Offset(scanArea.right, scanLine),
      line,
    );
  }
}
