import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
export 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:dompet/configure/fluttertoast.dart';
import 'package:dompet/extension/bool.dart';
import 'package:dompet/logger/printer.dart';
import 'package:dompet/logger/logger.dart';

final fetch = DioManager.fetch;

class DioManager {
  static String encrypt(String data, [String? key]) {
    final code = key.bv ? key! : 'XDompetTH90JK373';
    final encrypter = Encrypter(AES(Key.fromUtf8(code)));
    final encrypted = encrypter.encrypt(data, iv: IV(utf8.encode(code)));
    return encrypted.base64;
  }

  static String decrypt(String data, [String? key]) {
    final code = key.bv ? key! : 'XDompetTH90JK373';
    final encrypter = Encrypter(AES(Key.fromUtf8(code)));
    final decrypted = encrypter.decrypt64(data, iv: IV(utf8.encode(code)));
    return decrypted;
  }

  static String encode(dynamic data, [String? type]) {
    if (type == null && data is Uint8List) {
      return base64Encode(data);
    }

    if (type == 'base64Encode') {
      return base64Encode(data);
    }

    return jsonEncode(data);
  }

  static dynamic decode(dynamic data, [String? type]) {
    if (type == 'base64Decode') {
      return base64Decode(data);
    }

    return jsonDecode(data);
  }

  static dynamic recorder(DioException err, [Response? res]) {
    err.requestOptions.extra.remove('code');
    err.requestOptions.extra.remove('cache');
    err.requestOptions.extra.remove('retry');
    err.requestOptions.extra.remove('logger');

    logger.error(
      {
        'dio': 'network request failed',
        'path': err.requestOptions.uri,
        'method': err.requestOptions.method,
        'headers': err.requestOptions.headers,
        'bodyData': err.requestOptions.data,
        'queryExtra': err.requestOptions.extra,
        'queryParams': err.requestOptions.queryParameters,
        'responseData': err.response?.data,
        'responseExtra': err.response?.extra,
        'responseError': err.message ?? err.error,
        'responseUsage': res != null ? 'Cached' : 'Unknown',
      },
      err.error,
      err.stackTrace,
    );
  }

  static Future<Response?> query(DioException err) async {
    try {
      final uri = err.requestOptions.uri.toString();
      final code = err.requestOptions.extra['code'] ?? uri;
      final cache = err.requestOptions.extra['cache'] ?? false;
      final unique = md5.convert(utf8.encode(code ?? uri)).toString();
      final source = cache ? GetStorage().read('dio_cache_$unique') : null;
      final storage = cache ? jsonDecode(decrypt(source)) : null;

      if (cache == true && storage != null) {
        final options = storage['requestOptions'];

        final headers = storage['headers'].map((k, v) {
          return MapEntry('$k', List<String>.from(v));
        });

        final response = Response(
          requestOptions: RequestOptions(
            path: options['path'],
            extra: Map.from(options['extra']),
            method: options['method'] ?? 'GET',
            queryParameters: Map.from(options['queryParameters']),
            responseType: ResponseType.values[options['responseType']],
            contentType: options['contentType'],
          ),
          data: DioManager.decode(storage['data'], storage['decode']),
          extra: Map.from(storage['extra'])..addAll({'cached': 'local'}),
          headers: Headers.fromMap(Map<String, List<String>>.from(headers)),
          statusMessage: storage['statusMessage'],
          statusCode: storage['statusCode'],
        );

        return response;
      }
    } catch (e) {
      /* e */
    }

    return null;
  }

  static Future<Response> cache(Response res) async {
    if (res.data is ResponseBody) {
      return res;
    }

    try {
      final uri = res.requestOptions.uri.toString();
      final code = res.requestOptions.extra['code'] ?? uri;
      final cache = res.requestOptions.extra['cache'] ?? false;
      final unique = md5.convert(utf8.encode(code ?? uri)).toString();

      res.requestOptions.extra.remove('logger');
      res.requestOptions.extra.remove('retry');
      res.requestOptions.extra.remove('cache');
      res.requestOptions.extra.remove('code');

      if (cache == true && unique.isNotEmpty) {
        final encode = jsonEncode({
          "requestOptions": {
            "path": res.requestOptions.path,
            "extra": res.requestOptions.extra,
            "method": res.requestOptions.method,
            "contentType": res.requestOptions.contentType,
            "responseType": res.requestOptions.responseType.index,
            "queryParameters": res.requestOptions.queryParameters,
          },
          "data": DioManager.encode(res.data),
          "decode": res.data is Uint8List ? 'base64Decode' : null,
          "statusMessage": res.statusMessage,
          "statusCode": res.statusCode,
          "headers": res.headers.map,
          "extra": res.extra,
        });

        await GetStorage().write('dio_cache_$unique', encrypt(encode));
      }
    } catch (e) {
      /* e */
    }

    return res;
  }

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
        onRequest: (options, handler) async {
          options.headers['token'] ??= GetStorage().read('token');
          options.extra['requested'] ??= dateAndTime();
          options.extra['responsed'] = null;
          options.extra['cache'] ??= false;
          options.extra['retry'] ??= -1;
          return handler.next(options);
        },
        onResponse: (response, handler) async {
          response.requestOptions.extra['requested'] ??= dateAndTime();
          response.requestOptions.extra['responsed'] ??= dateAndTime();

          if (response.statusCode != 200 || response.data is ResponseBody) {
            response.requestOptions.extra['cache'] = false;
          }

          if (response.requestOptions.extra['cache'] == true) {
            await DioManager.cache(response);
          }

          response.requestOptions.extra.remove('logger');
          response.requestOptions.extra.remove('retry');
          response.requestOptions.extra.remove('cache');
          response.requestOptions.extra.remove('code');

          return handler.resolve(response);
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          String? message;
          Response? response;

          switch (error.type) {
            case DioExceptionType.sendTimeout:
            case DioExceptionType.receiveTimeout:
            case DioExceptionType.connectionError:
            case DioExceptionType.connectionTimeout:
              if (error.requestOptions.extra['retry'] >= 1) {
                return handler.next(error);
              }

              message = 'System_Network_Timeout';
              break;

            default:
              message = 'System_Abnormality';
              break;
          }

          error.requestOptions.extra['requested'] ??= dateAndTime();
          error.requestOptions.extra['responsed'] ??= dateAndTime();

          if (error.requestOptions.extra['cache'] == true) {
            response = await DioManager.query(error);
          }

          if (error.requestOptions.extra['logger'] == true) {
            recorder(error, response);
          }

          if (response is! Response) {
            Toaster.error(message: message.tr);
          }

          if (response is Response) {
            return handler.resolve(response);
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
                case DioExceptionType.connectionError:
                case DioExceptionType.connectionTimeout:
                  error.requestOptions.extra['retry'] -= 1;
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
      extra: {'logger': true, 'cache': false, 'retry': -1},
    ),
  );
}
