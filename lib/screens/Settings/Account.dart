import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:graphics_news/Assets/d_o_b_icon_icons.dart';
import 'package:graphics_news/Authutil/shared_manager.dart';
import 'package:graphics_news/Authutil/theme_manager.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/StringUtil.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/internet_util.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/common_filled_btn.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/auth_dto.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/network/services/rest_client.dart';
import 'package:graphics_news/util/LoadingIndicator.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  late Future<DataUser> responseDatas;
  late String userName = "", email = "";
  Future<DataUser?>? responseData;
  User? user;
  var countryIOSCode = BaseKey.DEFALUT_COUNTRY_CODE;
  var countryName;
  DateTime selectedDate = DateTime.now();
  var dobController = TextEditingController();
  var gender;
  String? GenderselectedValue = BaseKey.SELECT;
  bool buttonLoading = false;

  List<DropdownMenuItem<String>> get genderDropDown {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Select"), value: BaseKey.SELECT),
      DropdownMenuItem(child: Text("Male"), value: BaseKey.MALE),
      DropdownMenuItem(child: Text("Female"), value: BaseKey.FEMALE),
      DropdownMenuItem(child: Text("Other"), value: BaseKey.OTHER),
    ];
    return menuItems;
  }

  void getUser() {
    if (mounted) {
      setState(() {
        user = SharedManager.instance.getUserDetail();
        setValue(user);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  setValue(User? user) {
    if (user!.dob != null) {
      dobController.text = user.dob!;
    }
    if (user.country != null) {
      countryIOSCode = user.country!; //iso3 code
    } else {}
    if (user.gender != null) {
      GenderselectedValue = user.gender;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Container();
    }

    return Consumer<ThemeNotifier>(builder: (context, theme, _) {
      return Scaffold(
        appBar: HeaderWidget.appHeader(BaseConstant.MY_PROFILE_HEADER, context),
        body: SafeArea(
          child: Container(
            child: ListView(
              children: [
                SizedBox(
                  height: 12.0,
                ),
                getTile("Name", StringUtil.getValue(user!.firstName),
                    BaseKey.key_name, context),
                UiUtil.horizontalLine(),
                getTile("Email", StringUtil.getValue(user!.email),
                    BaseKey.key_email, context),
                UiUtil.horizontalLine(),
                getTile("Phone Number", StringUtil.getValue(user!.phone),
                    BaseKey.key_email, context),
                if (user!.social_login == null) ...[
                  UiUtil.horizontalLine(),
                  getTile("Change Password", "*********",
                      BaseKey.key_change_password, context),
                ],
                UiUtil.horizontalLine(),
                getDOBTile(context),
                UiUtil.horizontalLine(),
                getGenderTile(context),
                UiUtil.horizontalLine(),
                getCountryTile(context),
                UiUtil.horizontalLine(),
                SizedBox(
                  height: 15.0,
                ),
                buttonLoading
                    ? LoadingIndicator()
                    : CommonFilledBtn(
                        btnName: BaseConstant.UPDATE,
                        onTap: () {
                          InternetUtil.check().then((value) => {
                                if (value)
                                  {UpdateData(context)}
                                else
                                  {InternetUtil.errorMsg(context)}
                              });
                        },
                      ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget Genderdropdown() {
    return Container(
        child: DropdownButtonFormField(
            decoration: InputDecoration(
              enabledBorder: InputBorder.none,
            ),
            hint: Text(
              '',
              style: TextStyle(
                  fontSize: FontSizeUtil.small,
                  color: ModeTheme.getDefault(context)),
            ),
            style: TextStyle(
                fontSize: FontSizeUtil.small,
                color: ModeTheme.getDefault(context)),
            value: GenderselectedValue,
            onChanged: (String? newValue) {
              setState(() {
                GenderselectedValue = newValue;
              });
            },
            onSaved: (input) => gender = input,
            items: genderDropDown));
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
        dobController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
  }

  Widget dobTextFormField() {
    return Container(
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        style: FontUtil.style(FontSizeUtil.small, SizeWeight.Regular, context),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDate(context);
        },
        keyboardType: TextInputType.datetime,
        cursorColor: WidgetColors.primaryColor,
        controller: dobController,
        decoration: InputDecoration(
          // contentPadding: EdgeInsets.fromLTRB(5, top, right, bottom),
          isDense: true,
          enabledBorder: InputBorder.none,
          hintText: "Date of Birth",
          hintStyle:
              FontUtil.style(FontSizeUtil.small, SizeWeight.Regular, context),
          suffixIcon: IconButton(
            icon: Icon(
              DOBIcon.date_of_birth_calender,
              size: 15,
              color: Colors.grey,
            ),
            onPressed: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              _selectDate(context);
            },
          ),
        ),
      ),
    );
  }

  getDOBTile(BuildContext context) {
    return ListTile(
        dense: true,
        title: Container(
            child: Row(
          children: [
            Expanded(flex: 2, child: TextLabel("Date of Birth *", context)),
            Expanded(flex: 1, child: dobTextFormField())
          ],
        )),
        onTap: () {});
  }

  getGenderTile(BuildContext context) {
    return ListTile(
        dense: true,
        title: Container(
            child: Row(
          children: [
            Expanded(flex: 4, child: TextLabel("Gender *", context)),
            Expanded(flex: 1, child: Genderdropdown())
          ],
        )),
        onTap: () {});
  }

  getCountryTile(BuildContext context) {
    return ListTile(
        dense: true,
        title: Container(
            child: Row(
          children: [
            Expanded(flex: 2, child: TextLabel("Country", context)),
            Expanded(
                flex: 1,
                child: _buildCountryPickerDropdownSoloExpanded(context))
          ],
        )),
        onTap: () {});
  }

  _buildCountryPickerDropdownSoloExpanded(BuildContext context) {
    return CountryPickerDropdown(
      isDense: true,
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      onValuePicked: (Country countries) {
        print("${countries.isoCode}");

        setState(() {
          countryIOSCode = countries.isoCode.toString();
          countryName = countries.name;
        });
        print("jhadhjas$countryIOSCode");
      },
      itemBuilder: (Country country) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 4.0),
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(width: 4.0),
            Expanded(child: TextValue(country.name, context)),
          ],
        );
      },
      itemHeight: null,
      isExpanded: true,
      initialValue: getInitialValue(countryIOSCode),
      icon: Icon(Icons.keyboard_arrow_down_outlined),
    );
  }

  getInitialValue(String countryIOSCode) {
    try {
      CountryPickerUtils.getCountryByIsoCode(countryIOSCode);
      countryName = CountryPickerUtils.getCountryByIsoCode(countryIOSCode).name;
      return countryIOSCode;
    } catch (error) {
      return BaseKey.DEFALUT_COUNTRY_CODE;
    }
  }

  getTile(String txtLabel, String txtvalue, String key, BuildContext context) {
    return ListTile(
        dense: true,
        title: TextLabel(txtLabel, context),
        trailing: key == BaseKey.key_change_password
            ? Icon(
                Icons.navigate_next,
                size: 30,
              )
            : TextValue(txtvalue, context),
        onTap: () {
          if (key == BaseKey.key_change_password) {
            RouteMap.changePassword(context);
          }
        });
  }

  TextLabel(String value, BuildContext context) {
    return Text(
      value,
      style: FontUtil.style(FontSizeUtil.small, SizeWeight.SemiBold, context),
    );
  }

  TextValue(String value, BuildContext context) {
    return Text(
      value,
      style: FontUtil.style(FontSizeUtil.small, SizeWeight.Regular, context),
    );
  }

  void buttonloadingstate(bool value) {
    setState(() {
      buttonLoading = value;
    });
  }

  Future UpdateData(BuildContext context) async {
    String name = StringUtil.getValue(user!.firstName);
    print(countryIOSCode);
    String countrytxt = countryIOSCode;
    String dob = dobController.text;
    String? gender = GenderselectedValue;

    if (!StringUtil.notEmptyNull(dob)) {
      UiUtil.showAlert(
          context, BaseConstant.APPNAME, BaseConstant.select_dob, null, true);
      return;
    }
    if (gender == BaseKey.SELECT) {
      UiUtil.showAlert(context, BaseConstant.APPNAME,
          BaseConstant.select_gender, null, true);
      return;
    }
    buttonloadingstate(true);
    HttpObj.instance
        .getClient()
        .updateProfile(name, "", countrytxt, dob, gender)
        .then((it) {
      buttonloadingstate(false);
      if (it.sTATUS == BaseKey.SUCCESS) {
        setOneSignalValues(
            HttpObj.instance.getClient(), gender, dob, countrytxt);
        user!.dob = dob;
        user!.country = countrytxt;
        user!.gender = gender;
        SharedManager.instance.setUserDetail(user);
        UiUtil.toastPrint(it.MESSAGE!);
        return;
      }
      UiUtil.toastPrint(BaseConstant.SOMETHING_WENT_WRONG);
      // return it;
    }).catchError((Object obj) {
      buttonloadingstate(false);
      CommonException().showException(context, obj);
    });
  }

  getAlert(String value, String desc) {
    if (!StringUtil.notEmptyNull(value)) {
      UiUtil.showAlert(context, BaseConstant.APPNAME,
          "Please Select the Date of Birth", null, true);
      return;
    }
  }

  void setOneSignalValues(
      RestClient client, String? gender, String dob, String countrytxt) async {
    var oneSignalGender;
    var age;
    var oneSignalAge;

    if (gender == 'f') {
      oneSignalGender = "female";
    } else if (gender == 'm') {
      oneSignalGender = "male";
    }
    age = int.parse(DateFormat('yyyy').format(DateTime.now())) -
        int.parse(dob.split('-').first);
    if (age > 17 && age < 45) {
      oneSignalAge = "18+";
    } else if (age > 44 && age < 60) {
      oneSignalAge = "45+";
    } else if (age > 59) {
      oneSignalAge = "60+";
    }

    OneSignal.shared.sendTags({
      "gender": oneSignalGender,
      "age": age,
      "country": countryName
    }).then((response) {
      print("Successfully sent tags with response: $response");
    }).catchError((error) {
      print("Encountered an error sending tags: $error");
    });
  }
}
