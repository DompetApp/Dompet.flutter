export 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DioManager {
  static Dio create(BaseOptions option) {
    final dio = Dio(
      BaseOptions(
        method: option.method,
        baseUrl: option.baseUrl,
        headers: option.headers,
        sendTimeout: option.sendTimeout,
        connectTimeout: option.connectTimeout,
        receiveTimeout: option.receiveTimeout,
        contentType: option.contentType,
        responseType: option.responseType,
        validateStatus: option.validateStatus,
        receiveDataWhenStatusError: option.receiveDataWhenStatusError,
        followRedirects: option.followRedirects,
        maxRedirects: option.maxRedirects,
        requestEncoder: option.requestEncoder,
        responseDecoder: option.responseDecoder,
        listFormat: option.listFormat,
        extra: option.extra,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(
            options..headers['token'] ??= GetStorage().read('token'),
          );
        },
        onResponse: (response, handler) {
          final requestOptions = response.requestOptions;
          final status = response.statusCode;

          if ([401, 403, '401', '403'].contains(status)) {
            handler.reject(
              DioException(
                requestOptions: requestOptions,
                response: response,
              ),
            );
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          final fToast = FToast();

          fToast.init(Get.context!);
          fToast.removeQueuedCustomToasts();

          switch (e.type) {
            case DioExceptionType.sendTimeout:
            case DioExceptionType.receiveTimeout:
            case DioExceptionType.connectionTimeout:
              fToast.showToast(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22.0,
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.redAccent,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Expanded(
                        child: Text(
                          '网络超时，请重试！',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        color: Colors.white,
                        onPressed: () => fToast.removeCustomToast(),
                      )
                    ],
                  ),
                ),
                gravity: ToastGravity.TOP,
                toastDuration: const Duration(seconds: 3),
              );
              break;

            default:
              fToast.showToast(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22.0,
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.redAccent,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Expanded(
                        child: Text(
                          '网络请求，系统异常！',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        color: Colors.white,
                        onPressed: () => fToast.removeCustomToast(),
                      )
                    ],
                  ),
                ),
                gravity: ToastGravity.TOP,
                toastDuration: const Duration(seconds: 3),
              );
          }

          return handler.next(e);
        },
      ),
    );

    return dio;
  }

  static final Dio fetch = DioManager.create(
    BaseOptions(
      baseUrl: '/api',
      sendTimeout: const Duration(milliseconds: 30000),
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 30000),
    ),
  );
}
