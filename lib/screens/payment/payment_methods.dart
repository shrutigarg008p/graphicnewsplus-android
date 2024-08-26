import 'dart:io';

import 'package:graphics_news/Authutil/shared_manager.dart';

class PaymentMethods {
  int paymentId;
  String paymentName;
  String paymentImage;
  List<PayStackOptions>? payStackOptions;

  PaymentMethods(
      {required this.paymentId,
      required this.paymentName,
      required this.paymentImage,
      required this.payStackOptions});

  static List<PaymentMethods> getPaymentMethods() {
    dynamic darkMode = SharedManager.instance.getDarkTheme();
    return <PaymentMethods>[
      if (Platform.isAndroid) ...[
        PaymentMethods(
            paymentId: 1,
            paymentName: "Pay Stack",
            paymentImage:
                darkMode ? 'images/paystack_white.png' : 'images/paystack.png',
            payStackOptions: PayStackOptions.getPayStackOptionMethod()),
        PaymentMethods(
            paymentId: 4,
            paymentName: "ExpressPay",
            paymentImage:
                darkMode ? 'images/express_Pay.png' : 'images/express_Pay.png',
            payStackOptions: PayStackOptions.getPayStackOptionMethod()),
      ],
      if (Platform.isIOS) ...[
        PaymentMethods(
            paymentId: 5,
            paymentName: "Proceed To pay ",
            paymentImage: 'images/logo.png',
            /* paymentImage: darkMode ? 'images/applewhite.png' : 'images/appleblack.png',*/
            payStackOptions: PayStackOptions.getPayStackOptionMethod()),
      ]
    ];
  }
}

class PayStackOptions {
  int optionId;
  String optionName;

  PayStackOptions({required this.optionId, required this.optionName});

  static List<PayStackOptions> getPayStackOptionMethod() {
    return <PayStackOptions>[
      PayStackOptions(
        optionId: 1,
        optionName: "Card",
      ),
      PayStackOptions(
        optionId: 2,
        optionName: "Bank",
      ),
    ];
  }
}
