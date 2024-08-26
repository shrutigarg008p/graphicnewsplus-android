import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

import 'ConsumableStore.dart';

/*413 _listenToPurchaseUpdated() product verify */
class AppPurchase extends StatefulWidget {
  String? appleProductId;
  String? pageStack;
  bool? isSinglemagAndNewsPayMode;

  String? singleType;
  String? coupon;
  String? singlekey;
  String? totalAmount;
  String? isfamily;

  AppPurchase(
      {Key? key,
      this.appleProductId,
      this.pageStack,
      this.isSinglemagAndNewsPayMode,
      this.singlekey,
      this.singleType,
      this.coupon,
      this.totalAmount,
      this.isfamily})
      : super(key: key);

  @override
  _AppPurchaseState createState() => _AppPurchaseState();
}

class _AppPurchaseState extends State<AppPurchase> {
  bool _kAutoConsume = true;
  String? planID;

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _consumables = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  @override
  void initState() {
    planID = widget.appleProductId!;
    print(widget.isfamily.toString() + "isfamily--->>>");

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      _subscription.resume();
    });
    initStoreInfo();
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (Platform.isIOS) {
      var iosPlatformAddition = _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }
    List<String> _kProductIds = <String>[planID!];
    ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      var iosPlatformAddition = _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stack = [];
    if (_queryProductError == null) {
      stack.add(
        ListView(
          children: [
            _buildConnectionCheckTile(),
            _buildProductList(),
            //_buildConsumableBox(),
            // _buildRestoreButton(),
          ],
        ),
      );
    } else {
      stack.add(Center(
        child: Text(_queryProductError!),
      ));
    }
    if (_purchasePending) {
      stack.add(
        Stack(
          children: const [
            Opacity(
              opacity: 0.3,
              child: ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: HeaderWidget.appHeader("Payment", context),
      body: Stack(
        children: stack,
      ),
    );
  }

  Card _buildConnectionCheckTile() {
    if (_loading) {
      return const Card(child: ListTile(title: Text('Trying to connect...')));
    }
    final Widget storeHeader = ListTile(
      leading: Icon(_isAvailable ? Icons.check : Icons.block,
          color: _isAvailable ? Colors.green : ThemeData.light().errorColor),
      title: Text(
          'The store is ' + (_isAvailable ? 'available' : 'unavailable') + '.'),
    );
    final List<Widget> children = <Widget>[storeHeader];

    if (!_isAvailable) {
      children.addAll([
        const Divider(),
        ListTile(
          title: Text('Not connected',
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: const Text(
              'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
        ),
      ]);
    }
    return Card(child: Column(children: children));
  }

  Card _buildProductList() {
    if (_loading) {
      return const Card(
          child: (ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching products...'))));
    }
    if (!_isAvailable) {
      return const Card();
    }
    const ListTile productHeader = ListTile(title: Text('Products for Sale'));
    List<ListTile> productList = <ListTile>[];
    if (_notFoundIds.isNotEmpty) {
      productList.add(ListTile(
          title: Text('[${_notFoundIds.join(", ")}] not found',
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle:
              const Text('This app needs special configuration to run.')));
    }

    // This loading previous purchases code is just a demo. Please do not use this as it is.
    // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
    // We recommend that you use your own server to verify the purchase data.
    Map<String, PurchaseDetails> purchases =
        Map.fromEntries(_purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
    productList.addAll(_products.map(
      (ProductDetails productDetails) {
        PurchaseDetails? previousPurchase = purchases[productDetails.id];
        return ListTile(
            title: Text(
              productDetails.title,
            ),
            subtitle: Text(
              productDetails.description,
            ),
            trailing: previousPurchase != null
                ? IconButton(
                    onPressed: () => confirmPriceChange(context),
                    icon: const Icon(Icons.upgrade))
                : TextButton(
                    child: Text(productDetails.price),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      primary: Colors.white,
                    ),
                    onPressed: () {
                      late PurchaseParam purchaseParam;

                      if (Platform.isAndroid) {
                        // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
                        // verify the latest status of you your subscription by using server side receipt validation
                        // and update the UI accordingly. The subscription purchase status shown
                        // inside the app may not be accurate.
                        final oldSubscription =
                            _getOldSubscription(productDetails, purchases);

                        purchaseParam = GooglePlayPurchaseParam(
                            productDetails: productDetails,
                            applicationUserName: null,
                            changeSubscriptionParam: (oldSubscription != null)
                                ? ChangeSubscriptionParam(
                                    oldPurchaseDetails: oldSubscription,
                                    prorationMode: ProrationMode
                                        .immediateWithTimeProration,
                                  )
                                : null);
                      } else {
                        purchaseParam = PurchaseParam(
                          productDetails: productDetails,
                          applicationUserName: null,
                        );
                      }

                      if (productDetails.id == planID) {
                        _inAppPurchase.buyConsumable(
                            purchaseParam: purchaseParam,
                            autoConsume: _kAutoConsume || Platform.isIOS);
                      } else {
                        _inAppPurchase.buyNonConsumable(
                            purchaseParam: purchaseParam);
                      }
                    },
                  ));
      },
    ));

    return Card(
        child: Column(
            children: <Widget>[productHeader, const Divider()] + productList));
  }

  Card _buildConsumableBox() {
    if (_loading) {
      return const Card(
          child: (ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching records...'))));
    }
    if (!_isAvailable || _notFoundIds.contains(planID)) {
      return const Card();
    }
    const ListTile consumableHeader = ListTile(title: Text('Purchased items'));
    final List<Widget> tokens = _consumables.map((String id) {
      return GridTile(
        child: IconButton(
          icon: const Icon(
            Icons.stars,
            size: 42.0,
            color: Colors.orange,
          ),
          splashColor: Colors.yellowAccent,
          onPressed: () => consume(id),
        ),
      );
    }).toList();
    return Card(
        child: Column(children: <Widget>[
      consumableHeader,
      const Divider(),
      GridView.count(
        crossAxisCount: 5,
        children: tokens,
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.0),
      )
    ]));
  }

  Widget _buildRestoreButton() {
    if (_loading) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            child: const Text('Restore purchases'),
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              primary: Colors.white,
            ),
            onPressed: () => _inAppPurchase.restorePurchases(),
          ),
        ],
      ),
    );
  }

  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _consumables = consumables;
    });
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID == planID) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      List<String> consumables = await ConsumableStore.load();
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  /* Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    payStackUpdateAllPlans("");

    return Future<bool>.value(true);
  }*/

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  /*todo:Purchase verify
  *  purchase verify */
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          /*single purchase*/

          if (widget.isSinglemagAndNewsPayMode!) {
            HttpObj.instance
                .getClient()
                .getSinglePayStackInit(
                    widget.singlekey!,
                    widget.singleType!,
                    purchaseDetails.verificationData.serverVerificationData,
                    widget.coupon ?? BaseConstant.EMPTY,
                    BaseKey.APPLE_IN_APP)
                .then((it) {
              String? errorMsg = BaseConstant.SERVER_ERROR;
              if (it.MESSAGE != null && it.MESSAGE!.isNotEmpty) {
                errorMsg = it.MESSAGE;
              }
              if (it.sTATUS == BaseKey.SUCCESS) {
                deliverProduct(purchaseDetails);
                UiUtil.toastPrint(BaseConstant.PAYMENT_SUCCESSFUL);
                firePurchaseevent("USD", widget.totalAmount, "Single purchase",
          widget.appleProductId, purchaseDetails.purchaseID);
                navigatePage();
              } else {
                UiUtil.showAlert(
                    context, BaseConstant.SERVER_ERROR, errorMsg!, null, true);
              }
            }).catchError((Object obj) {
              CommonException().showException(context, obj);
              _handleInvalidPurchase(purchaseDetails);
              return;
            });
          }
          /*multiple purchase*/
          else {
            HttpObj.instance
                .getClient()
                .PayStackVerify(
                    purchaseDetails.verificationData.serverVerificationData,
                    BaseKey.APPLE_IN_APP,
                    widget.appleProductId,
                    purchaseDetails.purchaseID,
                    widget.isfamily)
                .then((it) {
              String? errorMsg = BaseConstant.SERVER_ERROR;
              if (it.MESSAGE != null && it.MESSAGE!.isNotEmpty) {
                errorMsg = it.MESSAGE;
              }
              if (it.sTATUS == BaseKey.SUCCESS) {
                deliverProduct(purchaseDetails);
                UiUtil.toastPrint(BaseConstant.PAYMENT_SUCCESSFUL);
                firePurchaseevent("USD", widget.totalAmount, "Subscription",
          widget.appleProductId, purchaseDetails.purchaseID);
                navigatePage();
              } else {
                UiUtil.showAlert(
                    context, BaseConstant.SERVER_ERROR, errorMsg!, null, true);
              }
            }).catchError((Object obj) {
              CommonException().showException(context, obj);
              _handleInvalidPurchase(purchaseDetails);
              return;
            });
          }

          /*bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }*/
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    });
  }

  Future<void> confirmPriceChange(BuildContext context) async {
    if (Platform.isAndroid) {
      final InAppPurchaseAndroidPlatformAddition androidAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      var priceChangeConfirmationResult =
          await androidAddition.launchPriceChangeConfirmationFlow(
        sku: 'purchaseId',
      );
      if (priceChangeConfirmationResult.responseCode == BillingResponse.ok) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Price change accepted'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            priceChangeConfirmationResult.debugMessage ??
                "Price change failed with code ${priceChangeConfirmationResult.responseCode}",
          ),
        ));
      }
    }
    if (Platform.isIOS) {
      var iapStoreKitPlatformAddition = _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
    }
  }

  GooglePlayPurchaseDetails? _getOldSubscription(
      ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
    // This is just to demonstrate a subscription upgrade or downgrade.
    // This method assumes that you have only 2 subscriptions under a group, 'subscription_silver' & 'subscription_gold'.
    // The 'subscription_silver' subscription can be upgraded to 'subscription_gold' and
    // the 'subscription_gold' subscription can be downgraded to 'subscription_silver'.
    // Please remember to replace the logic of finding the old subscription Id as per your app.
    // The old subscription is only required on Android since Apple handles this internally
    // by using the subscription group feature in iTunesConnect.
    GooglePlayPurchaseDetails? oldSubscription;
    // if (productDetails.id == basePlan180 &&
    //     purchases[_kGoldSubscriptionId] != null) {
    //   oldSubscription =
    //       purchases[_kGoldSubscriptionId] as GooglePlayPurchaseDetails;
    // } else if (productDetails.id == _kGoldSubscriptionId &&
    //     purchases[basePlan180] != null) {
    //   oldSubscription = purchases[basePlan180] as GooglePlayPurchaseDetails;
    // }
    return oldSubscription;
  }

/*  payStackUpdateAllPlans(String? reference) {
    HttpObj.instance
        .getClient()
        .PayStackVerify(reference!, BaseKey.APPLE_IN_APP, widget.appleProductId)
        .then((it) {
      String? errorMsg = BaseConstant.SERVER_ERROR;
      if (it.MESSAGE != null && it.MESSAGE!.isNotEmpty) {
        errorMsg = it.MESSAGE;
      }
      if (it.sTATUS == BaseKey.SUCCESS) {
        UiUtil.toastPrint(BaseConstant.PAYMENT_SUCCESSFUL);
        navigatePage();
        return;
      }
      UiUtil.showAlert(
          context, BaseConstant.SERVER_ERROR, errorMsg, null, true);
    }).catchError((Object obj) {
      CommonException().showException(context, obj);
    });
  }*/

  void navigatePage() {
    if (widget.pageStack != null) {
      if (widget.pageStack == BaseKey.PAGE_STACK_BLOG_Detail_Page) {
        RouteMap.onBackTimes(context, 3);
      } else {
        RouteMap.onBackTimes(context, 3);
      }
    } else if (widget.isSinglemagAndNewsPayMode!) {
      RouteMap.onBackTimes(context, 3);
    } else {
      RouteMap.getHome(context, index: 1);
    }
  }

  firePurchaseevent(String? currency, String? totalamount, String? paymentId,
      String? paymentmethod, String? refernce) async {
    Firebase.initializeApp().whenComplete(() {
      print("completed");
    });
    print("currency is " +
        " " +
        currency.toString() +
        "amount is" +
        totalamount.toString());
    await FirebaseAnalytics.instance.logEvent(
      name: "purchase",
      parameters: {
        "currency": currency,
        "price": double.parse(totalamount!),
        "issingleorsubscription": paymentId,
        "paymentmethod": paymentmethod,
        "refernce_Id": refernce
      },
    );
  }

/*  void openThankYouDialog() {
    String imagePath = 'images/success.png';
    ThankYouPage.thankYou(imagePath, BaseConstant.SUCCESS_TITLE,
        BaseConstant.THANK_YOU_MESSAGE, context,
        page: widget.isSinglemagAndNewsPayMode != null
            ? BaseConstant.PAYMENT_METHOD_SINGLE
            : BaseConstant.PAYMENT_METHODS);
  }*/
}

/// Example implementation of the
/// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
///
/// The payment queue delegate can be implementated to provide information
/// needed to complete transactions.
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
