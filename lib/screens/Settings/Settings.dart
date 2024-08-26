import 'package:flutter/material.dart';
import 'package:graphics_news/Authutil/shared_manager.dart';
import 'package:graphics_news/Authutil/theme_manager.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/common_app_bar.dart';
import 'package:graphics_news/common_widget/common_drawer.dart';
import 'package:graphics_news/common_widget/title_header.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/screens/Home/Splash_screen.dart';
import 'package:graphics_news/screens/Information%20Screens/About_us.dart';
import 'package:graphics_news/screens/Settings/setting_mobile_data.dart';
import 'package:graphics_news/screens/Settings/setting_notification.dart';
import 'package:graphics_news/screens/Settings/setting_preference_header.dart';
import 'package:graphics_news/util/LoadingIndicator.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List settingsListHeadings = [
    'Allow Notifications',
    'Night Mode',
    'Font Size',
    'Change Password',
  ];

  List legalListItems = [
    BaseKey.ABOUT_US_KEY,
    BaseKey.PRIVACY_POLICY_KEY,
    BaseKey.POLICIES_LICENSE_KEY,
    BaseKey.COURTESIES_KEY
  ];

  bool? darkTheme;

  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  late List<bool> isSelected;
  bool? notification;
  dynamic mobileData;

  @override
  void initState() {
    super.initState();
    getData();
    isSelected = [
      SplashScreen.selectedSize == 0 ? true : false,
      SplashScreen.selectedSize == 1 ? true : false,
      SplashScreen.selectedSize == 2 ? true : false,
    ];
  }

  void getData() {
    if (mounted) {
      setState(() {
        notification = SharedManager.instance.getNotification();
        mobileData = SharedManager.instance.getMobileData();
        darkTheme = SharedManager.instance.getDarkTheme();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //  print("textScale " + textScale.toString());
    if (notification == null) {
      return LoadingIndicator();
    }
    return Consumer<ThemeNotifier>(builder: (context, theme, _) {
      return Scaffold(
        appBar: CommonAppBar.getAppBar(
            context, () => scaffoldKey.currentState!.openDrawer()),
        key: scaffoldKey,
        drawer: CommonDrawer(),
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      TitleHeader(
                        title: "Settings",
                      ),
                      //   allowNotification(),
                      SettingNotification(
                        notification: notification,
                      ),
                      nightMode(theme),
                      fontSize(),
                      SettingPreferenceHeader(),
                      TitleHeader(
                        title: "Downloads",
                      ),
                      SettingMobileData(
                        mobileData: mobileData,
                      ),

                      TitleHeader(
                        title: "Legal",
                      ),
                      legalList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget fontSize() {
    return Container(
        decoration: UiUtil.bottomBorder(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 16.0,
                    bottom: 16.0,
                  ),
                  child: Text(
                    "Font Size",
                    style: FontUtil.style(
                        FontSizeUtil.Medium, SizeWeight.Regular, context),
                  ),
                ),
                ToggleButtons(
                  borderWidth: 0,
                  borderColor: Colors.transparent,
                  fillColor: Colors.transparent,
                  selectedBorderColor: Colors.transparent,
                  selectedColor: WidgetColors.primaryColor,
                  color: Colors.grey,
                  children: [
                    Text('S', style: textStyle(0)),
                    Text('M', style: textStyle(1)),
                    Text('L', style: textStyle(2)),
                  ],
                  isSelected: isSelected,
                  onPressed: (index) {
                    for (int i = 0; i < isSelected.length; i++) {
                      if (i == index) {
                        SharedManager.instance.setFontSize(i);

                        SplashScreen.selectedSize = i;
                        isSelected[i] = true;
                      } else {
                        isSelected[i] = false;
                      }
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ],
        ));
  }

  Widget nightMode(ThemeNotifier theme) {
    return Container(
        decoration: UiUtil.bottomBorder(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 16.0,
                    bottom: 16.0,
                  ),
                  child: Text(
                    "Night Mode",
                    style: FontUtil.style(
                        FontSizeUtil.Medium, SizeWeight.Regular, context),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                      right: 20.0,
                    ),
                    child: Switch(
                      value: darkTheme!,
                      activeColor: Colors.black,
                      activeTrackColor: Colors.grey[300],
                      inactiveTrackColor: Colors.grey[300],
                      inactiveThumbColor: WidgetColors.primaryColor,
                      onChanged: (value) {
                        setTheme(value, theme);
                      },
                    ))
              ],
            ),
          ],
        ));
  }

  setTheme(bool value, ThemeNotifier theme) {
    if (mounted) {
      setState(() {
        darkTheme = value;
        if (value) {
          theme.setDarkMode();
        } else {
          theme.setLightMode();
        }
      });
    }
  }

  Widget legalList() {
    return Container(
        child: ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: legalListItems.length,
      itemBuilder: (context, index) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 16.0,
                  bottom: 16.0,
                ),
                child: Text(
                  legalListItems[index],
                  style: FontUtil.style(
                      FontSizeUtil.Medium, SizeWeight.Regular, context),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 20.0,
                ),
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Aboutus(type: legalListItems[index])));
                    },
                    icon: Icon(Icons.arrow_forward_ios)),
              ),
            ],
          ),
          index == legalListItems.length - 1
              ? Container()
              : Container(
                  decoration: UiUtil.bottomBorder(),
                )
        ],
      ),
    ));
  }

  textStyle(int index) {
    return FontUtil.style(
        FontSizeUtil.Large,
        isSelected[index] == true ? SizeWeight.SemiBold : SizeWeight.Medium,
        context);
  }
}
