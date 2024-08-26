import 'package:graphics_news/network/services/common_dio.dart';
import 'package:graphics_news/network/services/rest_client.dart';

/// Created by Amit Rawat on 2/3/2022.

class HttpObj {
  HttpObj._privateConstructor();

  static final HttpObj _instance = HttpObj._privateConstructor();

  static HttpObj get instance => _instance;
  static RestClient? authClient;
  static RestClient? client;

  clear() {
    client = null;
    authClient = null;
  }

  RestClient getClient() {
    if (client == null) {
      client = RestClient(ApiClient.instance.getdio());
    }
    return client!;
  }

  RestClient getAuth() {
    if (authClient == null) {
      authClient = RestClient(ApiClient.instance.getAuthdio());
    }
    return authClient!;
  }
}
