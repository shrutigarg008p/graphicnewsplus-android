import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphics_news/Utility/route.dart';

/// Created by Amit Rawat on 11/15/2021.
class DioException {
  String getDioException(BuildContext context, error) {
    try {
      if (error is DioError) {
        switch (error.type) {
          case DioErrorType.cancel:
            break;
          case DioErrorType.connectTimeout:
            break;
          case DioErrorType.other:
            break;
          case DioErrorType.receiveTimeout:
            break;
          case DioErrorType.response:
            switch (error.response!.statusCode) {
              case 400:
                break;
              case 401:
                RouteMap().logOutSession(context);
                return "token expired";
              case 403:
                return "unauthorisedRequest";

              case 404:
                return "Not found";

              case 409:
                return "conflict";

              case 408:
                return "requestTimeout";

              case 500:
                return "internalServerError";

              case 503:
                return "serviceUnavailable";

              default:
                var responseCode = error.response!.statusCode;
                print("Received invalid status code :$responseCode");
            }
            break;
          case DioErrorType.sendTimeout:
            return "sendTimeout";
        }
      } else if (error is SocketException) {
        return "noInternetConnection";
      } else {
        return "unexpectedError";
      }

      return "networkExceptions";
    } on FormatException {
      // Helper.printError(e.toString());
      return "formatException";
    } catch (_) {
      return "unexpectedError";
    }
  }
}
