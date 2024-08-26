import 'dart:io';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphics_news/Assets/d_o_b_icon_icons.dart';
import 'package:graphics_news/Authutil/shared_manager.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/StringUtil.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/social_login_req.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Auth/Login.dart';
import 'package:graphics_news/util/LoadingIndicator.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class SocialRegister extends StatefulWidget {
  SocialLoginReq? socialLoginReq;
  String? socialLoginType;

  SocialRegister({Key? key, this.socialLoginReq, this.socialLoginType})
      : super(key: key);

  @override
  _SocialRegisterState createState() => _SocialRegisterState();
}

class _SocialRegisterState extends State<SocialRegister> {
  final GlobalKey<FormState> _key1 = GlobalKey();

  DateTime selectedDate = DateTime.now();
  bool buttonLoading = false;
  bool _validate = false;

  var fullName,
      email,
      phone,
      dob,
      password,
      country = "GHA",
      refferedby,
      gender,
      refercode = "";
  var fullNameText = TextEditingController();
  var emailText = TextEditingController();
  var phoneText = TextEditingController();
  var dobText = TextEditingController();

  var passwordText = TextEditingController();
  var referredbyText = TextEditingController();
  var genderByText = TextEditingController();
  var referredCode = TextEditingController();

  var registerationUserData;
  String? selectedValue;
  String? GenderselectedValue = BaseKey.MR;

  @override
  void initState() {
    super.initState();
    /*if(widget.socialLoginReq!.dob.isNotEmpty){
      dobText = TextEditingController(text: widget.socialLoginReq!.dob);
    }else{
      dobText = TextEditingController();
    }*/

    if (widget.socialLoginReq!.gender.isNotEmpty) {
      if (widget.socialLoginReq!.gender == BaseKey.FEMALE) {
        GenderselectedValue = BaseKey.MS;
      }
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
        dobText.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        print(dob);
      });
  }

  @override
  Widget build(BuildContext context) {
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
                  height: 24.0,
                ),
                nextButton(),
                SizedBox(
                  height: 10.0,
                ),
                loginButton(),
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
        'Please Fill all Fields are mandatory',
        style: FontUtil.style(
          FontSizeUtil.XLarge,
          SizeWeight.Bold,
          context,
        ),
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
          Padding(
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
          dobTextFormField(),
          SizedBox(
            height: 10.0,
          ),
          /*  passwordTextFormField(),
          SizedBox(
            height: 10.0,
          ),*/
          countryTextFormField(),
          SizedBox(
            height: 10.0,
          ),
          refferedByTextField(),
          SizedBox(
            height: 10.0,
          ),
          dropdown(),
          SizedBox(
            height: 10.0,
          )
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
          readOnly: true,
          enableInteractiveSelection: false,
          cursorColor: WidgetColors.primaryColor,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            hintText: widget.socialLoginReq!.name,
            hintStyle: FontUtil.style(
              FontSizeUtil.Medium,
              SizeWeight.Regular,
              context,
              ModeTheme.getDefault(context),
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

  Widget emailTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        elevation: 1.0,
        child: TextFormField(
          readOnly: true,
          enableInteractiveSelection: false,
          cursorColor: WidgetColors.primaryColor,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            hintText: widget.socialLoginReq!.email,
            hintStyle: FontUtil.style(
              FontSizeUtil.Medium,
              SizeWeight.Regular,
              context,
              ModeTheme.getDefault(context),
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
          style: FontUtil.style(
            FontSizeUtil.Medium,
            SizeWeight.Regular,
            context,
            ModeTheme.getDefault(context),
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _selectDate(context);
          },
          keyboardType: TextInputType.datetime,
          cursorColor: WidgetColors.primaryColor,
          controller: dobText,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
            hintStyle: FontUtil.style(
              FontSizeUtil.Medium,
              SizeWeight.Regular,
              context,
              ModeTheme.getDefault(context),
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
              obscureText: true,
              cursorColor: WidgetColors.primaryColor,
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
          country = countries.iso3Code.toString();
          print(country);
        });
        print("jhadhjas$country");
      },
      itemBuilder: (Country country) {
        return Row(
          children: <Widget>[
            SizedBox(width: 8.0),
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(width: 8.0),
            Expanded(
                child: Text(
              country.name,
              style: FontUtil.style(
                FontSizeUtil.Medium,
                SizeWeight.Regular,
                context,
                ModeTheme.getDefault(context),
              ),
            )),
          ],
        );
      },
      itemHeight: null,
      isExpanded: true,
      initialValue: "GH",
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
          keyboardType: TextInputType.name,
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
          keyboardType: TextInputType.datetime,
          cursorColor: WidgetColors.primaryColor,
          controller: referredbyText,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            hintText: "Referral Code",
            hintStyle: FontUtil.style(
              FontSizeUtil.Medium,
              SizeWeight.Regular,
              context,
              ModeTheme.getDefault(context),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: WidgetColors.primaryColor),
              borderRadius: BorderRadius.circular(5.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          onSaved: (input) => refferedby = input,
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
                sendToNextScreen(context);
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

/*unused */
  Widget loginButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Login(
                      isGuestUserNav: false,
                    )));
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

  List<DropdownMenuItem<String>> get genderDropDown {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text(
            "Mr",
            style: FontUtil.style(
              FontSizeUtil.Medium,
              SizeWeight.Regular,
              context,
              ModeTheme.getDefault(context),
            ),
          ),
          value: BaseKey.MR),
      DropdownMenuItem(
          child: Text(
            "Miss",
            style: FontUtil.style(
              FontSizeUtil.Medium,
              SizeWeight.Regular,
              context,
              ModeTheme.getDefault(context),
            ),
          ),
          value: BaseKey.MISS),
      DropdownMenuItem(
          child: Text(
            "Ms",
            style: FontUtil.style(
              FontSizeUtil.Medium,
              SizeWeight.Regular,
              context,
              ModeTheme.getDefault(context),
            ),
          ),
          value: BaseKey.MS),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("NewsPaper"), value: "NewsPaper"),
      DropdownMenuItem(child: Text("Radio/TV"), value: "Radio/TV"),
      DropdownMenuItem(child: Text("Online Advert"), value: "Online Advert"),
      DropdownMenuItem(child: Text("Referral"), value: "Referral"),
      DropdownMenuItem(child: Text("At an event"), value: "At an event"),
      DropdownMenuItem(child: Text("Other"), value: "Other"),
    ];
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
                  style: FontUtil.style(
                    FontSizeUtil.Medium,
                    SizeWeight.Regular,
                    context,
                    ModeTheme.getDefault(context),
                  ),
                ),
                style: FontUtil.style(
                  FontSizeUtil.Medium,
                  SizeWeight.Regular,
                  context,
                  ModeTheme.getDefault(context),
                ),
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
    if (_key1.currentState!.validate()) {
      _key1.currentState!.save();
      socialloginApi();
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  Future<void> socialloginApi() async {
    buttonloadingstate(true);

    if (GenderselectedValue == BaseKey.MR) {
      gender = "M";
    } else {
      gender = "F";
    }
    SocialLoginReq req = widget.socialLoginReq!;
    req.gender = gender;
    req.dob = dob;
    req.countryCode = country;
    req.device_id = getId().toString();
    req.phone = phone ?? BaseConstant.EMPTY;
    req.referCode = refercode;
    req.referredFrom = refferedby ?? BaseConstant.EMPTY;
    HttpObj.instance
        .getAuth()
        .getSociallogin(
            req.name,
            req.email,
            req.social_id,
            req.platform,
            req.device_id,
            req.countryCode,
            req.dob,
            req.gender,
            req.phone,
            req.referredFrom,
            req.referCode)
        .then((it) {
      buttonloadingstate(false);
      if (it.sTATUS == BaseKey.SUCCESS) {
        if (it.DATA!.accessToken != null) {
          SharedManager.instance.savedDataLocal(it);
          OneSignal.shared.setExternalUserId(it.DATA!.user!.id.toString());
          RouteMap.getHome(context);
          return;
        }
      }

      UiUtil.showAlert(context, BaseConstant.APPNAME,
          StringUtil.getErrorMsg(it.MESSAGE), null, true);
      SharedManager.instance.deleteToken();

      // return it;
    }).catchError((Object obj) {
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
