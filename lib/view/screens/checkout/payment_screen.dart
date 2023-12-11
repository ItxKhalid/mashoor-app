import 'dart:async';
import 'dart:io';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/screens/checkout/widget/payment_failed_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pay/pay.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final OrderModel orderModel;

  PaymentScreen({@required this.orderModel});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedUrl;
  double value = 0.0;
  bool _canRedirect = true;
  bool _isLoading = true;
  final _paymentItems = [
    PaymentItem(
      label: 'Total',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    )
  ];

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebViewController controllerGlobal;

  @override
  void initState() {
    super.initState();
    selectedUrl =
        '${AppConstants.BASE_URL}/payment-mobile?customer_id=${widget.orderModel.userId}&order_id=${widget.orderModel.id}';

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
            title: 'payment'.tr, onBackPressed: () => _exitApp(context)),
        body: Container(
          width: Dimensions.WEB_MAX_WIDTH,
          child: Stack(
            children: [
              ApplePayButton(
                paymentConfigurationAsset: 'gpay.json',
                paymentItems: _paymentItems,
                style: ApplePayButtonStyle.black,
                type: ApplePayButtonType.buy,
                margin: const EdgeInsets.only(top: 15.0),
                onPaymentResult: (s) {
                  print("apple pay");
                },
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),

              GooglePayButton(
                  paymentConfigurationAsset: 'gpay.json',
                  width: 150,
                  paymentItems: _paymentItems,
                  //style: GooglePayButtonStyle.black,
                  type: GooglePayButtonType.pay,
                  margin: const EdgeInsets.only(top: 25.0, left: 100),
                  onPaymentResult: (s) {
                    print("google pay");
                  },
                  loadingIndicator: const Center(
                    child: CircularProgressIndicator(),
                  )),
              // WebView(
              //   javascriptMode: JavascriptMode.unrestricted,
              //   initialUrl: selectedUrl,
              //   gestureNavigationEnabled: true,
              //   userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E233 Safari/601.1',
              //   onWebViewCreated: (WebViewController webViewController) {
              //     _controller.future.then((value) => controllerGlobal = value);
              //     _controller.complete(webViewController);
              //   },
              //   onPageStarted: (String url) {
              //     print('Page started loading: $url');
              //     setState(() {
              //       _isLoading = true;
              //     });
              //     _redirect(url);
              //   },
              //   onPageFinished: (String url) {
              //     print('Page finished loading: $url');
              //     setState(() {
              //       _isLoading = false;
              //     });
              //     _redirect(url);
              //   },
              // ),
              // _isLoading ? Center(
              //   child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff189084BA))),
              // ) : SizedBox.shrink(),
            ],
          ),
        ),
        //  ),
      ),
    );
  }

  void _redirect(String url) {
    if (_canRedirect) {
      bool _isSuccess =
          url.contains('success') && url.contains(AppConstants.BASE_URL);
      bool _isFailed =
          url.contains('fail') && url.contains(AppConstants.BASE_URL);
      bool _isCancel =
          url.contains('cancel') && url.contains(AppConstants.BASE_URL);
      if (_isSuccess || _isFailed || _isCancel) {
        _canRedirect = false;
      }
      if (_isSuccess) {
        Get.offNamed(RouteHelper.getOrderSuccessRoute(
            widget.orderModel.id.toString(), 'success'));
      } else if (_isFailed || _isCancel) {
        Get.offNamed(RouteHelper.getOrderSuccessRoute(
            widget.orderModel.id.toString(), 'fail'));
      }
    }
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await controllerGlobal.canGoBack()) {
      controllerGlobal.goBack();
      return Future.value(false);
    } else {
      return Get.dialog(
          PaymentFailedDialog(orderID: widget.orderModel.id.toString()));
    }
  }
}
