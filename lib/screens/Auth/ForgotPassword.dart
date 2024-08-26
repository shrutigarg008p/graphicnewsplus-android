import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/forget_req.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/util/LoadingIndicator.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var emailText = TextEditingController();
  bool buttonLoading = false;
  var email;
  GlobalKey<FormState> _key1 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: WidgetColors.primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
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
                forgotPasswordText(),
                SizedBox(
                  height: 22.0,
                ),
                forgotPasswordContent(),
                SizedBox(
                  height: 28.0,
                ),
                forgotPasswordForm(),
                SizedBox(
                  height: 18.0,
                ),
                continueButton(),
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

  Widget forgotPasswordText() {
    return Container(
        child: Text(
      'Forgot Password',
      style: FontUtil.style(17, SizeWeight.Bold, context),
    ));
  }

  Widget forgotPasswordContent() {
    return Container(
      margin: EdgeInsets.only(left: 28.0, right: 28.0),
      child: Text(
        "Enter your registered E-mail address.\nThe link to reset your password will be sent to your email address.",
        style: FontUtil.style(13, SizeWeight.Regular, context),
      ),
    );
  }

  Widget forgotPasswordForm() {
    return Container(
        child: Form(
      key: _key1,
      child: Column(
        children: [emailTextFormField()],
      ),
    ));
  }

  Widget emailTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        elevation: 1.0,
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: emailText,
          cursorColor: WidgetColors.primaryColor,
          validator: (input) => input!.isEmpty
              ? 'Enter email'
              : EmailValidator.validate(input)
                  ? null
                  : 'Invalid Email',
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            hintText: "Enter your account's email address",
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: WidgetColors.primaryColor),
              borderRadius: BorderRadius.circular(5.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          onSaved: (input) => email = input,
        ),
      ),
    );
  }

  Widget continueButton() {
    return buttonLoading
        ? LoadingIndicator()
        : Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 34.0),
            child: ElevatedButton(
              onPressed: () {
                if (_key1.currentState!.validate()) {
                  _key1.currentState!.save();
                  buttonloadingstate(true);

                  ForgetReq forgetReq = ForgetReq(emailText.text);
                  HttpObj.instance
                      .getAuth()
                      .forgetPassword(forgetReq.email)
                      .then((value) {
                    buttonloadingstate(false);

                    if (value.sTATUS == BaseKey.SUCCESS) {
                      Fluttertoast.showToast(
                          msg: value.mESSAGE ?? "",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      RouteMap.onBack(context);
                    } else {
                      Fluttertoast.showToast(
                          msg: value.mESSAGE ?? "",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  }).catchError((Object obj) {
                    // non-200 error goes here.
                    buttonloadingstate(false);
                    CommonException().showAuthException(context, obj);
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(12.0),
                  primary: WidgetColors.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              child: Text(
                'CONTINUE',
                style: FontUtil.style(
                    14, SizeWeight.Medium, context, Colors.white),
              ),
            ),
          );
  }

  void buttonloadingstate(bool stateload) {
    setState(() {
      buttonLoading = stateload;
    });
  }
}
