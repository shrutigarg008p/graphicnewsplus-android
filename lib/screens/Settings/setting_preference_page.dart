import 'package:flutter/material.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/StringUtil.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_response.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/internet_util.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/common_filled_btn.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/preference_dto.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/util/LoadingIndicator.dart';

class SettingPreferencePage extends StatefulWidget {
  SettingPreferencePage({Key? key}) : super(key: key);

  @override
  _SettingPreferencePageState createState() => _SettingPreferencePageState();
}

class _SettingPreferencePageState extends State<SettingPreferencePage> {
  bool resetBtnLoading = false;
  bool savedBtnLoading = false;
  PerferenceDTO? perferenceDTO;
  bool? exception;
  bool? resetBtn = true;
  bool? saveBtn = true;

  @override
  void initState() {
    super.initState();
    callData();
  }

  void callData() {
    HttpObj.instance.getClient().getPreferenceList().then((it) {
      if (mounted) {
        setState(() {
          perferenceDTO = it;
          if (perferenceDTO != null) {
            if (perferenceDTO!.DATA != null) {
              if (perferenceDTO!.DATA!.length > 0) {
                perferenceDTO!.DATA!.insert(0, allTagKey(perferenceDTO!.DATA));
              }
            }
          }

          setException(false);
        });
      }
    }).catchError((Object obj) {
      if (mounted) {
        setException(true);
      }

      CommonException().exception(context, obj);
    });
  }

  setException(bool? value) {
    if (mounted) {
      setState(() {
        exception = value;
      });
    }
  }

  VoidCallback retryCallback() {
    VoidCallback voidcallback = () => {setException(null), callData()};
    return voidcallback;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HeaderWidget.appHeader(BaseConstant.PREFERENCE, context),
        body: buildHome(context));
  }

  buildHome(BuildContext context) {
    return CommonWidget(context).getObjWidget(perferenceDTO, exception,
        getCheckboxTile(context, perferenceDTO), retryCallback());
  }

  Widget getCheckboxTile(BuildContext context, PerferenceDTO? perferenceDTO) {
    if (perferenceDTO == null) {
      return Container();
    }
    return Container(
        child: Column(
      children: [
        Expanded(child: topicCheckBox(perferenceDTO.DATA)),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: resetBtnLoading
                  ? LoadingIndicator()
                  : CommonFilledBtn(
                      btnName: "Reset",
                      onTap: () {
                        if (resetBtn != null) {
                          onSaved(perferenceDTO.DATA, true);
                        }
                      },
                    ),
            ),
            Expanded(
              flex: 1,
              child: savedBtnLoading
                  ? LoadingIndicator()
                  : CommonFilledBtn(
                      btnName: "SAVE",
                      onTap: () {
                        if (saveBtn != null) {
                          onSaved(perferenceDTO.DATA, false);
                        }
                      },
                    ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        )
      ],
    ));
  }

  topicCheckBox(List<Topics>? topics) {
    if (topics == null) {
      return Container();
    }
    return ListView.builder(
        itemCount: topics.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              decoration: UiUtil.bottomBorder(),
              child: CheckboxListTile(
                checkColor: Colors.white,
                activeColor: WidgetColors.primaryColor,
                controlAffinity: ListTileControlAffinity.platform,
                title: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          topics[index].name.toString(),
                          style: FontUtil.style(
                            FontSizeUtil.Medium,
                            SizeWeight.Regular,
                            context,
                            ModeTheme.whiteGrey(context),
                          ),
                        )),
                      ],
                    ),
                  ],
                ),
                value: topics[index].selected == null
                    ? false
                    : topics[index].selected,
                onChanged: (val) {
                  setState(
                    () {
                      if (index == 0) {
                        selectAll(topics, val);
                      } else {
                        topics[index].selected = val;
                        checkAllSelect(val, topics);
                      }
                    },
                  );
                },
              ));
        });
  }

  checkAllSelect(bool? val, List<Topics>? topics) {
    if (!val!) {
      if (topics != null) {
        topics[0].selected = false;
      }
    }
  }

  buttonloadingstate(bool value, bool reset) {
    if (mounted) {
      setState(() {
        if (reset) {
          resetBtnLoading = value;
        } else {
          savedBtnLoading = value;
        }
      });
    }
  }

  onSaved(List<Topics>? topics, bool reset) {
    InternetUtil.check().then((value) => {
          if (value)
            {savedPreference(topics, reset)}
          else
            {InternetUtil.errorMsg(context)}
        });
  }

  Topics allTagKey(List<Topics>? topics) {
    Topics newTopics = new Topics();
    newTopics.name = "All";
    if (topics != null) {
      for (Topics topic in topics) {
        if (topic.selected != null && !topic.selected!) {
          newTopics.selected = false;
          return newTopics;
        }
      }
    }
    newTopics.selected = true;
    return newTopics;
  }

  selectAll(List<Topics>? topics, bool? val) {
    if (mounted) {
      setState(() {
        if (topics != null) {
          for (Topics topic in topics) {
            topic.selected = val;
          }
        }
      });
    }
  }

  disabledBtn(bool reset) {
    if (mounted) {
      setState(() {
        if (!reset) {
          resetBtn = null;
        } else {
          saveBtn = null;
        }
      });
    }
  }

  enableBtn(bool reset) {
    if (mounted) {
      setState(() {
        if (!reset) {
          resetBtn = true;
        } else {
          saveBtn = true;
        }
      });
    }
  }

  List<int> getEnableTopics(bool reset, List<Topics>? topics) {
    List<int> enableTopics = [];
    if (reset) {
      //select all
      for (Topics topic in topics!) {
        if (topic.id != null) {
          enableTopics.add(topic.id!);
        }
      }
    } else {
      print(topics);
      for (Topics topic in topics!) {
        if (topic.selected!) {
          if (topic.id != null) {
            enableTopics.add(topic.id!);
          }
        }
      }
    }
    return enableTopics;
  }

  void savedPreference(List<Topics>? topics, bool reset) {
    List<int> enableTopics = [];
    if (topics != null) {
      enableTopics = getEnableTopics(reset, topics);

      if (enableTopics.isEmpty) {
        UiUtil.showAlert(context, BaseConstant.APPNAME,
            "Please select atleast 1 preferences ", null, true);
        return;
      }
    } else {
      UiUtil.showAlert(context, BaseConstant.APPNAME,
          " Preferences Data is Null ", null, true);
      return;
    }

    buttonloadingstate(true, reset);
    disabledBtn(reset);
    HttpObj.instance.getClient().savedPreference(enableTopics).then((it) {
      String msg = StringUtil.getErrorMsg(it.MESSAGE);
      if (it.sTATUS == BaseKey.SUCCESS) {
        if (reset) {
          selectAll(topics, true);
        }
        UiUtil.showAlert(context, BaseConstant.APPNAME, msg, null, true);
      } else {
        UiUtil.showAlert(context, BaseConstant.APPNAME, msg, null, true);
      }
      buttonloadingstate(false, reset);
      enableBtn(reset);
    }).catchError((Object obj) {
      enableBtn(reset);
      buttonloadingstate(false, reset);
      CommonException().showException(context, obj);
    });
  }
}
