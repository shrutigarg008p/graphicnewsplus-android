// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:graphics_news/Assets/contact_icon_icons.dart';
import 'package:graphics_news/Assets/f_a_q_icon_icons.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/Utility/size_util.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/common_widget/common_deeplinking.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/response/bookmark_new_response.dart';
import 'package:graphics_news/network/response/bookmark_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/Home_page.dart';
import 'package:graphics_news/screens/Home/Splash_screen.dart';
import 'package:graphics_news/screens/Information%20Screens/Contact.dart';
import 'package:graphics_news/screens/Information%20Screens/Faq.dart';
import 'package:graphics_news/screens/Settings/Settings.dart';
import 'package:graphics_news/screens/Settings/Subsciption.dart';

import 'LifecycleWatcherState.dart';

class BottomNav extends StatefulWidget {
  int? selectedIndex;
  int? pageTileIndex;

  BottomNav({Key? key, this.selectedIndex = 0, this.pageTileIndex = 0})
      : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends LifecycleWatcherState<BottomNav> {
  List<Widget> listWidget = [
    HomePage(),
    Subscription(),
    Settings(),
    Faq(),
    Contact()
  ];
  late int bottomSelectedIndex;
  BookMarkResponse? bookMarkResponse;
  BookMarkNewResponse? bookMarkNewResponse;

  @override
  void initState() {
    super.initState();
    if (RouteMap.isLogin()) {
      getBookMarkList();
    }

    bottomSelectedIndex = widget.selectedIndex!;
    pageController = PageController(initialPage: widget.selectedIndex!);
  }

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: new Icon(
            Icons.home,
            size: SizeUtil.getSize(22, context),
          ),
          label: 'HOME'),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.info_outlined,
            size: SizeUtil.getSize(22, context),
          ),
          label: 'ACCOUNT'),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
            size: SizeUtil.getSize(22, context),
          ),
          label: 'SETTINGS'),
      BottomNavigationBarItem(
          icon: Icon(
            FAQIcon.faq,
            size: SizeUtil.getSize(22, context),
          ),
          label: 'FAQ'),
      BottomNavigationBarItem(
          icon: Icon(
            ContactIcon.svg_contact,
            size: SizeUtil.getSize(22, context),
          ),
          label: 'CONTACT')
    ];
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView.builder(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      onPageChanged: (index) {
        pageChanged(index);
      },
      itemCount: listWidget.length,
      itemBuilder: (BuildContext context, int index) {
        return listWidget[index];
      },
    );
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 10), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: bottomSelectedIndex,
        selectedItemColor: WidgetColors.primaryColor,
        selectedLabelStyle:
            FontUtil.style(FontSizeUtil.xsmall, SizeWeight.SemiBold, context),
        unselectedLabelStyle:
            FontUtil.style(FontSizeUtil.xsmall, SizeWeight.Medium, context),
        onTap: (index) {
          if (RouteMap.isLogin()) {
            bottomTapped(index);
          } else {
            if (index == 1 ) {
              RouteMap().logOutSession(context);
            } else {
              bottomTapped(index);
            }
          }
        },
        items: buildBottomNavBarItems(),
      ),
    );
  }

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {
    print("common nav onResumed called");
    if (SplashScreen.deeplinkingType != null) {
      if (bottomSelectedIndex == 0) {
        CommonDeepLinking.redirectDeeplinking(
            SplashScreen.deeplinkingType, SplashScreen.deeplinkingId, context);
      } else {
        RouteMap.getHome(context);
      }
    }
  }

  void getBookMarkList() async {
    HttpObj.instance.getClient().getBookMarksNew().then((it) => {
          if (mounted)
            {
              setState(() {
                bookMarkNewResponse = it;
                SplashScreen.bookMarkMagazines.clear();
                SplashScreen.bookMarkNewsPaper.clear();
                SplashScreen.bookMarkTopStories.clear();
                SplashScreen.bookMarkPromotedContent.clear();
                if (bookMarkNewResponse != null &&
                    bookMarkNewResponse!.DATA != null) {
                  for (int i = 0; i < bookMarkNewResponse!.DATA!.length; i++) {
                    print("key" + bookMarkNewResponse!.DATA![i].key!);
                    if (bookMarkNewResponse!.DATA![i].key! == 'magazine') {
                      // bookMarkNewResponse!.DATA![i].data!.map(
                      //     (e) => SplashScreen.bookMarkMagazines.add(e.id!));
                      for (var item in bookMarkNewResponse!.DATA![i].data!) {
                        SplashScreen.bookMarkMagazines.add(item.id!);
                      }
                    } else if (bookMarkNewResponse!.DATA![i].key ==
                        'newspaper') {
                      for (var item in bookMarkNewResponse!.DATA![i].data!) {
                        SplashScreen.bookMarkNewsPaper.add(item.id!);
                      }
                    } else if (bookMarkNewResponse!.DATA![i].key ==
                        'popular_content') {
                      for (var item in bookMarkNewResponse!.DATA![i].data!) {
                        SplashScreen.bookMarkPromotedContent.add(item.id!);
                      }
                    } else {
                      for (var item in bookMarkNewResponse!.DATA![i].data!) {
                        SplashScreen.bookMarkTopStories.add(item.id!);
                      }
                    }
                  }
                }
              })
            }
        });
  }
}
