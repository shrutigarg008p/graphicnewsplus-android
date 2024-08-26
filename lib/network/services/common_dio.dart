import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:graphics_news/Authutil/shared_manager.dart';
import 'package:graphics_news/constant/base_key.dart';

/// Created by Amit Rawat on 11/11/2021.

class ApiClient {
  ApiClient._privateConstructor();

  static final ApiClient _instance = ApiClient._privateConstructor();

  static ApiClient get instance => _instance;
  static Dio? clientDio;
  static Dio? AuthDio;

  clear() {
    clientDio = null;
    AuthDio = null;
  }

  Dio getdio() {
    if (clientDio == null) {
      clientDio = Dio(); // with default Options

      // dio.options.connectTimeout = 5000; //5s
      // dio.options.receiveTimeout = 5000;
      clientDio!.interceptors
          .add(InterceptorsWrapper(onRequest: (options, handler) {
        options.headers[BaseKey.AUTHORIZATION] =
            SharedManager.instance.getAuthToken();
        options.headers[BaseKey.CONTENT_TYPE] = BaseKey.CONTENT_FORMAT;
        options.headers[BaseKey.ACCEPT] = BaseKey.CONTENT_FORMAT;
        options.headers["Cache-Control"] = "No-Store";

        return handler.next(options); //continue
      }, onResponse: (response, handler) {
        return handler.next(response); // continue
      }, onError: (DioError e, handler) {
        return handler.next(e); //continue
      }));

      /*not in release mode: log print*/
      if (!kReleaseMode) {
        clientDio!.interceptors.add(logInterceptor(true));
      } else {
        clientDio!.interceptors.add(logInterceptor(false));
      }
    }

    return clientDio!;
  }

  Dio getAuthdio() {
    if (AuthDio == null) {
      AuthDio = Dio(); // with default Options

      // dio.options.connectTimeout = 5000; //5s
      // dio.options.receiveTimeout = 5000;

      AuthDio!.interceptors
          .add(InterceptorsWrapper(onRequest: (options, handler) async {
        options.headers[BaseKey.CONTENT_TYPE] = BaseKey.CONTENT_FORMAT;
        options.headers[BaseKey.ACCEPT] = BaseKey.CONTENT_FORMAT;
        options.headers["cache-control"] = "No-Store";

        handler.next(options);
        //  dio.unlock();
        //unlock the dio
      }));

      /*not in release mode: log print*/
      if (!kReleaseMode) {
        AuthDio!.interceptors.add(logInterceptor(true));
      } else {
        AuthDio!.interceptors.add(logInterceptor(false));
      }
    }
    return AuthDio!;
  }

  LogInterceptor logInterceptor(bool value) {
    return LogInterceptor(
        responseBody: value,
        requestHeader: value,
        requestBody: value,
        error: value,
        request: value,
        responseHeader: value);
  }
}
