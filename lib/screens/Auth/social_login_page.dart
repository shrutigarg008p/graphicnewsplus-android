import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphics_news/Authutil/shared_manager.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/internet_util.dart';
import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/Utility/social_auth.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/network/entity/social_login_req.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/util/LoadingIndicator.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class SocialLoginPage extends StatefulWidget {
  bool isGuestUserNav = false;

  SocialLoginPage({Key? key, required this.isGuestUserNav}) : super(key: key);


  @override
  _SocialLoginPageState createState() => _SocialLoginPageState();
}

class _SocialLoginPageState extends State<SocialLoginPage> {
  bool loading = false;
  String? name;
  String? email;
  String? imageUrl;
  String? uid;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: socialLogin(context));
  }

  Widget socialLogin(BuildContext context) {
    return loading
        ? LoadingIndicator()
        : Container(
            child: GestureDetector(
              onTap: () {
                InternetUtil.check().then((value) => {
                      if (value)
                        {tapOnBtn(context)}
                      else
                        {InternetUtil.errorMsg(context)}
                    });
              },
              child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Platform.isIOS
                      ? Image(image: AssetImage('images/apple.png'))
                      : Image(image: AssetImage('images/gmail.png'))),
            ),
          );
  }

  socialLoader(bool value) {
    if (mounted) {
      setState(() {
        loading = value;
      });
    }
  }

  gmailLogin() {
    AuthCredential credential;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    if (_auth != null) {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      if (_googleSignIn != null) {
        _googleSignIn
            .signIn()
            .then((googleUser) => {
                  if (googleUser != null)
                    {
                      googleUser.authentication
                          .then((googleAuth) => {
                                if (googleAuth != null)
                                  {
                                    credential = GoogleAuthProvider.credential(
                                        accessToken: googleAuth.accessToken,
                                        idToken: googleAuth.idToken),
                                    if (credential != null)
                                      {
                                        _auth
                                            .signInWithCredential(credential)
                                            .then((value) => {
                                                  if (value.user != null)
                                                    {
                                                      this.email =
                                                          value.user?.email!,
                                                      this.name = value
                                                          .user?.displayName!,
                                                      this.uid =
                                                          value.user?.uid,
                                                      socialloginApi(
                                                          BaseKey.ANDROID)
                                                    }
                                                  else
                                                    {gmailError(context)}
                                                })
                                            .catchError((Object obj) {
                                          print(obj);
                                          gmailError(context);
                                        })
                                      }
                                    else
                                      {gmailError(context)}
                                  }
                                else
                                  {gmailError(context)}
                              })
                          .catchError((Object obj) {
                        print(obj);
                        gmailError(context);
                      })
                    }
                  else
                    {gmailError(context)}
                })
            .catchError((Object obj) {
          print(obj);
          gmailError(context);
        });
      } else {
        gmailError(context);
      }
    } else {
      gmailError(context);
    }
  }

  gmailError(BuildContext context) {
    socialLoader(false);
    UiUtil.serverError(context);
  }

  void tapOnBtn(BuildContext context) {
    socialLoader(true);
    SocialAuth obj = SocialAuth();
    if (Platform.isAndroid) {
      try {
        gmailLogin();
      } catch (error) {
        gmailError(context);
      }
    } else {
      obj
          .doAppleLogin()
          .then((value) => {
                if (value)
                  {
                    email = obj.email,
                    name = obj.name,
                    uid = obj.socialId,
                    socialloginApi(BaseKey.IOS)
                  }
                else
                  {socialLoader(false)}
              })
          .catchError((Object obj) {
        UiUtil.showAlert(
            context, BaseConstant.Server_error, "Please Try Again", null, true);
        socialLoader(false);
      });
    }
  }

  Future<void> socialloginApi(String devicetype) async {
    var socialLoginReq2 = SocialLoginReq(
        name ?? BaseConstant.EMPTY,
        email ?? BaseConstant.EMPTY,
        uid ?? BaseConstant.EMPTY,
        devicetype,
        getId().toString(),
        BaseConstant.EMPTY,
        BaseConstant.EMPTY,
        BaseConstant.EMPTY,
        BaseConstant.EMPTY,
        BaseConstant.EMPTY,
        BaseConstant.EMPTY);

    SocialLoginReq socialLoginReq = socialLoginReq2;
    print(socialLoginReq2);
    HttpObj.instance
        .getAuth()
        .getSociallogin(
            socialLoginReq.name,
            socialLoginReq.email,
            socialLoginReq.social_id,
            socialLoginReq.platform,
            socialLoginReq.device_id,
            socialLoginReq.countryCode,
            socialLoginReq.dob,
            socialLoginReq.gender,
            socialLoginReq.phone,
            socialLoginReq.referredFrom,
            socialLoginReq.referCode)
        .then((it) {
      String msg = BaseConstant.SERVER_ERROR;
      if (it.sTATUS == BaseKey.SUCCESS) {
        if (it.DATA!.accessToken != null) {
          print(it.MESSAGE);

          SharedManager.instance.savedDataLocal(it);
          print(it.DATA!.user!);
          OneSignal.shared.setExternalUserId(it.DATA!.user!.id.toString());
          if (widget.isGuestUserNav) {
            RouteMap.onBack(context);
          } else {
            RouteMap.getHome(context);
          }
          return;
        }
      }
      if (it.MESSAGE != null && it.MESSAGE!.isNotEmpty) {
        msg = it.MESSAGE!;
      }
      UiUtil.showAlert(context, BaseConstant.APPNAME, msg, null, true);
      SharedManager.instance.deleteToken();

      socialLoader(false);
    }).catchError((Object obj) {
      socialLoader(false);
      CommonException().showAuthException(context, obj);
    });
  }

  Future<String> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor ?? ""; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId ?? ""; // unique ID on Android
    }
  }
}
