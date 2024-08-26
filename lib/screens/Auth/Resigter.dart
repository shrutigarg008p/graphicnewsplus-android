import 'dart:io';
import 'dart:math';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphics_news/Assets/d_o_b_icon_icons.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/StringUtil.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_response.dart';
import 'package:graphics_news/Utility/internet_util.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/response/heard_from_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Auth/social_login_page.dart';
import 'package:graphics_news/util/LoadingIndicator.dart';
import 'package:intl/intl.dart';

class Register extends StatefulWidget {
  bool isGuestUserNav = false;

  Register({Key? key, required this.isGuestUserNav}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _key1 = GlobalKey();

  DateTime selectedDate = DateTime.now();
  bool buttonLoading = false;
  bool _validate = false;
  bool? exception;
  bool _isObscure = true;
  HeardFromResponse? heardFromResponse;
  String randomnumber1 = " ";
  String randomnumber2 = " ";

  @override
  void initState() {
    super.initState();
    Random random = new Random();
    randomnumber1 = random.nextInt(100).toString();
    randomnumber2 = random.nextInt(100).toString();
    heardFrom(context);
  }

  heardFrom(BuildContext context) async {
    HttpObj.instance.getAuth().getHeardFromList().then((it) {
      String msg = BaseConstant.SERVER_ERROR;
      if (it.sTATUS == BaseKey.SUCCESS) {
        setState(() {
          heardFromResponse = it;
          setException(false);
        });
      }
      if (it.MESSAGE != null && it.MESSAGE!.isNotEmpty) {
        msg = it.MESSAGE!;
      }
    }).catchError((Object obj) {
      // non-200 error goes here.
      setException(true);
      CommonException().showAuthException(context, obj);
    });
  }

  setException(bool? value) {
    if (mounted) {
      setState(() {
        exception = value;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    var now = new DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950, 1),
        lastDate: now);
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dobText.text = DateFormat('dd-MM-yyyy').format(selectedDate);
        print(dob);
      });
  }

  var fullName,
      email,
      phone,
      dob,
      password,
      countryIOSCode = BaseKey.DEFALUT_COUNTRY_CODE,
      refferedby,
      gender,
      refercode;

  var fullNameText = TextEditingController();
  var emailText = TextEditingController();
  var phoneText = TextEditingController();
  var dobText = TextEditingController();
  var passwordText = TextEditingController();
  var referredbyText = TextEditingController();
  var genderByText = TextEditingController();
  var referredCode = TextEditingController();
  var captchsum = TextEditingController();

  var registerationUserData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildRegister(context),
    );
  }

  VoidCallback retryCallback() {
    VoidCallback voidcallback = () => {setException(null), heardFrom(context)};
    return voidcallback;
  }

  buildRegister(BuildContext context) {
    return CommonWidget(context).getObjWidget(heardFromResponse, exception,
        myLayoutWidget(context, heardFromResponse), retryCallback());
  }

  Widget myLayoutWidget(
      BuildContext context, HeardFromResponse? heardFromResponse) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
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
                  height: 10.0,
                ),
                toContinueText(),
                SizedBox(
                  height: 10.0,
                ),
                toCaptchacontainer(),
                SizedBox(
                  height: 10.0,
                ),
                nextButton(),
                SizedBox(
                  height: 10.0,
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
                  height: 10.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginOptionText() {
    return Container(
        child: Text(
      BaseConstant.OR_LOGIN_USING,
      style: TextStyle(
        color: ModeTheme.getDefault(context),
        fontSize: FontSizeUtil.XLarge,
      ),
    ));
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
      'Create Graphic NewsPlus account',
      style: FontUtil.style(17, SizeWeight.Medium, context),
    ));
  }

  Widget toContinueText() {
    return Container(
        child: Text(
      'To Continue, please solve the following equation:',
      style: FontUtil.style(12, SizeWeight.SemiBold, context),
    ));
  }

  Widget toCaptchacontainer() {
    return Padding(
      padding: const EdgeInsets.only(left: 120.0, right: 0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            randomnumber1,
            style: FontUtil.style(22, SizeWeight.Regular, context),
          ),
          Text(
            '+',
            style: FontUtil.style(22, SizeWeight.Regular, context),
          ),
          Text(
            randomnumber2,
            style: FontUtil.style(22, SizeWeight.Regular, context),
          ),
          Text(
            '=',
            style: FontUtil.style(22, SizeWeight.Regular, context),
          ),
          new Flexible(child: captchaSumtextfield()),
        ],
      ),
    );
  }

  Widget loginForm() {
    return Container(
        child: Form(
      key: _key1,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          /*   Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Genderdropdown(),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Expanded(
                  child: fullNameTextFormField(),
                  flex: 3,
                ),
              ],
            ),
          ),*/
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: fullNameTextFormField(),
          ),

          SizedBox(
            height: 10.0,
          ),
          emailTextFormField(),
          SizedBox(
            height: 10.0,
          ),
          phoneTextFormField(),
          SizedBox(
            height: 10.0,
          ),
          // dobTextFormField(),
          /*  SizedBox(
            height: 10.0,
          ),*/
          passwordTextFormField(),
          SizedBox(
            height: 10.0,
          ),
          countryTextFormField(),
          SizedBox(
            height: 10.0,
          ),
          // referCodeTextFormField(),
          // SizedBox(
          //   height: 10.0,
          // ),
          refferedByTextField(),
          SizedBox(
            height: 10.0,
          ),
          heardFromResponse != null && heardFromResponse!.DATA!.length > 0
              ? dropdown()
              : Container(),
        ],
      ),
    ));
  }

  Widget fullNameTextFormField() {
    return Container(
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        elevation: 1.0,
        child: TextFormField(
          controller: fullNameText,
          keyboardType: TextInputType.name,
          cursorColor: WidgetColors.primaryColor,
          inputFormatters: [
            LengthLimitingTextInputFormatter(80),
          ],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (input) {
            if (input!.isEmpty) {
              return 'Enter Fullname';
            }
            return null;
          },
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            hintText: "Full Name",
            hintStyle: TextStyle(
              color: ModeTheme.getDefault(context),
              fontSize: FontSizeUtil.XLarge,
            ),
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
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        elevation: 1.0,
        child: TextFormField(
          controller: emailText,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.emailAddress,
          cursorColor: WidgetColors.primaryColor,
          inputFormatters: [
            LengthLimitingTextInputFormatter(80),
          ],
          validator: (input) => input!.isEmpty
              ? 'Enter email'
              : EmailValidator.validate(input)
                  ? null
                  : 'Invalid Email',
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            hintText: "Email",
            hintStyle: TextStyle(
              color: ModeTheme.getDefault(context),
              fontSize: FontSizeUtil.XLarge,
            ),
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

  Widget captchaSumtextfield() {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0, right: 120.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        elevation: 1.0,
        child: TextField(
          style: FontUtil.style(22, SizeWeight.Regular, context),
          controller: captchsum,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            hintText: " ",
            hintStyle: TextStyle(
              color: ModeTheme.getDefault(context),
              fontSize: FontSizeUtil.XLarge,
            ),
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

  Widget phoneTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        elevation: 1.0,
        child: TextFormField(
          controller: phoneText,
          inputFormatters: [new LengthLimitingTextInputFormatter(12)],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.phone,
          cursorColor: WidgetColors.primaryColor,
          validator: (input) => input!.isEmpty
              ? 'Enter Phone'
              : (input.length < 3 && input.isNotEmpty)
                  ? 'Phone too short'
                  : (input.length < 10 && input.isNotEmpty)
                      ? 'Invalid Phone'
                      : null,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            hintText: "Phone",
            hintStyle: TextStyle(
              color: ModeTheme.getDefault(context),
              fontSize: FontSizeUtil.XLarge,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: WidgetColors.primaryColor),
              borderRadius: BorderRadius.circular(5.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          onSaved: (input) => phone = input,
        ),
      ),
    );
  }

  Widget dobTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        elevation: 1.0,
        child: TextFormField(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _selectDate(context);
          },
          keyboardType: TextInputType.datetime,
          cursorColor: WidgetColors.primaryColor,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: dobText,
          validator: (input) {
            if (input!.isEmpty) {
              return 'Dob Is Required';
            }
            return null;
          },
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            hintText: "Date of Birth",
            hintStyle: TextStyle(
              color: ModeTheme.getDefault(context),
              fontSize: FontSizeUtil.XLarge,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                DOBIcon.date_of_birth_calender,
                color: Colors.grey,
              ),
              onPressed: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                _selectDate(context);
              },
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: WidgetColors.primaryColor),
              borderRadius: BorderRadius.circular(5.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          onSaved: (input) => dob = input,
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.name,
              obscureText: _isObscure,
              cursorColor: WidgetColors.primaryColor,
              validator: (input) {
                if (input!.length < 8) {
                  return 'Password should be mininum 8 character ';
                }
                return null;
              },
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  hintText: "Password",
                  hintStyle: TextStyle(
                    color: ModeTheme.getDefault(context),
                    fontSize: FontSizeUtil.XLarge,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: WidgetColors.primaryColor),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      })),
              onSaved: (input) => password = input,
            )));
  }

  Widget countryTextFormField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: Colors.grey, width: 1)),
      child: _buildCountryPickerDropdownSoloExpanded(),
    );
  }

  _buildCountryPickerDropdownSoloExpanded() {
    return CountryPickerDropdown(
      underline: Container(
        //     height: 2,
        color: Colors.transparent,
      ),
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      onValuePicked: (Country countries) {
        print("${countries.isoCode}");

        setState(() {
          countryIOSCode = countries.isoCode.toString();
        });
        print("jhadhjas$countryIOSCode");
      },
      itemBuilder: (Country country) {
        return Row(
          children: <Widget>[
            SizedBox(width: 8.0),
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(width: 8.0),
            Expanded(
                child: Text(country.name,
                    style: TextStyle(
                      color: ModeTheme.getDefault(context),
                      fontSize: FontSizeUtil.XLarge,
                    ))),
          ],
        );
      },
      itemHeight: null,
      isExpanded: true,
      initialValue: countryIOSCode,
      icon: Icon(Icons.keyboard_arrow_down_outlined),
    );
  }

  Widget referCodeTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        elevation: 1.0,
        child: TextFormField(
          controller: referredCode,
          keyboardType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9_]')),
          ],
          cursorColor: WidgetColors.primaryColor,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            hintText: "Referral Code (Optional)",
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: WidgetColors.primaryColor),
              borderRadius: BorderRadius.circular(5.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          onSaved: (input) => refercode = input!,
        ),
      ),
    );
  }

  Widget refferedByTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        elevation: 1.0,
        child: TextFormField(
          onTap: () {
            print("Tap");
          },
          cursorColor: WidgetColors.primaryColor,
          controller: referredbyText,
          keyboardType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9_]')),
          ],
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            hintText: "Referral Code",
            hintStyle: TextStyle(
              color: ModeTheme.getDefault(context),
              fontSize: FontSizeUtil.XLarge,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: WidgetColors.primaryColor),
              borderRadius: BorderRadius.circular(5.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          onSaved: (input) => refercode = input,
        ),
      ),
    );
  }

  Widget nextButton() {
    return buttonLoading
        ? LoadingIndicator()
        : Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: ElevatedButton(
              onPressed: () {
                int total;
                InternetUtil.check().then((value) => {
                      if (value)
                        {
                          if (_key1.currentState!.validate())
                            {
                              _key1.currentState!.save(),
                              total = int.parse(randomnumber1) +
                                  int.parse(randomnumber2),
                              if (!captchsum.text.isEmpty &&
                                  total == int.parse(captchsum.text))
                                {sendToNextScreen(context)}
                              else
                                {
                                  UiUtil.toastPrint(
                                      "Captcha verification failed!")
                                }
                            }
                          else
                            {
                              setState(() {
                                _validate = true;
                              })
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
                'SIGN UP',
                style: FontUtil.style(
                    14, SizeWeight.Medium, context, Colors.white),
              ),
            ),
          );
  }

  Widget loginButton() {
    return GestureDetector(
      onTap: () {
        RouteMap.onBack(context);
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: ModeTheme.blackOrGrey(context)),
            borderRadius: BorderRadius.circular(5.0)),
        margin: EdgeInsets.symmetric(horizontal: 40),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          "Existing User? Login",
          textAlign: TextAlign.center,
          style: FontUtil.style(14, SizeWeight.Medium, context),
        ),
      ),
    );
  }

  String? selectedValue;
  String? GenderselectedValue = BaseKey.MR;

  List<DropdownMenuItem<String>> get genderDropDown {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Mr"), value: BaseKey.MR),
      DropdownMenuItem(child: Text("Miss"), value: BaseKey.MISS),
      DropdownMenuItem(child: Text("Ms"), value: BaseKey.MS),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [];
    for (var item in heardFromResponse!.DATA!) {
      menuItems.add(DropdownMenuItem(child: Text(item), value: item));
    }

    // List<DropdownMenuItem<String>> menuItems = [
    //   DropdownMenuItem(child: Text("NewsPaper"), value: "NewsPaper"),
    //   DropdownMenuItem(child: Text("Radio/TV"), value: "Radio/TV"),
    //   DropdownMenuItem(child: Text("Online Advert"), value: "Online Advert"),
    //   DropdownMenuItem(child: Text("Referral"), value: "Referral"),
    //   DropdownMenuItem(child: Text("At an event"), value: "At an event"),
    //   DropdownMenuItem(child: Text("Other"), value: "Other"),
    // ];
    return menuItems;
  }

  Widget dropdown() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Material(
            borderRadius: BorderRadius.circular(5.0),
            elevation: 1.0,
            child: DropdownButtonFormField(
                hint: Text(
                  'How did you hear about us?',
                  style: TextStyle(
                      fontSize: FontSizeUtil.XLarge,
                      color: ModeTheme.getDefault(context)),
                ),
                style: TextStyle(
                    fontSize: FontSizeUtil.Large,
                    color: ModeTheme.getDefault(context)),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: WidgetColors.primaryColor),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                //  dropdownColor: Colors.white,
                value: selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
                onSaved: (input) => refferedby = input,
                items: dropdownItems)));
  }

  Widget Genderdropdown() {
    return Container(
        child: Material(
            borderRadius: BorderRadius.circular(5.0),
            elevation: 1.0,
            child: DropdownButtonFormField(
                hint: Text(
                  '',
                  style: TextStyle(
                      fontSize: FontSizeUtil.XLarge,
                      color: ModeTheme.getDefault(context)),
                ),
                style: TextStyle(
                    fontSize: FontSizeUtil.Large,
                    color: ModeTheme.getDefault(context)),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: WidgetColors.primaryColor),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                //  dropdownColor: Colors.white,
                value: GenderselectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    print("newValue" + newValue!);
                    GenderselectedValue = newValue;
                  });
                },
                onSaved: (input) => gender = input,
                items: genderDropDown)));
  }

  Future sendToNextScreen(BuildContext context) async {
    buttonloadingstate(true);
    /*String gender;
      if (GenderselectedValue == BaseKey.MR) {
        gender = "M";
      } else {
        gender = "F";
      }*/

    HttpObj.instance
        .getAuth()
        .getRegister(
            fullName,
            email,
            password,
            phone,
            dob ?? "",
            countryIOSCode,
            getId().toString(),
            refferedby ?? "",
            refercode.toString().toUpperCase(),
            "")
        .then((it) {
      String msg = BaseConstant.SERVER_ERROR;
      /*   if (it.sTATUS == BaseKey.SUCCESS &&
          it.DATA != null &&
          it.DATA!.accessToken != null) {
        SessionManager().savedDataLocal(it);
        print(it.DATA!.user!);
        OneSignal.shared.setExternalUserId(it.DATA!.user!.id.toString());
        RouteMap().getHome(context);
        return;
      }*/
      // print('datat');

      if (it.sTATUS == BaseKey.FAILURE) {
        RouteMap.onBack(context);
      }
      if (StringUtil.notEmptyNull(it.MESSAGE)) {
        msg = it.MESSAGE!;
      }
      UiUtil.showAlert(context, BaseConstant.APPNAME, msg, null, true);
      buttonloadingstate(false);
    }).catchError((Object obj) {
      // RouteMap.onBack(context);
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
}
