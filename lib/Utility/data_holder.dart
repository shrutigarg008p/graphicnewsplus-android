import 'package:flutter/cupertino.dart';
import 'package:graphics_news/Utility/ui_ratio.dart';
import 'package:graphics_news/constant/GlobalVariable.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/database_key.dart';
import 'package:graphics_news/network/response/subscription_response.dart';

class DataHolder {
  static getHeightPaperCategory(BuildContext context) {
    return UiRatio.getHeightGrid(
        context: context,
        height: 100,
        landscapePhone: 20,
        landscapeTablet: 50,
        PotraitTablet: 50);
  }

  static clearNotificationData() {
    setNotificationData(null, null, null, null);
  }

  static setDatatbaseTableName(int? userId) {
    DatabaseKey.DATABASE_NAME =
        BaseKey.DatabaseName + userId.toString() + BaseKey.DatabaseExtension;
  }

  static setNotificationData(bool? notification, String? type, int? id,
      SubscriptionData? subscriptionData) {
    GlobalVariable.notification = notification;
    GlobalVariable.notificationId = id;
    GlobalVariable.notificationType = type;
    GlobalVariable.subscriptionData = subscriptionData;
  }

  static SubscriptionData getSubscriptionData(dynamic? subscription) {
    SubscriptionData subscriptionData = new SubscriptionData();
    subscriptionData = new SubscriptionData();
    subscriptionData.subscribed = subscription["subscribed"];
    subscriptionData.amount = subscription["amount"];
    subscriptionData.expired = subscription["expired"];
    subscriptionData.currency = subscription["currency"];
    subscriptionData.type = subscription["type"];
    subscriptionData.value = subscription["value"];
    subscriptionData.key = subscription["key"];
    subscriptionData.description = subscription["description"];
    subscriptionData.payment_method = subscription["payment_method"];
    Duration duration = new Duration();
    dynamic? durationData = subscription["duration"];
    duration.value = durationData["value"];
    duration.key = durationData["key"];
    subscriptionData.duration = duration;
    return subscriptionData;
  }
}
