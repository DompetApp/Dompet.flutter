import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dompet/configure/fluttertoast.dart';
import 'package:dompet/logger/printer.dart';
import 'package:dompet/logger/logger.dart';

final fetch = DioManager.fetch;

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

    return dio
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            options.headers['token'] ??= GetStorage().read('token');
            options.extra['request'] ??= dateAndTime();
            return handler.next(options);
          },
          onResponse: (response, handler) {
            response.extra['response'] ??= dateAndTime();
            response.extra['request'] ??= dateAndTime();
            return handler.next(response);
          },
          onError: (error, handler) {
            switch (error.type) {
              case DioExceptionType.sendTimeout:
              case DioExceptionType.receiveTimeout:
              case DioExceptionType.connectionTimeout:
                Toaster.error(message: 'Network timeout!'.tr);
                break;

              default:
                Toaster.error(message: 'System abnormality!'.tr);
            }

            if (error.requestOptions.extra['logger'] == true) {
              error.requestOptions.extra['response'] ??= dateAndTime();
              error.requestOptions.extra['request'] ??= dateAndTime();

              final message = {
                'dio': 'network request failed'.tr,
                'path': '${error.requestOptions.uri}',
                'method': error.requestOptions.method,
                'headers': '${error.requestOptions.headers}',
                'bodyData': '${error.requestOptions.data ?? ''}',
                'queryParams': '${error.requestOptions.queryParameters}',
                'requestTime': '${error.requestOptions.extra['request']}',
                'responseTime': '${error.requestOptions.extra['response']}',
                'responseData': '${error.response?.data ?? ''}',
                'responseError': '${error.message ?? error.error ?? ''}',
              };

              logger.error(message, error.error, error.stackTrace);
            }

            return handler.next(error);
          },
        ),
      );
  }

  static Dio fetch = DioManager.create(
    BaseOptions(
      extra: {'logger': true},
      baseUrl: 'http://localhost/api',
      sendTimeout: const Duration(milliseconds: 30000),
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 30000),
    ),
  );
}
