import 'package:flutter/material.dart';
import 'package:graphics_news/Assets/bookmark_icon_icons.dart';
import 'package:graphics_news/Assets/logout_left_icon_icons.dart';
import 'package:graphics_news/Assets/delet_account_icons.dart';

import 'package:graphics_news/Assets/magazine_left_icon_icons.dart';
import 'package:graphics_news/Assets/news_left_icon_icons.dart';
import 'package:graphics_news/Assets/profile_left_icon_icons.dart';
import 'package:graphics_news/Assets/refer_left_icon_icons.dart';
import 'package:graphics_news/Assets/services_left_icon_icons.dart';
import 'package:graphics_news/Authutil/shared_manager.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/StringUtil.dart';
import 'package:graphics_news/Utility/data_holder.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/common_widget/common_social_redirection.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/auth_dto.dart';
import 'package:graphics_news/screens/Auth/delete_account_Alert.dart';
import 'package:graphics_news/screens/Home/paper/commonWidget/mag_news_listing.dart';
import 'package:graphics_news/screens/Information%20Screens/About_us.dart';
import 'package:graphics_news/screens/Information%20Screens/BookmarksNew.dart';
import 'package:graphics_news/screens/Information%20Screens/Graphics_services.dart';
import 'package:graphics_news/screens/Information%20Screens/archive.dart';
import 'package:graphics_news/screens/Settings/Account.dart';
import 'package:graphics_news/screens/Settings/Refer_friend.dart';
import 'package:graphics_news/screens/Settings/download/Download_page.dart';

import '../screens/Auth/logout_Alert.dart';

class CommonDrawer extends StatefulWidget {
  const CommonDrawer({Key? key}) : super(key: key);

  @override
  State<CommonDrawer> createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {
  User? user;

  @override
  void initState() {
    getUser();

    super.initState();
  }

  void getUser() {
    if (mounted) {
      setState(() {
        user = SharedManager.instance.getUserDetail();
        if (user != null) {
          DataHolder.setDatatbaseTableName(user!.id);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
              height: 70.0,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80.0,
                      height: 80.0,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[300], shape: BoxShape.circle),
                        child: Icon(
                          Icons.person,
                          size: 50.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  user == null
                                      ? Container()
                                      : Text(
                                          StringUtil.getValue(user!.firstName),
                                          style: FontUtil.style(
                                              FontSizeUtil.XXLarge,
                                              SizeWeight.Bold,
                                              context),
                                        ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.close)))
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          Divider(),
          ListTile(
            onTap: () => RouteMap().navIsLogin(context, Account()),
            visualDensity: getVisDensity(),
            title: listText(BaseConstant.SIDE_BAR_MY_PROFILE),
            leading: Icon(
              ProfileLeftIcon.my_profile,
              //       color: Colors.black,
            ),
          ),
          ListTile(
            onTap: () => RouteMap().navIsLogin(context, DownloadPage()),
            visualDensity: getVisDensity(),
            title: listText(BaseConstant.SIDE_BAR_MY_PURCHASE),
            leading: Image(
              image: AssetImage('images/myPurchase.png'),
              width: 30,
              height: 30,
            ),
          ),
          ListTile(
            onTap: () => RouteMap().navIsLogin(context, ArchiveListing()),
            visualDensity: getVisDensity(),
            title: listText(BaseConstant.SIDE_BAR_ARCHIVE),
            leading: Image(
              image: AssetImage('images/archive.png'),
              width: 30,
              height: 30,
            ),
          ),
          ListTile(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MagNewsListing(BaseKey.Publish_Magzine))),
            visualDensity: getVisDensity(),
            title: listText(BaseConstant.SIDE_BAR_MAGAZINES),
            leading: Icon(
              MagazineLeftIcon.magazines,
              //   color: Colors.black,
            ),
          ),
          ListTile(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MagNewsListing(BaseKey.Publish_NewsPaper))),
            visualDensity: getVisDensity(),
            title: listText(BaseConstant.SIDE_BAR_NEWSPAPERS),
            leading: Icon(
              NewsLeftIcon.news,
              //       color: Colors.black,
            ),
          ),
          ListTile(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => Graphics_services())),
            visualDensity: getVisDensity(),
            title: listText(BaseConstant.SIDE_BAR_GRAPHIC_SERVICES),
            leading: Icon(
              ServicesLeftIcon.graphic_services,
              //   color: Colors.black,
            ),
          ),
          ListTile(
            onTap: () => RouteMap().navIsLogin(context, BookmarksNew()),
            visualDensity: getVisDensity(),
            title: listText(BaseConstant.SIDE_BAR_BOOKMARKS),
            leading: Icon(
              BookmarkIcon.bookmarks,
              //   color: Colors.black,
            ),
          ),
          ListTile(
            onTap: () => RouteMap().navIsLogin(context, Refer_friend()),
            visualDensity: getVisDensity(),
            title: listText(BaseConstant.SIDE_BAR_REFER_FRIENDS),
            leading: Icon(
              ReferLeftIcon.refer_friends,
              //         color: Colors.black,
            ),
          ),
          ListTile(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Aboutus(
                          type: BaseKey.ABOUT_US_KEY,
                        ))),
            visualDensity: getVisDensity(),
            title: listText(BaseConstant.SIDE_BAR_ABOUT_US),
            leading: Icon(
              Icons.info_outline,
              color: Colors.grey[400],
              //      color: Colors.black,
            ),
          ),
          if (RouteMap.isLogin()) ...[
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DeleteAccountAlert();
                    });
              },
              visualDensity: getVisDensity(),
              title: listText(BaseConstant.SIDE_BAR_DELETE_ACCOUNT),
              leading: Icon(
                DeletAccount.delete_account_2x,
                //     color: Colors.black,
              ),
            ),
          ],
          if (RouteMap.isLogin()) ...[
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return LogOutAlert();
                    });
              },
              visualDensity: getVisDensity(),
              title: listText(BaseConstant.SIDE_BAR_LOGOUT),
              leading: Icon(
                LogoutLeftIcon.logout,
                //     color: Colors.black,
              ),
            ),
          ],
          /* Divider(),
          addressCard(),*/
          Divider(),
          Container(
            padding: EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    CommonSocialRedirection.socialRedirection(BaseKey.FACEBOOK);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image(
                      image: AssetImage('images/facebook_grey.png'),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    CommonSocialRedirection.socialRedirection(BaseKey.TWITTER);
                  },
                  child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Image(
                        image: AssetImage('images/twitter_grey.png'),
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    CommonSocialRedirection.socialRedirection(
                        BaseKey.INSTAGRAM);
                  },
                  child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Image(
                        image: AssetImage('images/instagram_grey.png'),
                      )),
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
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget addressCard() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 2.0,
          ),
          Row(
            children: [
              SizedBox(
                width: 10.0,
              ),
              CircleAvatar(
                radius: 15.0,
                backgroundColor: WidgetColors.primaryColor,
                child: Icon(
                  Icons.location_on,
                  size: 10.0,
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
                radius: 15.0,
                backgroundColor: WidgetColors.primaryColor,
                child: Icon(
                  Icons.phone,
                  size: 10.0,
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
            height: 5.0,
          ),
          Row(
            children: [
              SizedBox(
                width: 10.0,
              ),
              CircleAvatar(
                radius: 15.0,
                backgroundColor: WidgetColors.primaryColor,
                child: Icon(
                  Icons.mail,
                  size: 10.0,
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
        ],
      ),
    );
  }

  listText(String title) {
    return Text(
      title,
      style: FontUtil.style(
        FontSizeUtil.Large,
        SizeWeight.Regular,
        context,
        ModeTheme.getDefault(context),
      ),
    );
  }

  getVisDensity() {
    return VisualDensity(horizontal: -4, vertical: -4);
  }
}
