import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dompet/configure/fluttertoast.dart';
import 'package:dompet/logger/printer.dart';
import 'package:dompet/logger/logger.dart';

export 'package:dio/dio.dart';

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

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['token'] ??= GetStorage().read('token');
          options.extra['request'] ??= dateAndTime();
          return handler.next(options);
        },
        onResponse: (response, handler) {
          response.requestOptions.extra['response'] ??= dateAndTime();
          response.requestOptions.extra['request'] ??= dateAndTime();
          return handler.next(response);
        },
        onError: (error, handler) {
          switch (error.type) {
            case DioExceptionType.sendTimeout:
            case DioExceptionType.receiveTimeout:
            case DioExceptionType.connectionTimeout:
              if (error.requestOptions.extra['retry'] < 1) {
                Toaster.error(message: 'System_Network_Timeout'.tr);
              }

              break;

            default:
              Toaster.error(message: 'System_Abnormality'.tr);
          }

          if (error.requestOptions.extra['logger'] == true) {
            error.requestOptions.extra['response'] ??= dateAndTime();
            error.requestOptions.extra['request'] ??= dateAndTime();

            final message = {
              'dio': 'network request failed',
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

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          try {
            if (error.requestOptions.extra['retry'] >= 1) {
              switch (error.type) {
                case DioExceptionType.sendTimeout:
                case DioExceptionType.receiveTimeout:
                case DioExceptionType.connectionTimeout:
                  error.requestOptions.extra['retry'] -= 1;
                  error.requestOptions.extra['request'] = null;
                  error.requestOptions.extra['response'] = null;
                  await Future.delayed(Duration(milliseconds: 100));
                  return dio.fetch(error.requestOptions).then(handler.resolve);

                default:
                  break;
              }
            }
          } catch (e) {
            /** e */
          }

          return handler.next(error);
        },
      ),
    );

    return dio;
  }

  static Dio fetch = DioManager.create(
    BaseOptions(
      baseUrl: 'http://localhost/api',
      sendTimeout: const Duration(milliseconds: 3000),
      connectTimeout: const Duration(milliseconds: 3000),
      receiveTimeout: const Duration(milliseconds: 3000),
      extra: {'logger': true, 'retry': 0},
    ),
  );
}
