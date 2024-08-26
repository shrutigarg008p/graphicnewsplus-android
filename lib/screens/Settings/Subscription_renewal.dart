import 'package:flutter/material.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/constant/size_weight.dart';

import 'Account.dart';
import 'download/Download_page.dart';
import 'Refer_friend.dart';
import 'Subsciption.dart';

class Subscription_Renewal extends StatefulWidget {
  @override
  _Subscription_RenewalState createState() => _Subscription_RenewalState();
}

class _Subscription_RenewalState extends State<Subscription_Renewal> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int activeIndex = 1;
  List settingsTile = [
    'My Account',
    'My Subscription',
    'My Downloads',
    'Refer a Friend',
  ];

  List subscriptionListItems = [
    'Subscription Date',
    'Expiry Date',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30.0,
        centerTitle: false,
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
        title: Text(
          "My Profile",
          style: FontUtil.style(17, SizeWeight.SemiBold, context),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Divider(
                      thickness: 1.6,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 18.0,
                    ),
                    settingsListTile(),
                    SizedBox(
                      height: 18.0,
                    ),
                    notificationText('My Subscription'),
                    dailyGraphicText('Daily Graphic'),
                    Divider(
                      thickness: 1.6,
                      color: Colors.grey[300],
                    ),
                    subscriptionList(),
                    SizedBox(
                      height: 32.0,
                    ),
                    renewButton(),
                    SizedBox(
                      height: 32.0,
                    ),
                    dailyGraphicText('Graphic Sports'),
                    Divider(
                      thickness: 1.6,
                      color: Colors.grey[300],
                    ),
                    subscriptionList(),
                    SizedBox(
                      height: 32.0,
                    ),
                    renewButton(),
                    SizedBox(
                      height: 32.0,
                    ),
                    dailyGraphicText('Graphic Business'),
                    Divider(
                      thickness: 1.6,
                      color: Colors.grey[300],
                    ),
                    subscriptionList(),
                    SizedBox(
                      height: 32.0,
                    ),
                    renewButton(),
                    SizedBox(
                      height: 32.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget settingsListTile() {
    return Container(
      margin: EdgeInsets.only(left: 17.0),
      height: 38.0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
              settingsTile.length,
              (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        switch (index) {
                          case 0:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Account()));
                            break;
                          case 1:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Subscription()));
                            break;
                          case 2:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DownloadPage()));
                            break;
                          case 3:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Refer_friend()));
                            break;
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        height: 36.0,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: activeIndex == index
                              ? WidgetColors.primaryColor
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          settingsTile[index],
                          style: FontUtil.style(
                              13,
                              SizeWeight.SemiBold,
                              context,
                              activeIndex == index ? Colors.white : null),
                        ),
                      ),
                    ),
                  )),
        ),
      ),
    );
  }

  Widget notificationText(String name) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[200]),
      height: 42.0,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Container(
                width: 3.0,
                height: 20.0,
                child: VerticalDivider(
                  thickness: 2.0,
                  color: WidgetColors.primaryColor,
                )),
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    name,
                    style: FontUtil.style(16, SizeWeight.SemiBold, context),
                  ),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }

  Widget dailyGraphicText(String name) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 16.0,
        bottom: 14.0,
      ),
      child: Text(
        name,
        style: FontUtil.style(15, SizeWeight.SemiBold, context),
      ),
    );
  }

  Widget subscriptionList() {
    return Container(
        child: ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: subscriptionListItems.length,
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
                  subscriptionListItems[index],
                  style: FontUtil.style(14, SizeWeight.Regular, context),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 20.0,
                  top: 16.0,
                  bottom: 16.0,
                ),
                child: Text(
                  '19-09-2021',
                  style: FontUtil.style(
                      14, SizeWeight.Regular, context, Colors.grey),
                ),
              ),
            ],
          ),
          Divider(
            thickness: 1.6,
            color: Colors.grey[300],
          )
        ],
      ),
    ));
  }

  Widget renewButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 35.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Subscription()));
        },
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(16.0),
            primary: WidgetColors.renewButtonColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0))),
        child: Text(
          'RENEW SUBSCRIPTION',
          style: FontUtil.style(14, SizeWeight.Medium, context),
        ),
      ),
    );
  }
}
