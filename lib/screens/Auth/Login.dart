import 'dart:io' show Platform;
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graphics_news/Authutil/shared_manager.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/internet_util.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/login_req.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Auth/ForgotPassword.dart';
import 'package:graphics_news/screens/Auth/social_login_page.dart';
import 'package:graphics_news/util/LoadingIndicator.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../Utility/header_widget.dart';
import 'Resigter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class Login extends StatefulWidget {
  bool isGuestUserNav = false;

  Login({Key? key, required this.isGuestUserNav}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> _key1 = GlobalKey();
  bool checkBoxValue = false;

  var username, password;
  var loginOutput;
  bool isObscure = false;
  var usernameText = TextEditingController();
  var passwordText = TextEditingController();
  dynamic mediaQueryData;
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  bool buttonLoading = false;
  late FirebaseAnalytics analytics;
  ScrollController _controller = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    fireScreenViewevent();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return widget.isGuestUserNav
        ? Scaffold(
            appBar: HeaderWidget.appHeader(BaseConstant.LOGIN_TITLE, context),
            body: bodyWidget(),
          )
        : Scaffold(
            body: bodyWidget(),
          );
  }

  Widget bodyWidget() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 52.0,
                ),
                logoSection(),
                SizedBox(
                  height: 24.0,
                ),
                loginAccountText(),
                SizedBox(
                  height: 22.0,
                ),
                loginForm(),
                SizedBox(
                  height: 18.0,
                ),
                rememberMeSection(),
                SizedBox(
                  height: 18.0,
                ),
                loginButton(),
                SizedBox(
                  height: 24.0,
                ),
                loginOptionText(),
                SizedBox(
                  height: 10.0,
                ),
                SocialLoginPage(
                  isGuestUserNav: widget.isGuestUserNav,
                ),
                SizedBox(
                  height: 24.0,
                ),
                signUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget logoSection() {
    return Container(
      width: 104.0,
      height: 104.0,
      child: Image(
        image: AssetImage('images/logo.png'),
        fit: BoxFit.fill,
      ),
    );
  }

  Widget loginAccountText() {
    return Container(
        child: Text(
      'Login to your account',
      style: FontUtil.style(17, SizeWeight.Medium, context),
    ));
  }

  Widget loginForm() {
    return Container(
        child: Form(
      key: _key1,
      child: Column(
        children: [
          userNameTextFormField(),
          SizedBox(
            height: 10.0,
          ),
          passwordTextFormField(),
        ],
      ),
    ));
  }

  Widget userNameTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        elevation: 1.0,
        child: TextFormField(
          controller: usernameText,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.emailAddress,
          cursorColor: WidgetColors.primaryColor,
          style: TextStyle(color: ModeTheme.getDefault(context)),
          validator: (input) => input!.isEmpty
              ? 'Enter Email'
              : EmailValidator.validate(input)
                  ? null
                  : 'Invalid Email',
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            hintText: "Email",
            hintStyle: TextStyle(color: ModeTheme.getDefault(context)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: WidgetColors.primaryColor),
              borderRadius: BorderRadius.circular(5.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          onSaved: (input) => username = input,
        ),
      ),
    );
  }

  Widget passwordTextFormField() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Material(
            borderRadius: BorderRadius.circular(5.0),
            elevation: 1.0,
            child: TextFormField(
              controller: passwordText,
              keyboardType: TextInputType.visiblePassword,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              obscureText: isObscure ? false : true,
              cursorColor: WidgetColors.primaryColor,
              style: TextStyle(color: ModeTheme.getDefault(context)),
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Enter Password';
                }
                return null;
              },
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                hintText: "Password",
                hintStyle: TextStyle(color: ModeTheme.getDefault(context)),
                suffixIcon: IconButton(
                    icon: Icon(
                        isObscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    }),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: WidgetColors.primaryColor),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                //
              ),
              onSaved: (input) => password = input,
            )));
  }

  Widget rememberMeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ForgotPassword())),
              child: Text(
                'Forgot Password?',
                style: FontUtil.style(16, SizeWeight.Regular, context),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget loginButton() {
    return buttonLoading
        ? LoadingIndicator()
        : Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: ElevatedButton(
              onPressed: () {
                InternetUtil.check().then((value) => {
                      if (value)
                        {
                          if (_key1.currentState!.validate())
                            {
                              _key1.currentState!.save(),
                              _sendToNextScreen(context)
                            }
                        }
                      else
                        {InternetUtil.errorMsg(context)}
                    });
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(12.0),
                  primary: WidgetColors.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              child: Text(
                BaseConstant.LOGIN,
                style: FontUtil.style(
                    14, SizeWeight.Medium, context, Colors.white),
              ),
            ),
          );
  }

  Widget loginOptionText() {
    return Container(
        child: Text(
      BaseConstant.OR_LOGIN_USING,
      style: FontUtil.style(17, SizeWeight.Regular, context),
    ));
  }

  Widget signUpButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Register(
                      isGuestUserNav: widget.isGuestUserNav,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: ModeTheme.blackOrGrey(context)),
            borderRadius: BorderRadius.circular(5.0)),
        margin: EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 13),
        child: Text(
          BaseConstant.SIGN_UP_MSG,
          textAlign: TextAlign.center,
          style: FontUtil.style(14, SizeWeight.Medium, context),
        ),
      ),
    );
  }

  _sendToNextScreen(BuildContext context) async {
    buttonloadingstate(true);
    LoginReq loginReq = LoginReq(username, password);
    String platformType;
    if (Platform.isIOS) {
      platformType = BaseKey.IOS;
    } else {
      platformType = BaseKey.ANDROID;
    }

    HttpObj.instance
        .getAuth()
        .getLogin(
            loginReq.email, loginReq.password, getId.toString(), platformType)
        .then((it) {
      String msg = BaseConstant.SERVER_ERROR;
      if (it.sTATUS == BaseKey.SUCCESS &&
          it.DATA != null &&
          it.DATA!.accessToken != null) {
        SharedManager.instance.savedDataLocal(it);
        OneSignal.shared.setExternalUserId(it.DATA!.user!.id.toString());
        fireloginevent(it.DATA!.user!.firstName! + it.DATA!.user!.lastName!,
            it.DATA!.user!.email);

        if (widget.isGuestUserNav) {
          RouteMap.onBack(context);
        } else {
          RouteMap.getHome(context);
        }

        return;
      }
      if (it.MESSAGE != null && it.MESSAGE!.isNotEmpty) {
        msg = it.MESSAGE!;
      }
      UiUtil.showAlert(context, BaseConstant.APPNAME, msg, null, true);
      SharedManager.instance.deleteToken();

      buttonloadingstate(false);

      // return it;
    }).catchError((Object obj) {
      print("Incorrect Credentials");
      // non-200 error goes here.
      buttonloadingstate(false);
      CommonException().showAuthException(context, obj);
    });
  }

  void buttonloadingstate(bool stateload) {
    setState(() {
      buttonLoading = stateload;
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

  fireloginevent(String? name, String? email) async {
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      analytics = FirebaseAnalytics.instance;
    });
    await FirebaseAnalytics.instance.logEvent(
      name: "login",
      parameters: {
        "name": name,
        "email": email,
      },
    );
  }

  fireScreenViewevent() async {
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      analytics = FirebaseAnalytics.instance;
    });
    await FirebaseAnalytics.instance.logEvent(
      name: "screen_view",
      parameters: {
        "screen_name": "LoginScreen",
      },
    );
  }
}
