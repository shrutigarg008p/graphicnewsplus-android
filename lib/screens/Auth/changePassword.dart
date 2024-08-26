import 'package:flutter/material.dart';
import 'package:graphics_news/Authutil/shared_manager.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/StringUtil.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/common_filled_btn.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/auth_dto.dart';
import 'package:graphics_news/network/entity/changePasswordReq.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/util/LoadingIndicator.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  bool _isConfirmPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isOldPasswordVisible = false;
  bool buttonLoading = false;
  var oldPasswordText = TextEditingController();
  var newPasswordText = TextEditingController();
  var confirmPasswordText = TextEditingController();
  User? user;

  void clearTextFieldValue() {
    oldPasswordText.clear();
    newPasswordText.clear();
    confirmPasswordText.clear();
  }

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  void getUserId() async {
    if (mounted) {
      setState(() {
        user = SharedManager.instance.getUserDetail();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Container();
    }
    return Scaffold(
      appBar: HeaderWidget.appHeader(BaseConstant.CHANGE_PASSWORD, context),
      body: SafeArea(
        child: Container(
          child: ListView(
            children: [
              SizedBox(
                height: 20.0,
              ),
              changePasswordContent(),
              SizedBox(
                height: 25.0,
              ),
              oldPassword(),
              SizedBox(
                height: 18.0,
              ),
              newPassword(),
              SizedBox(
                height: 18.0,
              ),
              confirmPassword(),
              SizedBox(
                height: 20.0,
              ),
              buttonLoading
                  ? LoadingIndicator()
                  : CommonFilledBtn(
                      btnName: BaseConstant.CHANGE_PASSWORD.toUpperCase(),
                      onTap: () {
                        changePassword(context);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget changePasswordContent() {
    return Container(
      margin: EdgeInsets.only(left: 35.0, right: 28.0),
      child: Text(
        "Enter your new Password",
        style:
            FontUtil.style(FontSizeUtil.Medium, SizeWeight.SemiBold, context),
      ),
    );
  }

  Widget oldPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        elevation: 1.0,
        child: TextFormField(
          style:
              FontUtil.style(FontSizeUtil.Medium, SizeWeight.Regular, context),
          controller: oldPasswordText,
          cursorColor: WidgetColors.primaryColor,
          validator: (input) => input!.isEmpty
              ? 'Enter Old Password'
              : (input.length < 3 && input.isNotEmpty)
                  ? 'Old Password too short'
                  : (input.length < 10 && input.isNotEmpty)
                      ? 'Invalid Old Password'
                      : null,
          obscureText: _isOldPasswordVisible ? false : true,
          decoration: InputDecoration(
            suffixIcon: IconButton(
                icon: Icon(_isOldPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _isOldPasswordVisible = !_isOldPasswordVisible;
                  });
                }),

            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            hintText: "Old Password",
            hintStyle: FontUtil.style(
                FontSizeUtil.Medium, SizeWeight.Regular, context),
            //   hintStyle: TextStyle(color: Colors.black),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: WidgetColors.primaryColor),
              borderRadius: BorderRadius.circular(5.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget newPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        elevation: 1.0,
        child: TextFormField(
          style:
              FontUtil.style(FontSizeUtil.Medium, SizeWeight.Regular, context),
          controller: newPasswordText,
          cursorColor: WidgetColors.primaryColor,
          validator: (input) => input!.isEmpty
              ? 'Enter New Password'
              : (input.length < 3 && input.isNotEmpty)
                  ? 'New Password too short'
                  : (input.length < 10 && input.isNotEmpty)
                      ? 'Invalid New Password'
                      : null,
          obscureText: _isNewPasswordVisible ? false : true,
          decoration: InputDecoration(
            suffixIcon: IconButton(
                icon: Icon(_isNewPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _isNewPasswordVisible = !_isNewPasswordVisible;
                  });
                }),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            hintText: "New Password",
            hintStyle: FontUtil.style(
                FontSizeUtil.Medium, SizeWeight.Regular, context),
            //    hintStyle: TextStyle(color: Colors.black),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: WidgetColors.primaryColor),
              borderRadius: BorderRadius.circular(5.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget confirmPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        elevation: 1.0,
        child: TextFormField(
          style:
              FontUtil.style(FontSizeUtil.Medium, SizeWeight.Regular, context),
          controller: confirmPasswordText,
          cursorColor: WidgetColors.primaryColor,
          validator: (input) => input != newPasswordText.text
              ? 'Password didn\'t match'
              : (input!.length < 3 && input.isNotEmpty)
                  ? 'Confirm Password too short'
                  : (input.length < 10 && input.isNotEmpty)
                      ? 'Invalid Confirm Password'
                      : null,
          obscureText: _isConfirmPasswordVisible ? false : true,
          decoration: InputDecoration(
            suffixIcon: IconButton(
                icon: Icon(_isConfirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                }),

            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            hintText: "Confirm Password",
            hintStyle: FontUtil.style(
                FontSizeUtil.Medium, SizeWeight.Regular, context),
            //    hintStyle: TextStyle(color: Colors.black),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: WidgetColors.primaryColor),
              borderRadius: BorderRadius.circular(5.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ),
    );
  }

  Future changePassword(BuildContext context) async {
    if (!StringUtil.notEmptyNull(oldPasswordText.text)) {
      UiUtil.showAlert(context, BaseConstant.APPNAME,
          "Please Enter Old Password", null, true);
      return;
    }
    if (!StringUtil.notEmptyNull(newPasswordText.text)) {
      UiUtil.showAlert(context, BaseConstant.APPNAME,
          "Please Enter new Password ", null, true);
      return;
    }
    if (newPasswordText.text.length < 8) {
      UiUtil.showAlert(context, BaseConstant.APPNAME,
          "Password should be mininum 8 character ", null, true);
      return;
    }

    if (!StringUtil.notEmptyNull(confirmPasswordText.text)) {
      UiUtil.showAlert(context, BaseConstant.APPNAME,
          "Please Enter Confirm Password ", null, true);
      return;
    }
    if (newPasswordText.text != confirmPasswordText.text) {
      UiUtil.showAlert(
          context, BaseConstant.APPNAME, "Password MisMatch ", null, true);
      return;
    }

    int userid = user!.id!;
    ChangePasswordReq changePasswordReq =
        ChangePasswordReq(userid, oldPasswordText.text, newPasswordText.text);

    buttonLoadingState(true);
    HttpObj.instance
        .getClient()
        .changePassword(changePasswordReq.id, changePasswordReq.oldpassword,
            changePasswordReq.newpassword)
        .then((value) {
      buttonLoadingState(false);
      if (value.sTATUS == BaseKey.SUCCESS) {
        UiUtil.toastPrint(value.mESSAGE!);
        clearTextFieldValue();
        return;
      }
      UiUtil.toastPrint(BaseConstant.SOMETHING_WENT_WRONG);
    }).catchError((Object obj) {
      buttonLoadingState(false);
      CommonException().showException(context, obj);
    });
  }

  void buttonLoadingState(bool stateLoad) {
    setState(() {
      buttonLoading = stateLoad;
    });
  }

  getAlert(String value, String desc) {
    if (!StringUtil.notEmptyNull(value)) {
      UiUtil.showAlert(context, BaseConstant.APPNAME,
          "Please Select the Date of Birth", null, true);
      return;
    }
  }
}
