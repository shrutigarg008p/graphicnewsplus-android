/// Created by Amit Rawat on 12/16/2021.
import 'package:flutter/cupertino.dart';
import 'package:graphics_news/network/response/subscription_response.dart';

/// Global variables
/// * [GlobalKey<NavigatorState>]
class GlobalVariable {
  /// This global key is used in material app for navigation through firebase notifications.
  /// [navState] usage can be found in [notification_notifier.dart] file.
  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();

  static bool? HomepageLoad;
  static bool? notification;
  static int? notificationId;
  static String? notificationType;
  static SubscriptionData? subscriptionData;
}
