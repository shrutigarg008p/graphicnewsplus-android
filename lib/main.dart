import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:graphics_news/Authutil/theme_manager.dart';
import 'package:graphics_news/screens/Home/Splash_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import 'Authutil/shared_manager.dart';
import 'Utility/data_holder.dart';
import 'Utility/route.dart';
import 'common_widget/bloc.dart';
import 'constant/GlobalVariable.dart';
import 'constant/base_key.dart';
import 'network/response/subscription_response.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SharedManager.instance.init().then((value) => {
        MobileAds.instance.initialize(),
        Firebase.initializeApp(),
        runApp(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ThemeNotifier()),
              Provider<DeepLinkBloc>.value(value: DeepLinkBloc()),
            ],
            child: MyApp(),
          ),
        )
      });
  HttpOverrides.global = MyHttpOverrides();
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedManager.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = DeepLinkBloc();

    notification(context);
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.red));
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => ScreenUtilInit(
              designSize: Size(360, 690),
              builder: (BuildContext context, child) => MaterialApp(
                  navigatorKey: GlobalVariable.navState,
                  debugShowCheckedModeBanner: false,
                  builder: (BuildContext context, Widget? child) {
                    return MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child!,
                    );
                  },
                  theme: theme.getTheme(),
                  // home: SplashScreen()
                  home: Provider<DeepLinkBloc>(
                      create: (context) => _bloc,
                      dispose: (context, bloc) => bloc.dispose(),
                      child: SplashScreen())
                  //   SplashScreen(),
                  ),
            ));
  }

  void notification(BuildContext context) {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId(BaseKey.OneSignalKey);
// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });

    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) async {
      int? id;
      String? type;
      dynamic? subscription;
      SubscriptionData? subscriptionData;
      String auth = SharedManager.instance.getAuthToken();
      if (auth.isNotEmpty) {
        if (result.notification.additionalData != null) {
          id = await result
              .notification.additionalData![BaseKey.json_notification_id];
          type = await result
              .notification.additionalData![BaseKey.json_notification_type];
          subscription = await result.notification
              .additionalData![BaseKey.json_notification_type_subscription];

          if (subscription != null) {
            subscriptionData = DataHolder.getSubscriptionData(subscription);
          }

          if (type != null) {
            DataHolder.setNotificationData(true, type, id, subscriptionData);
            if (GlobalVariable.HomepageLoad != null) {
              RouteMap.notificationLinking(type, id, subscriptionData);
            }
          }
          // Will be called whenever a notification is opened/button pressed.
        }
      }
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // Will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // Will be called whenever the subscription changes
      // (ie. user gets registered with OneSignal and gets a user ID)
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) {
      // Will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
