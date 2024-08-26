import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

/// Created by Amit Rawat on 2/16/2022.

class UiRatio {
  static getAspectHeight(BuildContext context, double height) {
    if (isPotrait(context) && !isTablet()) {
// potrait phone
      return height;
    } else if (isPotrait(context) && isTablet()) {
// potrait tablet
      return height + 150;
    } else if (!isPotrait(context) && !isTablet()) {
// landscape phone
      return height;
    } else if (!isPotrait(context) && isTablet()) {
//landscape tablet
      return height + 250;
    }
  }

  static getAspectRatio(BuildContext context, double height) {
    if (isPotrait(context) && !isTablet()) {
// potrait phone
      return getwidth(context) / height;
    } else if (isPotrait(context) && isTablet()) {
// potrait tablet
      height = height + 150;
      return getwidth(context) / height;
    } else if (!isPotrait(context) && !isTablet()) {
// landscape phone
      return getwidth(context) / height;
    } else if (!isPotrait(context) && isTablet()) {
//landscape tablet
      height = height + 250;
      return getwidth(context) / height;
    }
  }

  static getHeightGrid(
      {BuildContext? context,
      double? height,
      double? PotraitTablet,
      double? PotraitPhone,
      double? landscapePhone,
      double? landscapeTablet}) {
    if (isPotrait(context!) && !isTablet()) {
// potrait phone
      if (PotraitPhone != null) {
        return height! + PotraitPhone;
      }
      return height;
    } else if (isPotrait(context) && isTablet()) {
// potrait tablet
      if (PotraitTablet != null) {
        return height! + PotraitTablet;
      }
      return height! + 50;
    } else if (!isPotrait(context) && !isTablet()) {
// landscape phone
      if (landscapePhone != null) {
        return height! + landscapePhone;
      }
      return height! + 100;
    } else if (!isPotrait(context) && isTablet()) {
//landscape tablet
      if (landscapeTablet != null) {
        return height! + landscapeTablet;
      }
      return height! + 100;
    }
  }

  static getwidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static isTablet() {
    if (Device.get().isIos && Device.get().isTablet) {
      return true;
    } else if (Device.get().isAndroid && Device.get().isTablet) {
      return true;
    }
    return false;
  }

  static isPotrait(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return true;
    } else {
      return false;
    }
  }

  static getHomePromotedTopStoryHeight(
      BuildContext context, double size, double addExtraSize,
      {double? phoneHeight}) {
    if (isPotrait(context) && !isTablet()) {
// potrait phone
      size = size;
    } else if (isPotrait(context) && isTablet()) {
// potrait tablet
      size = size + addExtraSize;
    } else if (!isPotrait(context) && !isTablet()) {
// landscape phone
      size = size + phoneHeight!;
    } else if (!isPotrait(context) && isTablet()) {
//landscape tablet
      size = size + addExtraSize;
    }

    if (isTablet()) {
      size = size + addExtraSize;
    } else {
      if (phoneHeight != null) {
        size = size + phoneHeight;
      }
    }

    return size;
  }

  static getHeight(double size, double addExtraSize, {double? phoneHeight}) {
    if (isTablet()) {
      size = size + addExtraSize;
    } else {
      if (phoneHeight != null) {
        size = size + phoneHeight;
      }
    }

    return size;
  }

  static getSilderWidth(BuildContext context) {
    if (isPotrait(context) && !isTablet()) {
// potrait phone
      return getwidth(context) - 10;
    } else if (isPotrait(context) && isTablet()) {
// potrait tablet
      return getwidth(context) - 10;
    } else if (!isPotrait(context) && !isTablet()) {
// landscape phone
      return getwidth(context) - 10;
    } else if (!isPotrait(context) && isTablet()) {
//landscape tablet
      return getwidth(context) - 10;
    }
  }

  static getCountDouble(double size, int addExtraSize) {
    if (isTablet()) {
      size = size + addExtraSize;
    }
    return size;
  }

  static getCount(int size, int addExtraSize) {
    if (isTablet()) {
      size = size + addExtraSize;
    }
    return size;
  }

  static buttonPadding(double size) {
    if (isTablet()) {
      size = size + 6;
    }
    return EdgeInsets.all(size);
  }

  static circularLoaderSize(double size) {
    if (isTablet()) {
      size = size + 20;
    }
    return size;
  }

}
