import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:dompet/configure/permission_handler.dart';
import 'package:dompet/routes/navigator.dart';
import 'package:dompet/models/channel.dart';
import 'package:dompet/extension/size.dart';
import 'package:dompet/service/media.dart';

typedef TickerProvider = GetSingleTickerProviderStateMixin;

class PageScannerController extends GetxController with TickerProvider {
  late final Animation<double> animation;
  late final CurvedAnimation curvedAnimation;
  late final AnimationController animationController;

  late final mediaQueryController = Get.find<MediaQueryController>();

  late final scanBarcodeFormats = [
    BarcodeFormat.qrCode,
    BarcodeFormat.code128,
    BarcodeFormat.ean13,
    BarcodeFormat.ean8,
    BarcodeFormat.upcA,
    BarcodeFormat.upcE,
    BarcodeFormat.code39,
    BarcodeFormat.itf,
  ];

  late final scanController = MobileScannerController(
    formats: scanBarcodeFormats,
  );

  late final audioPlayer = AudioPlayer();

  Rx<bool> torchOpened = false.obs;

  @override
  void onInit() async {
    super.onInit();

    animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    );

    animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    audioPlayer.audioCache = AudioCache(prefix: 'lib/assets/');

    audioPlayer.setReleaseMode(ReleaseMode.release);

    animationController.repeat(reverse: true);

    if (!await Permissioner.camera()) {
      showAlertDialog('Scanner_Camera_permission_request'.tr);
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    scanController.dispose();
    audioPlayer.dispose();
    super.onClose();
  }

  // AlertDialog
  Future showAlertDialog(String message) {
    return showDialog(
      context: Get.context!,
      barrierColor: Color(0xff000000).withValues(alpha: 0.55),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: 100.vp, top: 20.vp),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          iconPadding: EdgeInsets.all(0),
          buttonPadding: EdgeInsets.only(
            top: 10.vp,
            left: 5.vp,
            right: 5.vp,
            bottom: 10.vp,
          ),
          contentPadding: EdgeInsets.only(
            top: 30.vp,
            left: 30.vp,
            right: 30.vp,
          ),
          actionsPadding: EdgeInsets.only(
            top: 14.vp,
            left: 20.vp,
            right: 20.vp,
            bottom: 8.vp,
          ),
          backgroundColor: Colors.white,
          content: Text(
            message,
            style: TextStyle(
              color: Color(0xff303133),
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              fontSize: 17.6.fp,
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.symmetric(horizontal: 7),
                minimumSize: Size(0, 44),
              ),
              child: Text(
                'System_Cancel'.tr,
                style: TextStyle(
                  color: Color(0xff606266),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                  fontSize: 15.fp,
                ),
              ),
              onPressed: () {
                GetNavigate.back(
                  result: ChannelResult.failure(
                    message: 'Camera or Album permissions not enabled',
                  ),
                );
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.symmetric(horizontal: 7),
                minimumSize: Size(0, 44),
              ),
              child: Text(
                'Scanner_Go_to_settings'.tr,
                style: TextStyle(
                  color: Color(0xff303133),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                  fontSize: 15.fp,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Permissioner.openSettings();
              },
            ),
          ],
        ),
      ),
    );
  }
}
