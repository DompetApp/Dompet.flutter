// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:dompet/service/locale.dart';

String parse(Object? val, Function resolver, Locale locale) {
  if (val is DateTime) {
    try {
      final language = '${locale.languageCode}_${locale.countryCode}';
      final formater = resolver(language) as DateFormat;
      return formater.format(val);
    } catch (e) {
      return val.toString();
    }
  }

  if (val is String) {
    try {
      final language = '${locale.languageCode}_${locale.countryCode}';
      final formater = resolver(language) as DateFormat;
      final datetime = DateTime.parse(val);
      return formater.format(datetime);
    } catch (e) {
      return val;
    }
  }

  if (val is int) {
    const int minMilliseconds = -62135596800000; // 0001-01-01
    const int maxMilliseconds = 253402300799999; // 9999-12-31

    if (val <= minMilliseconds || val >= maxMilliseconds) {
      return '';
    }

    try {
      final formater = resolver(locale) as DateFormat;
      final datetime = DateTime.fromMillisecondsSinceEpoch(val);
      return formater.format(datetime);
    } catch (e) {
      return '';
    }
  }

  return '';
}

extension RawDateTimeExtension on DateTime? {
  static final locale = Get.find<LocaleController>().locale;

  String d() => parse(this, DateFormat.d, locale.value);
  String E() => parse(this, DateFormat.E, locale.value);
  String EEEE() => parse(this, DateFormat.EEEE, locale.value);
  String EEEEE() => parse(this, DateFormat.EEEEE, locale.value);
  String LLL() => parse(this, DateFormat.LLL, locale.value);
  String LLLL() => parse(this, DateFormat.LLLL, locale.value);
  String M() => parse(this, DateFormat.M, locale.value);
  String Md() => parse(this, DateFormat.Md, locale.value);
  String MEd() => parse(this, DateFormat.MEd, locale.value);
  String MMM() => parse(this, DateFormat.MMM, locale.value);
  String MMMd() => parse(this, DateFormat.MMMd, locale.value);
  String MMMEd() => parse(this, DateFormat.MMMEd, locale.value);
  String MMMM() => parse(this, DateFormat.MMMM, locale.value);
  String MMMMd() => parse(this, DateFormat.MMMMd, locale.value);
  String MMMMEEEEd() => parse(this, DateFormat.MMMMEEEEd, locale.value);
  String QQQ() => parse(this, DateFormat.QQQ, locale.value);
  String QQQQ() => parse(this, DateFormat.QQQQ, locale.value);
  String y() => parse(this, DateFormat.y, locale.value);
  String yM() => parse(this, DateFormat.yM, locale.value);
  String yMd() => parse(this, DateFormat.yMd, locale.value);
  String yMEd() => parse(this, DateFormat.yMEd, locale.value);
  String yMMM() => parse(this, DateFormat.yMMM, locale.value);
  String yMMMd() => parse(this, DateFormat.yMMMd, locale.value);
  String yMMMEd() => parse(this, DateFormat.yMMMEd, locale.value);
  String yMMMM() => parse(this, DateFormat.yMMMM, locale.value);
  String yMMMMd() => parse(this, DateFormat.yMMMMd, locale.value);
  String yMMMMEEEEd() => parse(this, DateFormat.yMMMMEEEEd, locale.value);
  String yQQQ() => parse(this, DateFormat.yQQQ, locale.value);
  String yQQQQ() => parse(this, DateFormat.yQQQQ, locale.value);
  String H() => parse(this, DateFormat.H, locale.value);
  String Hm() => parse(this, DateFormat.Hm, locale.value);
  String Hms() => parse(this, DateFormat.Hms, locale.value);
  String j() => parse(this, DateFormat.j, locale.value);
  String jm() => parse(this, DateFormat.jm, locale.value);
  String jms() => parse(this, DateFormat.jms, locale.value);
}

extension StringDateExtension on String? {
  static final locale = Get.find<LocaleController>().locale;

  String d() => parse(this, DateFormat.d, locale.value);
  String E() => parse(this, DateFormat.E, locale.value);
  String EEEE() => parse(this, DateFormat.EEEE, locale.value);
  String EEEEE() => parse(this, DateFormat.EEEEE, locale.value);
  String LLL() => parse(this, DateFormat.LLL, locale.value);
  String LLLL() => parse(this, DateFormat.LLLL, locale.value);
  String M() => parse(this, DateFormat.M, locale.value);
  String Md() => parse(this, DateFormat.Md, locale.value);
  String MEd() => parse(this, DateFormat.MEd, locale.value);
  String MMM() => parse(this, DateFormat.MMM, locale.value);
  String MMMd() => parse(this, DateFormat.MMMd, locale.value);
  String MMMEd() => parse(this, DateFormat.MMMEd, locale.value);
  String MMMM() => parse(this, DateFormat.MMMM, locale.value);
  String MMMMd() => parse(this, DateFormat.MMMMd, locale.value);
  String MMMMEEEEd() => parse(this, DateFormat.MMMMEEEEd, locale.value);
  String QQQ() => parse(this, DateFormat.QQQ, locale.value);
  String QQQQ() => parse(this, DateFormat.QQQQ, locale.value);
  String y() => parse(this, DateFormat.y, locale.value);
  String yM() => parse(this, DateFormat.yM, locale.value);
  String yMd() => parse(this, DateFormat.yMd, locale.value);
  String yMEd() => parse(this, DateFormat.yMEd, locale.value);
  String yMMM() => parse(this, DateFormat.yMMM, locale.value);
  String yMMMd() => parse(this, DateFormat.yMMMd, locale.value);
  String yMMMEd() => parse(this, DateFormat.yMMMEd, locale.value);
  String yMMMM() => parse(this, DateFormat.yMMMM, locale.value);
  String yMMMMd() => parse(this, DateFormat.yMMMMd, locale.value);
  String yMMMMEEEEd() => parse(this, DateFormat.yMMMMEEEEd, locale.value);
  String yQQQ() => parse(this, DateFormat.yQQQ, locale.value);
  String yQQQQ() => parse(this, DateFormat.yQQQQ, locale.value);
  String H() => parse(this, DateFormat.H, locale.value);
  String Hm() => parse(this, DateFormat.Hm, locale.value);
  String Hms() => parse(this, DateFormat.Hms, locale.value);
  String j() => parse(this, DateFormat.j, locale.value);
  String jm() => parse(this, DateFormat.jm, locale.value);
  String jms() => parse(this, DateFormat.jms, locale.value);
}

extension NumDateExtension on num? {
  static final locale = Get.find<LocaleController>().locale;

  String d() => parse(this, DateFormat.d, locale.value);
  String E() => parse(this, DateFormat.E, locale.value);
  String EEEE() => parse(this, DateFormat.EEEE, locale.value);
  String EEEEE() => parse(this, DateFormat.EEEEE, locale.value);
  String LLL() => parse(this, DateFormat.LLL, locale.value);
  String LLLL() => parse(this, DateFormat.LLLL, locale.value);
  String M() => parse(this, DateFormat.M, locale.value);
  String Md() => parse(this, DateFormat.Md, locale.value);
  String MEd() => parse(this, DateFormat.MEd, locale.value);
  String MMM() => parse(this, DateFormat.MMM, locale.value);
  String MMMd() => parse(this, DateFormat.MMMd, locale.value);
  String MMMEd() => parse(this, DateFormat.MMMEd, locale.value);
  String MMMM() => parse(this, DateFormat.MMMM, locale.value);
  String MMMMd() => parse(this, DateFormat.MMMMd, locale.value);
  String MMMMEEEEd() => parse(this, DateFormat.MMMMEEEEd, locale.value);
  String QQQ() => parse(this, DateFormat.QQQ, locale.value);
  String QQQQ() => parse(this, DateFormat.QQQQ, locale.value);
  String y() => parse(this, DateFormat.y, locale.value);
  String yM() => parse(this, DateFormat.yM, locale.value);
  String yMd() => parse(this, DateFormat.yMd, locale.value);
  String yMEd() => parse(this, DateFormat.yMEd, locale.value);
  String yMMM() => parse(this, DateFormat.yMMM, locale.value);
  String yMMMd() => parse(this, DateFormat.yMMMd, locale.value);
  String yMMMEd() => parse(this, DateFormat.yMMMEd, locale.value);
  String yMMMM() => parse(this, DateFormat.yMMMM, locale.value);
  String yMMMMd() => parse(this, DateFormat.yMMMMd, locale.value);
  String yMMMMEEEEd() => parse(this, DateFormat.yMMMMEEEEd, locale.value);
  String yQQQ() => parse(this, DateFormat.yQQQ, locale.value);
  String yQQQQ() => parse(this, DateFormat.yQQQQ, locale.value);
  String H() => parse(this, DateFormat.H, locale.value);
  String Hm() => parse(this, DateFormat.Hm, locale.value);
  String Hms() => parse(this, DateFormat.Hms, locale.value);
  String j() => parse(this, DateFormat.j, locale.value);
  String jm() => parse(this, DateFormat.jm, locale.value);
  String jms() => parse(this, DateFormat.jms, locale.value);
}
