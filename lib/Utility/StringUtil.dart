import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:intl/intl.dart';

/// Created by Amit Rawat on 12/1/2021.

class StringUtil {
  static int? tempValue(int? id, String? tag) {
    String tempValue = "0";
    if (tag == BaseKey.Publish_Magzine) {
      tempValue = id.toString() + "0";
    } else if (tag == BaseKey.Publish_NewsPaper) {
      tempValue = id.toString() + "1";
    }
    return int.tryParse(tempValue);
  }

  static int get2Days(String startDate) {
    if (!notEmptyNull(startDate)) {
      return 0;
    }
    var now = new DateTime.now();
    var formatter = new DateFormat(BaseKey.DATE_FORMAT);
    String formattedDate = formatter.format(now);
    DateTime nowDate = new DateFormat(BaseKey.DATE_FORMAT).parse(formattedDate);
    DateTime startingDate =
        new DateFormat(BaseKey.DATE_FORMAT).parse(startDate);
    int days = nowDate.difference(startingDate).inDays;
    if (days < 0) {
      return days;
    } else {
      return days + 1;
    }
  }

  static int getDays(String startDate, String endDate) {
    if (!notEmptyNull(startDate) && !notEmptyNull(endDate)) {
      return 0;
    } else if (!notEmptyNull(startDate)) {
      return 0;
    } else if (!notEmptyNull(endDate)) {
      return 0;
    }
    var now = new DateTime.now();
    var formatter = new DateFormat(BaseKey.DATE_FORMAT);
    String formattedDate = formatter.format(now);
    DateTime start = new DateFormat(BaseKey.DATE_FORMAT).parse(formattedDate);
    DateTime end = new DateFormat(BaseKey.DATE_FORMAT).parse(endDate);
    int days = end.difference(start).inDays;
    if (days < 0) {
      return days;
    } else {
      return days + 1;
    }
  }

  static String getErrorMsg(String? value) {
    if (value != null) {
      return value;
    }
    return BaseConstant.SERVER_ERROR;
  }

  static String getValue(String? value) {
    if (value != null) {
      return value;
    }
    return BaseConstant.EMPTY_SPACE;
  }

  static bool compareValue(String? value, String? compareValue) {
    if (value == null || compareValue == null) return false;
    if (value == compareValue) {
      return true;
    }
    return false;
  }

  static notEmptyNull(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    return true;
  }

  static getPrice(String? currency, String? price) {
    if (currency != null && price != null) {
      return currency + BaseConstant.EMPTY_SPACE + price;
    } else if (price != null) {
      return price;
    } else if (currency != null) {
      return currency;
    }
    return BaseConstant.EMPTY_SPACE;
  }

  static String? getDownloadBtnName(bool? value) {
    if (value != null) {
      return value
          ? BaseConstant.DOWNLOAD_DOCUMENT
          : BaseConstant.PURCHASE_DOCUMENT;
    }
    return BaseConstant.PURCHASE_DOCUMENT;
  }
}
