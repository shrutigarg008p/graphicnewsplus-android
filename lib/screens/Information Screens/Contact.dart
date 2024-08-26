import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:graphics_news/Authutil/shared_manager.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/StringUtil.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/common_app_bar.dart';
import 'package:graphics_news/common_widget/common_drawer.dart';
import 'package:graphics_news/common_widget/common_filled_btn.dart';
import 'package:graphics_news/common_widget/common_social_redirection.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/auth_dto.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/util/LoadingIndicator.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _contactUsKey = GlobalKey();
  dynamic mediaQueryData;
  bool buttonLoading = false;
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  var fullName, email, subject, feedback;
  var fullNameText = TextEditingController();
  var emailText = TextEditingController();
  var subjectText = TextEditingController();
  var feedbackText = TextEditingController();
  User? user;

  @override
  void initState() {
    super.initState();
    if (RouteMap.isLogin()) {
      getUser();
    } else {
      user = new User();
    }
  }

  void getUser() {
    if (mounted) {
      setState(() {
        user = SharedManager.instance.getUserDetail();
        if (user != null) {
          fullNameText.text = StringUtil.getValue(user!.firstName) +
              BaseConstant.EMPTY_SPACE +
              StringUtil.getValue(user!.lastName);
          emailText.text = StringUtil.getValue(user!.email);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Container();
    }
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: CommonAppBar.getAppBar(
          context, () => scaffoldKey.currentState!.openDrawer()),
      drawer: CommonDrawer(),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                  child: Container(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Form(
                    key: _contactUsKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 32.0,
                        ),
                        contactText(),
                        SizedBox(
                          height: 16.0,
                        ),
                        contactContent(),
                        SizedBox(
                          height: 24.0,
                        ),
                        fullNameTextFormField(),
                        SizedBox(
                          height: 10.0,
                        ),
                        emailTextFormField(),
                        SizedBox(
                          height: 10.0,
                        ),
                        subjctTextFormField(),
                        SizedBox(
                          height: 10.0,
                        ),
                        feedbackTextFormField(),
                        SizedBox(
                          height: 18.0,
                        ),
                        buttonLoading
                            ? LoadingIndicator()
                            : CommonFilledBtn(
                                btnName: "Submit",
                                onTap: () {
                                  contactUs(context);
                                  /* if (RouteMap.isLogin()) {
                                    contactUs(context);
                                  } else {
                                    RouteMap().logOutSession(context);
                                  }*/
                                },
                              ),
                        SizedBox(
                          height: 28.0,
                        ),
                        contactOptionsIcons(),
                        SizedBox(
                          height: 28.0,
                        ),
                        addressCard(),
                        SizedBox(
                          height: 38.0,
                        ),
                      ],
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget contactText() {
    return Container(
      child: Text(
        'Contact Us',
        style: FontUtil.style(FontSizeUtil.XLarge, SizeWeight.Bold, context),
      ),
    );
  }

  Widget contactContent() {
    return Container(
      margin: EdgeInsets.only(left: 18.0, right: 18.0),
      child: Text(
        "Kindly fill in your details and feedback so we can get in touch",
        style: FontUtil.style(FontSizeUtil.Medium, SizeWeight.Regular, context),
      ),
    );
  }

  Widget fullNameTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        elevation: 1.0,
        child: TextFormField(
          controller: fullNameText,
          keyboardType: TextInputType.name,
          cursorColor: WidgetColors.primaryColor,
          style: FontUtil.style(FontSizeUtil.Medium, SizeWeight.Regular,
              context, ModeTheme.getDefault(context)),
          validator: (input) => input!.isEmpty
              ? 'Enter Full Name'
              : (input.length < 4 && input.isNotEmpty)
                  ? 'Full Name should be at least 4 characters'
                  : (input.length > 21)
                      ? "Full Name should be at max 20 characters"
                      : null,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            hintText: "Full Name",
            hintStyle: FontUtil.style(FontSizeUtil.Medium, SizeWeight.Regular,
                context, ModeTheme.whiteGrey(context)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: WidgetColors.primaryColor),
              borderRadius: BorderRadius.circular(5.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          onSaved: (input) => fullName = input,
        ),
      ),
    );
  }

  Widget emailTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        elevation: 1.0,
        child: TextFormField(
          controller: emailText,
          keyboardType: TextInputType.emailAddress,
          cursorColor: WidgetColors.primaryColor,
          style: FontUtil.style(FontSizeUtil.Medium, SizeWeight.Regular,
              context, ModeTheme.getDefault(context)),
          validator: (input) => input!.isEmpty
              ? 'Enter email'
              : EmailValidator.validate(input)
                  ? null
                  : 'Invalid Email',
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            hintText: "Email",
            hintStyle: FontUtil.style(FontSizeUtil.Medium, SizeWeight.Regular,
                context, ModeTheme.getDefault(context)),
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

  Widget subjctTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        elevation: 1.0,
        child: TextFormField(
          controller: subjectText,
          keyboardType: TextInputType.name,
          cursorColor: WidgetColors.primaryColor,
          style: FontUtil.style(FontSizeUtil.Medium, SizeWeight.Regular,
              context, ModeTheme.getDefault(context)),
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            hintText: "Subject (Optional)",
            hintStyle: FontUtil.style(FontSizeUtil.Medium, SizeWeight.Regular,
                context, ModeTheme.getDefault(context)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: WidgetColors.primaryColor),
              borderRadius: BorderRadius.circular(5.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          onSaved: (input) => subject = input,
        ),
      ),
    );
  }

  Widget feedbackTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        elevation: 1.0,
        child: TextFormField(
          controller: feedbackText,
          keyboardType: TextInputType.multiline,
          cursorColor: WidgetColors.primaryColor,
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          minLines: 5,
          maxLines: 5,
          style: FontUtil.style(FontSizeUtil.Medium, SizeWeight.Regular,
              context, ModeTheme.getDefault(context)),
          validator: (input) => input!.isEmpty
              ? 'Enter Feedback'
              : (input.length < 4 && input.isNotEmpty)
                  ? 'Feedback should be at least 4 characters'
                  : null,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            hintText: "Feedback/ Suggestion",
            hintStyle: FontUtil.style(FontSizeUtil.Medium, SizeWeight.Regular,
                context, ModeTheme.whiteGrey(context)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: WidgetColors.primaryColor),
              borderRadius: BorderRadius.circular(5.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          onSaved: (input) => feedback = input,
        ),
      ),
    );
  }

  Widget contactOptionsIcons() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Image(
                image: AssetImage('images/facebook_grey.png'),
              ),
            ),
            onTap: () {
              CommonSocialRedirection.socialRedirection(BaseKey.FACEBOOK);
            },
          ),
          SizedBox(
            width: 10.0,
          ),
          GestureDetector(
            child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Image(
                  image: AssetImage('images/twitter_grey.png'),
                )),
            onTap: () {
              CommonSocialRedirection.socialRedirection(BaseKey.TWITTER);
            },
          ),
          SizedBox(
            width: 10.0,
          ),
          GestureDetector(
            onTap: () {
              CommonSocialRedirection.socialRedirection(BaseKey.INSTAGRAM);
            },
            child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Image(
                  image: AssetImage('images/instagram_grey.png'),
                )),
          ),
          SizedBox(
            width: 10.0,
          ),
          GestureDetector(
            onTap: () {
              CommonSocialRedirection.socialRedirection(BaseKey.YOUTUBE);
            },
            child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Image(
                  image: AssetImage('images/youtube_grey.png'),
                )),
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
    );
  }

  Widget addressCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        elevation: 5.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10.0,
                ),
                CircleAvatar(
                  radius: 17.0,
                  backgroundColor: WidgetColors.primaryColor,
                  child: Icon(
                    Icons.location_on,
                    size: 15.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      BaseKey.address_company,
                      maxLines: 10,
                      style: FontUtil.style(
                          FontSizeUtil.xsmall, SizeWeight.Regular, context),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10.0,
                ),
                CircleAvatar(
                  radius: 17.0,
                  backgroundColor: WidgetColors.primaryColor,
                  child: Icon(
                    Icons.phone,
                    size: 15.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      BaseKey.phone_number_company,
                      maxLines: 1,
                      style: FontUtil.style(
                          FontSizeUtil.xsmall, SizeWeight.Regular, context),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10.0,
                ),
                CircleAvatar(
                  radius: 17.0,
                  backgroundColor: WidgetColors.primaryColor,
                  child: Icon(
                    Icons.mail,
                    size: 15.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      BaseKey.company_email,
                      style: FontUtil.style(
                          FontSizeUtil.xsmall, SizeWeight.Regular, context),
                      maxLines: 1,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            )
          ],
        ),
      ),
    );
  }

  Future contactUs(BuildContext context) async {
    if (_contactUsKey.currentState!.validate()) {
      _contactUsKey.currentState!.save();

      buttonloadingstate(true);

      HttpObj.instance
          .getClient()
          .contactUs(user!.id == null ? 0 : user!.id!, fullName, email, subject,
              feedback)
          .then((it) {
        String msg = BaseConstant.SERVER_ERROR;
        if (it.sTATUS == BaseKey.SUCCESS) {
          print(it.MESSAGE);
          UiUtil.toastPrint(it.MESSAGE!);
          clearTextFieldValue();
          buttonloadingstate(false);
        } else {
          buttonloadingstate(false);
          UiUtil.toastPrint(BaseConstant.SOMETHING_WENT_WRONG);
        }
        buttonloadingstate(false);
        // return it;
      }).catchError((Object obj) {
        print(obj);
        buttonloadingstate(false);
        CommonException().showException(context, obj);
      });
    }
  }

  void buttonloadingstate(bool value) {
    setState(() {
      buttonLoading = value;
    });
  }

  void clearTextFieldValue() {
    if (user != null) {
      fullNameText.text = StringUtil.getValue(user!.firstName) +
          BaseConstant.EMPTY_SPACE +
          StringUtil.getValue(user!.lastName);
      emailText.text = StringUtil.getValue(user!.email);
    }
    subjectText.clear();
    feedbackText.clear();
  }
}
