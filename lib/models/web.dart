import 'dart:math';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';

class WebviewKey extends ValueKey<String> {
  const WebviewKey(super.value);
}

class RxWebviewMeta {
  static String uuid() {
    return hex.encode(
      md5.convert(utf8.encode(Random().nextDouble().toString())).bytes,
    );
  }

  Rx<String> key;
  Rx<String> url;
  Rx<String> html;
  Rx<String> title;
  Rx<Map<String, dynamic>> query;
  Rx<bool> checkHttps;
  Rx<bool> checkUrl;
  Rx<bool> fromHtml;
  Rx<bool> fromUrl;
  Rx<bool> loading;
  Rx<bool> popup;

  RxWebviewMeta(WebviewMeta webviewMeta)
    : key = webviewMeta.key.obs,
      url = webviewMeta.url.obs,
      html = webviewMeta.html.obs,
      title = webviewMeta.title.obs,
      query = Rx(webviewMeta.query),
      checkHttps = webviewMeta.checkHttps.obs,
      checkUrl = webviewMeta.checkUrl.obs,
      fromHtml = webviewMeta.fromHtml.obs,
      fromUrl = webviewMeta.fromUrl.obs,
      loading = webviewMeta.loading.obs,
      popup = webviewMeta.popup.obs;

  WebviewMeta get value {
    return WebviewMeta(
      key: key.value,
      url: url.value,
      html: html.value,
      title: title.value,
      query: Map.from(query.value),
      checkHttps: checkHttps.value,
      checkUrl: checkUrl.value,
      fromHtml: fromHtml.value,
      fromUrl: fromUrl.value,
      loading: loading.value,
      popup: popup.value,
    );
  }

  RxWebviewMeta clone({dynamic webviewMeta}) {
    if (webviewMeta is RxWebviewMeta) {
      return RxWebviewMeta(
        WebviewMeta(
          key: webviewMeta.key.value,
          url: webviewMeta.url.value,
          html: webviewMeta.html.value,
          title: webviewMeta.title.value,
          query: Map.from(webviewMeta.query.value),
          checkHttps: webviewMeta.checkHttps.value,
          checkUrl: webviewMeta.checkUrl.value,
          fromHtml: webviewMeta.fromHtml.value,
          fromUrl: webviewMeta.fromUrl.value,
          loading: webviewMeta.loading.value,
          popup: webviewMeta.popup.value,
        ),
      );
    }

    if (webviewMeta is WebviewMeta) {
      return RxWebviewMeta(
        WebviewMeta(
          key: webviewMeta.key,
          url: webviewMeta.url,
          html: webviewMeta.html,
          title: webviewMeta.title,
          query: Map.from(webviewMeta.query),
          checkHttps: webviewMeta.checkHttps,
          checkUrl: webviewMeta.checkUrl,
          fromHtml: webviewMeta.fromHtml,
          fromUrl: webviewMeta.fromUrl,
          loading: webviewMeta.loading,
          popup: webviewMeta.popup,
        ),
      );
    }

    return RxWebviewMeta(
      WebviewMeta(
        key: key.value,
        url: url.value,
        html: html.value,
        title: title.value,
        query: Map.from(query.value),
        checkHttps: checkHttps.value,
        checkUrl: checkUrl.value,
        fromHtml: fromHtml.value,
        fromUrl: fromUrl.value,
        loading: loading.value,
        popup: popup.value,
      ),
    );
  }

  RxWebviewMeta change({dynamic webviewMeta}) {
    if (webviewMeta is RxWebviewMeta) {
      key.value = webviewMeta.key.value;
      url.value = webviewMeta.url.value;
      html.value = webviewMeta.html.value;
      title.value = webviewMeta.title.value;
      query.value = webviewMeta.query.value;
      checkHttps.value = webviewMeta.checkHttps.value;
      checkUrl.value = webviewMeta.checkUrl.value;
      fromHtml.value = webviewMeta.fromHtml.value;
      fromUrl.value = webviewMeta.fromUrl.value;
      loading.value = webviewMeta.loading.value;
      popup.value = webviewMeta.popup.value;
    }

    if (webviewMeta is WebviewMeta) {
      key.value = webviewMeta.key;
      url.value = webviewMeta.url;
      html.value = webviewMeta.html;
      title.value = webviewMeta.title;
      query.value = webviewMeta.query;
      checkHttps.value = webviewMeta.checkHttps;
      checkUrl.value = webviewMeta.checkUrl;
      fromHtml.value = webviewMeta.fromHtml;
      fromUrl.value = webviewMeta.fromUrl;
      loading.value = webviewMeta.loading;
      popup.value = webviewMeta.popup;
    }

    return this;
  }
}

class WebviewMeta {
  static String uuid() {
    return hex.encode(
      md5.convert(utf8.encode(Random().nextDouble().toString())).bytes,
    );
  }

  String key;
  String url;
  String html;
  String title;
  Map<String, dynamic> query;
  bool checkHttps;
  bool checkUrl;
  bool fromHtml;
  bool fromUrl;
  bool loading;
  bool popup;

  WebviewMeta({
    String? key,
    String? title,
    this.url = '',
    this.html = '',
    Map<String, dynamic>? query,
    this.checkHttps = false,
    this.checkUrl = false,
    this.fromHtml = false,
    this.fromUrl = false,
    this.loading = false,
    this.popup = false,
  }) : key = key ?? uuid(),
       query = query ?? {},
       title = title ?? 'System_Loading'.tr;

  WebviewMeta clone({WebviewMeta? webviewMeta}) {
    return WebviewMeta(
      key: webviewMeta != null ? webviewMeta.key : key,
      url: webviewMeta != null ? webviewMeta.url : url,
      html: webviewMeta != null ? webviewMeta.html : html,
      title: webviewMeta != null ? webviewMeta.title : title,
      query: Map.from(webviewMeta != null ? webviewMeta.query : query),
      checkHttps: webviewMeta != null ? webviewMeta.checkHttps : checkHttps,
      checkUrl: webviewMeta != null ? webviewMeta.checkUrl : checkUrl,
      fromHtml: webviewMeta != null ? webviewMeta.fromHtml : fromHtml,
      fromUrl: webviewMeta != null ? webviewMeta.fromUrl : fromUrl,
      loading: webviewMeta != null ? webviewMeta.loading : loading,
      popup: webviewMeta != null ? webviewMeta.popup : popup,
    );
  }

  WebviewMeta change({WebviewMeta? webviewMeta}) {
    if (webviewMeta != null) {
      key = webviewMeta.key;
      url = webviewMeta.url;
      html = webviewMeta.html;
      title = webviewMeta.title;
      query = webviewMeta.query;
      checkHttps = webviewMeta.checkHttps;
      checkUrl = webviewMeta.checkUrl;
      fromHtml = webviewMeta.fromHtml;
      fromUrl = webviewMeta.fromUrl;
      loading = webviewMeta.loading;
      popup = webviewMeta.popup;
    }

    return this;
  }
}
