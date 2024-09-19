import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dompet/configure/fluttertoast.dart';

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
            return handler.reject(
              DioException(
                requestOptions: requestOptions,
                response: response,
              ),
            );
          }

          return handler.next(response);
        },
        onError: (DioException e, handler) {
          switch (e.type) {
            case DioExceptionType.sendTimeout:
            case DioExceptionType.receiveTimeout:
            case DioExceptionType.connectionTimeout:
              Toaster.error(message: 'Network timeout!');
              break;

            default:
              Toaster.error(message: 'System abnormality!');
          }

          return handler.next(e);
        },
      ),
    );

    return dio;
  }
}

final fetch = DioManager.create(
  BaseOptions(
    baseUrl: 'http://localhost/api',
    sendTimeout: const Duration(milliseconds: 30000),
    connectTimeout: const Duration(milliseconds: 30000),
    receiveTimeout: const Duration(milliseconds: 30000),
  ),
);
