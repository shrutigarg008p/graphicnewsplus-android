import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphics_news/Authutil/shared_manager.dart';
import 'package:graphics_news/Utility/internet_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/bottom_nav.dart';
import 'package:graphics_news/common_widget/pay_mode_alert.dart';
import 'package:graphics_news/constant/GlobalVariable.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/network/entity/single_paymode.dart';
import 'package:graphics_news/network/response/subscription_response.dart';
import 'package:graphics_news/network/services/common_dio.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Auth/Login.dart';
import 'package:graphics_news/screens/Auth/changePassword.dart';
import 'package:graphics_news/screens/Home/blog/promoted/promoted_content_details.dart';
import 'package:graphics_news/screens/Home/blog/topStory/top_stories_details.dart';
import 'package:graphics_news/screens/Home/gridView/common_grid_layout.dart';
import 'package:graphics_news/screens/Home/paper/magazines/Magazine_details.dart';
import 'package:graphics_news/screens/Home/paper/newPaper/news_details.dart';
import 'package:graphics_news/screens/Home/pdfWebview/pdf_view.dart';
import 'package:graphics_news/screens/Home/search/search_screen.dart';
import 'package:graphics_news/screens/Settings/Account.dart';
import 'package:graphics_news/screens/Settings/Subscription_Renew.dart';
import 'package:graphics_news/screens/Settings/subscription/refund_subsription_dialog.dart';
import 'package:graphics_news/screens/subscription/all_plans_subscription.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'commonException.dart';
import 'data_holder.dart';

class RouteMap {
  static onBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  static pushNav(BuildContext context, StatefulWidget widgetClass) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => widgetClass));
  }

  static onBackTimes(BuildContext context, int times) {
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= times);
  }

  static ProfilePage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Account()));
  }

  static gridPaper(BuildContext context, int id, String type) {
    InternetUtil.check().then((value) => {
          if (value)
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CommonGridLayout(id: id, type: type)))
            }
          else
            {InternetUtil.errorMsg(context)}
        });
  }

  static changePassword(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ChangePassword()));
  }

  static search(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SearchScreen()));
  }

  static payModeAlert(BuildContext mcontext, SinglePayMode singlePayMode,
      VoidCallback? refreshApiData) {
    showDialog(
        context: mcontext,
        builder: (BuildContext context) {
          return PayModeAlert(
              singlePayMode: singlePayMode, refreshApiData: refreshApiData);
        });
  }

  static refundModeAlert(
      {BuildContext? mcontext,
      SubscriptionData? subscriptionData,
      Function? refreshRefundData,
      int? index}) {
    showDialog(
        context: mcontext!,
        builder: (BuildContext context) {
          return RefundSubscriptionDialog(
            subscriptionData: subscriptionData,
            refreshRefund: refreshRefundData,
            index: index,
          );
        });
  }

  static getAllPlans(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AllPlansSubscription()));
  }

  static getHome(BuildContext context, {int index = 0}) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => BottomNav(
                  selectedIndex: index,
                )),
        ModalRoute.withName("/Home"));
  }

  getLogin(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Login(
                    isGuestUserNav: false,
                  )),
          ModalRoute.withName("/Login"));
    });
  }

  openPdf(BuildContext context, String? filepath, String? murl) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PdfPage(
                  url: murl,
                  pdfPath: filepath,
                )));
  }

  static notificationLinking(
      String? type, int? id, SubscriptionData? subscriptionData) {
    if (type == BaseKey.Publish_Magzine) {
   SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
            GlobalVariable.navState.currentState!.context,
            MaterialPageRoute(
                builder: (context) => MagazineDetails(
                      magazineId: id,
                      title: '',
                    )));
      });
    } else if (type == BaseKey.Publish_NewsPaper) {
   SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
            GlobalVariable.navState.currentState!.context,
            MaterialPageRoute(
                builder: (_context) => NewsDetails(
                      newsId: id,
                      title: '',
                    )));
      });
    } else if (type == BaseKey.Publish_Promoted) {
   SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
            GlobalVariable.navState.currentState!.context,
            MaterialPageRoute(
                builder: (_context) => PromotedContentDetails(
                      promotedId: id,
                    )));
      });
    } else if (type == BaseKey.Publish_top_story) {
   SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
            GlobalVariable.navState.currentState!.context,
            MaterialPageRoute(
                builder: (_context) => TopStoriesDetails(
                      id: id,
                    )));
      });
    } else if (type == BaseKey.renew_page) {
   SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
            GlobalVariable.navState.currentState!.context,
            MaterialPageRoute(
                builder: (_context) => SubscriptionRenew(
                      subscriptionData: subscriptionData,
                      NotificationRenewKey: 1,
                    )));
      });
    }
    DataHolder.clearNotificationData();
  }

  navIsLogin(BuildContext context, StatefulWidget widgetClass) {
    if (RouteMap.isLogin()) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => widgetClass));
    } else {
      logOutSession(context);
    }
  }

  logOutSession(BuildContext context) {
    if (RouteMap.isLogin()) {
      UiUtil.toastPrint(BaseConstant.SESSION_EXPIRED);
      logOut(context);
    } else {
      UiUtil.toastPrint(BaseConstant.PLEASE_LOGIN_TO_CONTINUE);
    WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Login(isGuestUserNav: true)));
      });
    }
  }

  logOut(BuildContext context) {
    try {
      GoogleSignIn().signOut();
      FirebaseAuth.instance.signOut();
    } catch (error) {
      print(error);
    }
    HttpObj.instance.clear();
    ApiClient.instance.clear();
    SharedManager.instance.deleteToken();
    OneSignal.shared.removeExternalUserId();
    getLogin(context);
  }

  static bool isLogin() {
    dynamic auth = SharedManager.instance.getAuthToken();
    if (auth != null && auth.isNotEmpty) {
      return true;
    }
    return false;
  }

  static backReloadLogin(BuildContext context, apiReload) {
    UiUtil.toastPrint(BaseConstant.PLEASE_LOGIN_TO_CONTINUE);
  WidgetsBinding.instance.addPostFrameCallback((_) {
      Route route =
          MaterialPageRoute(builder: (context) => Login(isGuestUserNav: true));
      Navigator.push(context, route).then(apiReload);
    });
  }

  static commonExceptionBlog(BuildContext context, Object obj, reloadApi) {
    if (isLogin()) {
      CommonException().exception(context, obj);
    } else {
      if (obj is DioError) {
        switch (obj.type) {
          case DioErrorType.response:
            switch (obj.response!.statusCode) {
              case 401:
                backReloadLogin(context, reloadApi);
                return "token expired";
            }
        }
      }
    }
  }
}
