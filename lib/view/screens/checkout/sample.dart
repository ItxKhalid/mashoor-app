import 'dart:convert';

import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/coupon_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/data/model/body/place_order_body.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/data/model/response/cart_model.dart';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:efood_multivendor/view/screens/address/widget/address_widget.dart';
import 'package:efood_multivendor/view/screens/checkout/widget/payment_failed_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pay/pay.dart' as pay;
import 'package:universal_html/html.dart' as html;

class CheckoutScreen extends StatefulWidget {
  final List<CartModel> cartList;
  final OrderModel orderModel;
  final bool fromCart;
  CheckoutScreen(
      {@required this.fromCart,
      @required this.cartList,
      @required this.orderModel});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool is_user_charged = false;
  var _tabTextIconIndexSelected = 0;
  Map<String, dynamic> paymentIntentData;
  bool _show = false;
  int paymentMethodIndex = 0;
  OrderController orderController;
  LocationController locationController;
  List<Cart> carts;
  //RestaurantController restController;
  DateTime _scheduleDate;
  double _total;
  double _discount;
  double _tax;

  var _listIconTabToggle = [
    Icons.delivery_dining,
    Icons.person,
  ];
  var _listGenderText = ["Delivery", "Pick-Up"];

  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  double _taxPercent = 0;
  double _totalToPay = 0;
  bool confirmOrderTabbed = false;
  bool _isCashOnDeliveryActive;
  bool _isDigitalPaymentActive;
  bool _isLoggedIn;
  List<CartModel> _cartList;
  List<pay.PaymentItem> _paymentItems = [];

  @override
  void initState() {
    super.initState();

    //initialiseStripe();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if (_isLoggedIn) {
      if (Get.find<UserController>().userInfoModel == null) {
        Get.find<UserController>().getUserInfo();
      }
      if (Get.find<LocationController>().addressList == null) {
        Get.find<LocationController>().getAddressList();
      }
      _isCashOnDeliveryActive =
          Get.find<SplashController>().configModel.cashOnDelivery;
      _isDigitalPaymentActive =
          Get.find<SplashController>().configModel.digitalPayment;
    }
  }

  // void initialiseStripe() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //
  //   Stripe.publishableKey =
  //       // "pk_live_51JCskPGJw4LwnASwj8uzAK4PxhtFuAX8YLuLoTHpMMymSAVxaTv84NcTwNCTsVYXmz20B4eivhLWw8FSJwsKXCnw001raIyiZz";
  //       "pk_test_51JCskPGJw4LwnASwQnWvlFZPtqiSLhMqbvQfxb8nILiPySlXNvxwiDN5FvFHAOjTTBu0CZ9OrngpN3Xa0NwqFmx400hALvW7f2";
  //   await Stripe.instance.applySettings();
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: 'checkout'.tr),
        body: _isLoggedIn
            ? GetBuilder<LocationController>(builder: (locationController) {
                List<DropdownMenuItem<int>> _addressList = [];
                _addressList.add(DropdownMenuItem<int>(
                    value: -1,
                    child: SizedBox(
                      width: context.width > Dimensions.WEB_MAX_WIDTH
                          ? Dimensions.WEB_MAX_WIDTH - 50
                          : context.width - 50,
                      child: AddressWidget(
                        address:
                            Get.find<LocationController>().getUserAddress(),
                        fromAddress: false,
                        fromCheckout: true,
                      ),
                    )));
                if (locationController.addressList != null) {
                  for (int index = 0;
                      index < locationController.addressList.length;
                      index++) {
                    if (locationController.addressList[index].zoneId ==
                        Get.find<LocationController>()
                            .getUserAddress()
                            .zoneId) {
                      _addressList.add(DropdownMenuItem<int>(
                          value: index,
                          child: SizedBox(
                            width: context.width > Dimensions.WEB_MAX_WIDTH
                                ? Dimensions.WEB_MAX_WIDTH - 50
                                : context.width - 50,
                            child: AddressWidget(
                              address: locationController.addressList[index],
                              fromAddress: false,
                              fromCheckout: true,
                            ),
                          )));
                    }
                  }
                }
                return Container();
                // return GetBuilder<RestaurantController>(
                //     builder: (restController) {
                //   bool _todayClosed = false;
                //   bool _tomorrowClosed = false;
                //   if (restController.restaurant != null) {
                //     _todayClosed = restController.isRestaurantClosed(
                //         true,
                //         restController.restaurant.active,
                //         restController.restaurant.offDay);
                //     _tomorrowClosed = restController.isRestaurantClosed(
                //         false,
                //         restController.restaurant.active,
                //         restController.restaurant.offDay);
                //     _taxPercent = restController.restaurant.tax;
                //   }
                //   return GetBuilder<CouponController>(
                //       builder: (couponController) {
                //     return GetBuilder<OrderController>(
                //         builder: (orderController) {
                //       double _deliveryCharge = 0;
                //       double _charge = 0;
                //       if (restController.restaurant != null &&
                //           restController.restaurant.selfDeliverySystem == 1) {
                //         _deliveryCharge =
                //             restController.restaurant.deliveryCharge;
                //         _charge = restController.restaurant.deliveryCharge;
                //       } else if (restController.restaurant != null &&
                //           orderController.distance != null) {
                //         _deliveryCharge = orderController.distance *
                //             Get.find<SplashController>()
                //                 .configModel
                //                 .perKmShippingCharge;
                //         _charge = orderController.distance *
                //             Get.find<SplashController>()
                //                 .configModel
                //                 .perKmShippingCharge;
                //         if (_deliveryCharge <
                //             Get.find<SplashController>()
                //                 .configModel
                //                 .minimumShippingCharge) {
                //           _deliveryCharge = Get.find<SplashController>()
                //               .configModel
                //               .minimumShippingCharge;
                //           _charge = Get.find<SplashController>()
                //               .configModel
                //               .minimumShippingCharge;
                //         }
                //       }
                //
                //       double _price = 0;
                //       double _discount = 0;
                //       double _couponDiscount = couponController.discount;
                //       double _tax = 0;
                //       double _addOns = 0;
                //       double _subTotal = 0;
                //       double _orderAmount = 0;
                //       if (restController.restaurant != null) {
                //         _cartList.forEach((cartModel) {
                //           List<AddOns> _addOnList = [];
                //           cartModel.addOnIds.forEach((addOnId) {
                //             for (AddOns addOns in cartModel.product.addOns) {
                //               if (addOns.id == addOnId.id) {
                //                 _addOnList.add(addOns);
                //                 break;
                //               }
                //             }
                //           });
                //
                //           for (int index = 0;
                //               index < _addOnList.length;
                //               index++) {
                //             _addOns = _addOns +
                //                 (_addOnList[index].price *
                //                     cartModel.addOnIds[index].quantity);
                //           }
                //           _price =
                //               _price + (cartModel.price * cartModel.quantity);
                //           double _dis =
                //               (restController.restaurant.discount != null &&
                //                       DateConverter.isAvailable(
                //                           restController
                //                               .restaurant.discount.startTime,
                //                           restController
                //                               .restaurant.discount.endTime))
                //                   ? restController.restaurant.discount.discount
                //                   : cartModel.product.discount;
                //           String _disType =
                //               (restController.restaurant.discount != null &&
                //                       DateConverter.isAvailable(
                //                           restController
                //                               .restaurant.discount.startTime,
                //                           restController
                //                               .restaurant.discount.endTime))
                //                   ? 'percent'
                //                   : cartModel.product.discountType;
                //           _discount = _discount +
                //               ((cartModel.price -
                //                       PriceConverter.convertWithDiscount(
                //                           cartModel.price, _dis, _disType)) *
                //                   cartModel.quantity);
                //         });
                //         if (restController.restaurant != null &&
                //             restController.restaurant.discount != null) {
                //           if (restController.restaurant.discount.maxDiscount !=
                //                   0 &&
                //               restController.restaurant.discount.maxDiscount <
                //                   _discount) {
                //             _discount =
                //                 restController.restaurant.discount.maxDiscount;
                //           }
                //           if (restController.restaurant.discount.minPurchase !=
                //                   0 &&
                //               restController.restaurant.discount.minPurchase >
                //                   (_price + _addOns)) {
                //             _discount = 0;
                //           }
                //         }
                //         _subTotal = _price + _addOns;
                //         _orderAmount =
                //             (_price - _discount) + _addOns - _couponDiscount;
                //
                //         if (orderController.orderType == 'take_away' ||
                //             restController.restaurant.freeDelivery ||
                //             (Get.find<SplashController>()
                //                         .configModel
                //                         .freeDeliveryOver !=
                //                     null &&
                //                 _orderAmount >=
                //                     Get.find<SplashController>()
                //                         .configModel
                //                         .freeDeliveryOver) ||
                //             couponController.freeDelivery) {
                //           _deliveryCharge = 0;
                //         }
                //       }
                //       // @ asrar - tax removed
                //       //  _tax = PriceConverter.calculation(
                //       //     _orderAmount, _taxPercent, 'percent', 1);
                //       _tax = 0;
                //
                //       // double _total = _subTotal + _deliveryCharge - _discount - _couponDiscount + _tax;
                //
                //       double _total = _subTotal + _deliveryCharge;
                //       // setState(() {
                //       _totalToPay = _total;
                //       //   });
                //       _paymentItems = [
                //         pay.PaymentItem(
                //           label: 'Total',
                //           amount: _total.toString(),
                //           status: pay.PaymentItemStatus.final_price,
                //         )
                //       ];
                //
                //       return (orderController.distance != null &&
                //               locationController.addressList != null)
                //           ? Column(
                //               children: [
                //                 Expanded(
                //                     child: Scrollbar(
                //                         child: SingleChildScrollView(
                //                   physics: BouncingScrollPhysics(),
                //                   padding: EdgeInsets.all(
                //                       Dimensions.PADDING_SIZE_SMALL),
                //                   child: Center(
                //                       child: SizedBox(
                //                     width: Dimensions.WEB_MAX_WIDTH,
                //                     child: Column(
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.start,
                //                         children: [
                //                           // Order type
                //                           //    Text('delivery_option'.tr, style: robotoMedium),
                //                           Center(
                //                             child: FlutterToggleTab(
                //                               width: 75,
                //                               borderRadius: 25,
                //                               selectedTextStyle: TextStyle(
                //                                   color: Colors.black,
                //                                   fontSize: 14,
                //                                   fontWeight: FontWeight.w600),
                //                               unSelectedTextStyle: TextStyle(
                //                                 color: Colors.blue,
                //                                 fontSize: 14,
                //                                 fontWeight: FontWeight.w400,
                //                               ),
                //                               labels: _listGenderText,
                //                               begin: Alignment.centerLeft,
                //                               icons: _listIconTabToggle,
                //                               selectedIndex:
                //                                   _tabTextIconIndexSelected,
                //                               selectedLabelIndex: (index) {
                //                                 setState(() {
                //                                   _tabTextIconIndexSelected =
                //                                       index;
                //                                 });
                //                               },
                //                             ),
                //                           ),
                //                           // restController.restaurant.delivery ? DeliveryOptionButton(
                //                           //   value: 'delivery', title: 'home_delivery'.tr, charge: _charge, isFree: restController.restaurant.freeDelivery,
                //                           // ) : SizedBox(),
                //                           // restController.restaurant.takeAway ? DeliveryOptionButton(
                //                           //   value: 'take_away', title: 'take_away'.tr, charge: _deliveryCharge, isFree: true,
                //                           // ) : SizedBox(),
                //                           SizedBox(
                //                               height: Dimensions
                //                                   .PADDING_SIZE_LARGE),
                //
                //                           _tabTextIconIndexSelected != 1
                //                               ? Column(
                //                                   crossAxisAlignment:
                //                                       CrossAxisAlignment.start,
                //                                   children: [
                //                                       Row(
                //                                           mainAxisAlignment:
                //                                               MainAxisAlignment
                //                                                   .spaceBetween,
                //                                           children: [
                //                                             Text(
                //                                                 'deliver_to'.tr,
                //                                                 style:
                //                                                     robotoMedium),
                //                                             TextButton.icon(
                //                                               onPressed: () => Get
                //                                                   .toNamed(RouteHelper
                //                                                       .getAddAddressRoute(
                //                                                           true)),
                //                                               icon: Icon(
                //                                                   Icons.add,
                //                                                   size: 20),
                //                                               label: Text(
                //                                                   'add'.tr,
                //                                                   style: robotoMedium
                //                                                       .copyWith(
                //                                                           fontSize:
                //                                                               Dimensions.fontSizeSmall)),
                //                                             ),
                //                                           ]),
                //                                       DropdownButton(
                //                                         value: orderController
                //                                             .addressIndex,
                //                                         items: _addressList,
                //                                         itemHeight:
                //                                             ResponsiveHelper
                //                                                     .isMobile(
                //                                                         context)
                //                                                 ? 70
                //                                                 : 85,
                //                                         elevation: 0,
                //                                         iconSize: 30,
                //                                         underline: SizedBox(),
                //                                         onChanged: (int
                //                                                 index) =>
                //                                             orderController
                //                                                 .setAddressIndex(
                //                                                     index),
                //                                       ),
                //                                       SizedBox(
                //                                           height: Dimensions
                //                                               .PADDING_SIZE_LARGE),
                //                                     ])
                //                               : SizedBox(),
                //
                //                           // Time Slot
                //                           restController
                //                                   .restaurant.scheduleOrder
                //                               ? Column(
                //                                   crossAxisAlignment:
                //                                       CrossAxisAlignment.start,
                //                                   children: [
                //                                       _tabTextIconIndexSelected !=
                //                                               1
                //                                           ? Text(
                //                                               'delivery_time'
                //                                                   .tr,
                //                                               style:
                //                                                   robotoMedium)
                //                                           : Text(
                //                                               'pickup_time'.tr,
                //                                               style:
                //                                                   robotoMedium),
                //                                       SizedBox(
                //                                           height: Dimensions
                //                                               .PADDING_SIZE_SMALL),
                //                                       SizedBox(
                //                                         height: 50,
                //                                         child: ListView.builder(
                //                                           scrollDirection:
                //                                               Axis.horizontal,
                //                                           shrinkWrap: true,
                //                                           physics:
                //                                               BouncingScrollPhysics(),
                //                                           itemCount: 2,
                //                                           itemBuilder:
                //                                               (context, index) {
                //                                             return Container();
                //                                             // return SlotWidget(
                //                                             //   title: index == 0
                //                                             //       ? 'today'.tr
                //                                             //       : 'tomorrow'
                //                                             //           .tr,
                //                                             //   isSelected:
                //                                             //       orderController
                //                                             //               .selectedDateSlot ==
                //                                             //           index,
                //                                             //   onTap: () =>
                //                                             //       orderController
                //                                             //           .updateDateSlot(
                //                                             //               index),
                //                                             // );
                //                                           },
                //                                         ),
                //                                       ),
                //                                       SizedBox(
                //                                           height: Dimensions
                //                                               .PADDING_SIZE_SMALL),
                //                                       SizedBox(
                //                                         height: 50,
                //                                         child: ((orderController
                //                                                             .selectedDateSlot ==
                //                                                         0 &&
                //                                                     _todayClosed) ||
                //                                                 (orderController
                //                                                             .selectedDateSlot ==
                //                                                         1 &&
                //                                                     _tomorrowClosed))
                //                                             ? Center(
                //                                                 child: Text(
                //                                                     'restaurant_is_closed'
                //                                                         .tr))
                //                                             : orderController
                //                                                         .timeSlots !=
                //                                                     null
                //                                                 ? orderController
                //                                                             .timeSlots
                //                                                             .length >
                //                                                         0
                //                                                     ? ListView
                //                                                         .builder(
                //                                                         scrollDirection:
                //                                                             Axis.horizontal,
                //                                                         shrinkWrap:
                //                                                             true,
                //                                                         physics:
                //                                                             BouncingScrollPhysics(),
                //                                                         itemCount: orderController
                //                                                             .timeSlots
                //                                                             .length,
                //                                                         itemBuilder:
                //                                                             (context,
                //                                                                 index) {
                //                                                           return SlotWidget(
                //                                                             title: (index == 0 &&
                //                                                                     orderController.selectedDateSlot == 0 &&
                //                                                                     DateConverter.isAvailable(
                //                                                                       restController.restaurant.openingTime,
                //                                                                       restController.restaurant.closeingTime,
                //                                                                     ))
                //                                                                 ? 'now'.tr
                //                                                                 : '${DateConverter.dateToTimeOnly(orderController.timeSlots[index].startTime)} '
                //                                                                     '- ${DateConverter.dateToTimeOnly(orderController.timeSlots[index].endTime)}',
                //                                                             isSelected:
                //                                                                 orderController.selectedTimeSlot == index,
                //                                                             onTap: () =>
                //                                                                 orderController.updateTimeSlot(index),
                //                                                           );
                //                                                         },
                //                                                       )
                //                                                     : Center(
                //                                                         child: Text('no_slot_available'
                //                                                             .tr))
                //                                                 : Center(
                //                                                     child:
                //                                                         CircularProgressIndicator()),
                //                                       ),
                //                                       SizedBox(
                //                                           height: Dimensions
                //                                               .PADDING_SIZE_LARGE),
                //                                     ])
                //                               : SizedBox(),
                //
                //                           CustomTextField(
                //                             controller: _noteController,
                //                             hintText: 'additional_note'.tr,
                //                             maxLines: 3,
                //                             inputType: TextInputType.multiline,
                //                             inputAction:
                //                                 TextInputAction.newline,
                //                             capitalization:
                //                                 TextCapitalization.sentences,
                //                           ),
                //                           // Coupon
                //                           SizedBox(
                //                               height: Dimensions
                //                                   .PADDING_SIZE_LARGE),
                //
                //                           Text('choose_payment_method'.tr,
                //                               style: robotoMedium),
                //                           SizedBox(
                //                               height: Dimensions
                //                                   .PADDING_SIZE_SMALL),
                //                           _isCashOnDeliveryActive
                //                               ? PaymentButton(
                //                                   icon: Images.cash_on_delivery,
                //                                   title: 'cash_on_delivery'.tr,
                //                                   subtitle:
                //                                       'pay_your_payment_after_getting_food'
                //                                           .tr,
                //                                   index: 0,
                //                                 )
                //                               : SizedBox(),
                //                           //    Image.asset('assets/image/gpay.png'),
                //                           // adding google pay
                //                           //,
                //
                //                           //    previous digital payment button
                //                           _isDigitalPaymentActive
                //                               ? Row(children: [
                //                                   PaymentBox(
                //                                     icon: Images.googlepay,
                //                                     index:
                //                                         _isCashOnDeliveryActive
                //                                             ? 1
                //                                             : 0,
                //                                   ),
                //                                   SizedBox(
                //                                     width: 10,
                //                                   ),
                //                                   PaymentBox(
                //                                     icon: Images.stripe,
                //                                     index:
                //                                         _isCashOnDeliveryActive
                //                                             ? 2
                //                                             : 0,
                //                                   ),
                //                                   SizedBox(
                //                                     width: 10,
                //                                   ),
                //                                   PaymentBox(
                //                                     icon: Images.paypal,
                //                                     index:
                //                                         _isCashOnDeliveryActive
                //                                             ? 3
                //                                             : 0,
                //                                   ),
                //                                 ])
                //                               : SizedBox(),
                //                           // _isDigitalPaymentActive ? PaymentButton(
                //                           //   icon: Images.digital_payment,
                //                           //   title: 'digital_payment'.tr,
                //                           //   subtitle: 'faster_and_safe_way'.tr,
                //                           //   index: _isCashOnDeliveryActive ? 1 : 0,
                //                           // ) : SizedBox(),
                //
                //                           SizedBox(
                //                               height: Dimensions
                //                                   .PADDING_SIZE_LARGE),
                //
                //                           GetBuilder<CouponController>(
                //                             builder: (couponController) {
                //                               return Row(children: [
                //                                 Expanded(
                //                                   child: SizedBox(
                //                                     height: 50,
                //                                     child: TextField(
                //                                       controller:
                //                                           _couponController,
                //                                       style: robotoRegular.copyWith(
                //                                           height: ResponsiveHelper
                //                                                   .isMobile(
                //                                                       context)
                //                                               ? null
                //                                               : 2),
                //                                       decoration:
                //                                           InputDecoration(
                //                                         hintText:
                //                                             'enter_promo_code'
                //                                                 .tr,
                //                                         hintStyle: robotoRegular
                //                                             .copyWith(
                //                                                 color: Theme.of(
                //                                                         context)
                //                                                     .hintColor),
                //                                         isDense: true,
                //                                         filled: true,
                //                                         enabled:
                //                                             couponController
                //                                                     .discount ==
                //                                                 0,
                //                                         fillColor:
                //                                             Theme.of(context)
                //                                                 .cardColor,
                //                                         border:
                //                                             OutlineInputBorder(
                //                                           borderRadius:
                //                                               BorderRadius
                //                                                   .horizontal(
                //                                             left: Radius.circular(
                //                                                 Get.find<LocalizationController>()
                //                                                         .isLtr
                //                                                     ? 10
                //                                                     : 1),
                //                                             right: Radius.circular(
                //                                                 Get.find<LocalizationController>()
                //                                                         .isLtr
                //                                                     ? 1
                //                                                     : 10),
                //                                           ),
                //                                           borderSide: BorderSide(
                //                                               style: BorderStyle
                //                                                   .none,
                //                                               width: 1),
                //                                         ),
                //                                       ),
                //                                     ),
                //                                   ),
                //                                 ),
                //                                 InkWell(
                //                                   onTap: () {
                //                                     String _couponCode =
                //                                         _couponController.text
                //                                             .trim();
                //                                     if (couponController
                //                                                 .discount <
                //                                             1 &&
                //                                         !couponController
                //                                             .freeDelivery) {
                //                                       if (_couponCode
                //                                               .isNotEmpty &&
                //                                           !couponController
                //                                               .isLoading) {
                //                                         couponController
                //                                             .applyCoupon(
                //                                                 _couponCode,
                //                                                 (_price -
                //                                                         _discount) +
                //                                                     _addOns,
                //                                                 _deliveryCharge,
                //                                                 restController
                //                                                     .restaurant
                //                                                     .id)
                //                                             .then((discount) {
                //                                           if (discount > 0) {
                //                                             showCustomSnackBar(
                //                                               '${'you_got_discount_of'.tr} ${PriceConverter.convertPrice(discount)}',
                //                                               isError: false,
                //                                             );
                //                                           }
                //                                         });
                //                                       } else if (_couponCode
                //                                           .isEmpty) {
                //                                         showCustomSnackBar(
                //                                             'enter_a_coupon_code'
                //                                                 .tr);
                //                                       }
                //                                     } else {
                //                                       couponController
                //                                           .removeCouponData(
                //                                               true);
                //                                     }
                //                                   },
                //                                   child: Container(
                //                                     height: 50,
                //                                     width: 100,
                //                                     alignment: Alignment.center,
                //                                     decoration: BoxDecoration(
                //                                       color: Theme.of(context)
                //                                           .primaryColor,
                //                                       boxShadow: [
                //                                         BoxShadow(
                //                                             color: Colors.grey[
                //                                                 Get.isDarkMode
                //                                                     ? 800
                //                                                     : 200],
                //                                             spreadRadius: 1,
                //                                             blurRadius: 5)
                //                                       ],
                //                                       borderRadius: BorderRadius
                //                                           .horizontal(
                //                                         left: Radius.circular(
                //                                             Get.find<LocalizationController>()
                //                                                     .isLtr
                //                                                 ? 0
                //                                                 : 10),
                //                                         right: Radius.circular(
                //                                             Get.find<LocalizationController>()
                //                                                     .isLtr
                //                                                 ? 10
                //                                                 : 0),
                //                                       ),
                //                                     ),
                //                                     child: (couponController
                //                                                     .discount <=
                //                                                 0 &&
                //                                             !couponController
                //                                                 .freeDelivery)
                //                                         ? !couponController
                //                                                 .isLoading
                //                                             ? Text(
                //                                                 'apply'.tr,
                //                                                 style: robotoMedium.copyWith(
                //                                                     color: Theme.of(
                //                                                             context)
                //                                                         .cardColor),
                //                                               )
                //                                             : CircularProgressIndicator(
                //                                                 valueColor:
                //                                                     AlwaysStoppedAnimation<
                //                                                             Color>(
                //                                                         Colors
                //                                                             .white))
                //                                         : Icon(Icons.clear,
                //                                             color:
                //                                                 Colors.white),
                //                                   ),
                //                                 ),
                //                               ]);
                //                             },
                //                           ),
                //                           SizedBox(
                //                               height: Dimensions
                //                                   .PADDING_SIZE_LARGE),
                //                           //SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                //
                //                           Row(
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment
                //                                       .spaceBetween,
                //                               children: [
                //                                 Text('subtotal'.tr,
                //                                     style: robotoMedium),
                //                                 Text(
                //                                     PriceConverter.convertPrice(
                //                                         _subTotal),
                //                                     style: robotoMedium),
                //                               ]),
                //                           SizedBox(
                //                               height: Dimensions
                //                                   .PADDING_SIZE_SMALL),
                //                           Row(
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment
                //                                       .spaceBetween,
                //                               children: [
                //                                 Text('discount'.tr,
                //                                     style: robotoRegular),
                //                                 Text(
                //                                     '${PriceConverter.convertPrice(_discount)}',
                //                                     style: robotoRegular),
                //                               ]),
                //                           SizedBox(
                //                               height: Dimensions
                //                                   .PADDING_SIZE_SMALL),
                //                           (couponController.discount > 0 ||
                //                                   couponController.freeDelivery)
                //                               ? Column(children: [
                //                                   Row(
                //                                       mainAxisAlignment:
                //                                           MainAxisAlignment
                //                                               .spaceBetween,
                //                                       children: [
                //                                         Text(
                //                                             'coupon_discount'
                //                                                 .tr,
                //                                             style:
                //                                                 robotoRegular),
                //                                         (couponController
                //                                                         .coupon !=
                //                                                     null &&
                //                                                 couponController
                //                                                         .coupon
                //                                                         .couponType ==
                //                                                     'free_delivery')
                //                                             ? Text(
                //                                                 'free_delivery'
                //                                                     .tr,
                //                                                 style: robotoRegular.copyWith(
                //                                                     color: Theme.of(
                //                                                             context)
                //                                                         .primaryColor),
                //                                               )
                //                                             : Text(
                //                                                 '${PriceConverter.convertPrice(couponController.discount)}',
                //                                                 style:
                //                                                     robotoRegular,
                //                                               ),
                //                                       ]),
                //                                   SizedBox(
                //                                       height: Dimensions
                //                                           .PADDING_SIZE_SMALL),
                //                                 ])
                //                               : SizedBox(),
                //                           /* Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                //             Text('vat_tax'.tr, style: robotoRegular),
                //             Text('(+) ${PriceConverter.convertPrice(_tax)}', style: robotoRegular),
                //           ]),*/
                //                           SizedBox(
                //                               height: Dimensions
                //                                   .PADDING_SIZE_SMALL),
                //                           Row(
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment
                //                                       .spaceBetween,
                //                               children: [
                //                                 Text('delivery_fee'.tr,
                //                                     style: robotoRegular),
                //                                 (_deliveryCharge == 0 ||
                //                                         (couponController
                //                                                     .coupon !=
                //                                                 null &&
                //                                             couponController
                //                                                     .coupon
                //                                                     .couponType ==
                //                                                 'free_delivery'))
                //                                     ? Text(
                //                                         'free'.tr,
                //                                         style: robotoRegular
                //                                             .copyWith(
                //                                                 color: Theme.of(
                //                                                         context)
                //                                                     .primaryColor),
                //                                       )
                //                                     : Text(
                //                                         '${PriceConverter.convertPrice(_deliveryCharge)}',
                //                                         style: robotoRegular,
                //                                       ),
                //                               ]),
                //                           Padding(
                //                             padding: EdgeInsets.symmetric(
                //                                 vertical: Dimensions
                //                                     .PADDING_SIZE_SMALL),
                //                             child: Divider(
                //                                 thickness: 1,
                //                                 color: Theme.of(context)
                //                                     .hintColor
                //                                     .withOpacity(0.5)),
                //                           ),
                //                           Row(
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment
                //                                       .spaceBetween,
                //                               children: [
                //                                 Text(
                //                                   'total_amount'.tr,
                //                                   style: robotoMedium.copyWith(
                //                                       fontSize: Dimensions
                //                                           .fontSizeLarge,
                //                                       color: Theme.of(context)
                //                                           .primaryColor),
                //                                 ),
                //                                 Text(
                //                                   PriceConverter.convertPrice(
                //                                       _total),
                //                                   style: robotoMedium.copyWith(
                //                                       fontSize: Dimensions
                //                                           .fontSizeLarge,
                //                                       color: Theme.of(context)
                //                                           .primaryColor),
                //                                 ),
                //                               ]),
                //                         ]),
                //                   )),
                //                 ))),
                //                 Container(
                //                   width: Dimensions.WEB_MAX_WIDTH,
                //                   alignment: Alignment.center,
                //                   padding: EdgeInsets.all(
                //                       Dimensions.PADDING_SIZE_SMALL),
                //                   child: !orderController.isLoading
                //                       ? CustomButton(
                //                           buttonText: 'confirm_Forder'.tr,
                //                           onPressed: () {
                //                             confirmOrderTabbed = true;
                //                             bool _isAvailable = true;
                //                             DateTime _scheduleDate =
                //                                 DateTime.now();
                //                             if (orderController.timeSlots ==
                //                                     null ||
                //                                 orderController
                //                                         .timeSlots.length ==
                //                                     0) {
                //                               _isAvailable = false;
                //                             } else {
                //                               DateTime _date = orderController
                //                                           .selectedDateSlot ==
                //                                       0
                //                                   ? DateTime.now()
                //                                   : DateTime.now()
                //                                       .add(Duration(days: 1));
                //                               DateTime _time = orderController
                //                                   .timeSlots[orderController
                //                                       .selectedTimeSlot]
                //                                   .startTime;
                //                               _scheduleDate = DateTime(
                //                                   _date.year,
                //                                   _date.month,
                //                                   _date.day,
                //                                   _time.hour,
                //                                   _time.minute + 1);
                //                               for (CartModel cart
                //                                   in _cartList) {
                //                                 if (!DateConverter.isAvailable(
                //                                   cart.product
                //                                       .availableTimeStarts,
                //                                   cart.product
                //                                       .availableTimeEnds,
                //                                   time: restController
                //                                           .restaurant
                //                                           .scheduleOrder
                //                                       ? _scheduleDate
                //                                       : null,
                //                                 )) {
                //                                   _isAvailable = false;
                //                                   break;
                //                                 }
                //                               }
                //                             }
                //                             if (_orderAmount <
                //                                 restController
                //                                     .restaurant.minimumOrder) {
                //                               showCustomSnackBar(
                //                                   '${'minimum_order_amount_is'.tr} ${restController.restaurant.minimumOrder}');
                //                             } else if ((orderController
                //                                             .selectedDateSlot ==
                //                                         0 &&
                //                                     _todayClosed) ||
                //                                 (orderController
                //                                             .selectedDateSlot ==
                //                                         1 &&
                //                                     _tomorrowClosed)) {
                //                               showCustomSnackBar(
                //                                   'restaurant_is_closed'.tr);
                //                             } else if (orderController
                //                                         .timeSlots ==
                //                                     null ||
                //                                 orderController
                //                                         .timeSlots.length ==
                //                                     0) {
                //                               if (restController
                //                                   .restaurant.scheduleOrder) {
                //                                 showCustomSnackBar(
                //                                     'select_a_time'.tr);
                //                               } else {
                //                                 showCustomSnackBar(
                //                                     'restaurant_is_closed'.tr);
                //                               }
                //                             } else if (!_isAvailable) {
                //                               showCustomSnackBar(
                //                                   'one_or_more_products_are_not_available_for_this_selected_time'
                //                                       .tr);
                //                             } else {
                //                               List<Cart> carts = [];
                //                               for (int index = 0;
                //                                   index < _cartList.length;
                //                                   index++) {
                //                                 CartModel cart =
                //                                     _cartList[index];
                //                                 List<int> _addOnIdList = [];
                //                                 List<int> _addOnQtyList = [];
                //                                 cart.addOnIds.forEach((addOn) {
                //                                   _addOnIdList.add(addOn.id);
                //                                   _addOnQtyList
                //                                       .add(addOn.quantity);
                //                                 });
                //                                 carts.add(Cart(
                //                                   cart.isCampaign
                //                                       ? null
                //                                       : cart.product.id,
                //                                   cart.isCampaign
                //                                       ? cart.product.id
                //                                       : null,
                //                                   cart.discountedPrice
                //                                       .toString(),
                //                                   '',
                //                                   cart.variation,
                //                                   cart.quantity,
                //                                   _addOnIdList,
                //                                   cart.addOns,
                //                                   _addOnQtyList,
                //                                 ));
                //                               }
                //
                //                               this.orderController =
                //                                   orderController;
                //                               locationController;
                //                               this.carts = carts;
                //                               this.restController =
                //                                   restController;
                //                               this._scheduleDate =
                //                                   _scheduleDate;
                //                               this._total = _total;
                //                               this._discount = _discount;
                //                               this._tax = _tax;
                //                               makepay();
                //                             }
                //                           })
                //                       : confirmOrderTabbed != true
                //                           ? Center(
                //                               child: Text(
                //                                   "Thanks for your trust on Salva Fast Food"),
                //                             )
                //                           : Center(
                //                               child:
                //                                   CircularProgressIndicator()),
                //                 ),
                //               ],
                //             )
                //           : Center(child: CircularProgressIndicator());
                //     });
                //   });
                // });
              })
            : NotLoggedInScreen(),
        //   bottomSheet: _showBottomSheet(_totalToPay),
      ),
    );
  }

  void getOrderPlaced(orderController, locationController, carts,
      restController, _scheduleDate, _total, _discount, _tax) {
    AddressModel _address = orderController.addressIndex == -1
        ? Get.find<LocationController>().getUserAddress()
        : locationController.addressList[orderController.addressIndex];
    orderController.placeOrder(
        PlaceOrderBody(
          cart: carts,
          couponDiscountAmount: Get.find<CouponController>().discount,
          distance: orderController.distance,
          couponDiscountTitle: Get.find<CouponController>().discount > 0
              ? Get.find<CouponController>().coupon.title
              : null,
          scheduleAt: !restController.restaurant.scheduleOrder
              ? null
              : (orderController.selectedDateSlot == 0 &&
                      orderController.selectedTimeSlot == 0)
                  ? null
                  : DateConverter.dateToDateAndTime(_scheduleDate),
          orderAmount: _total,
          orderNote: _noteController.text,
          orderType: orderController.orderType,
          paymentMethod: _isCashOnDeliveryActive
              ? orderController.paymentMethodIndex == 0
                  ? 'cash_on_delivery'
                  : 'digital_payment'
              : 'digital_payment',
          couponCode: (Get.find<CouponController>().discount > 0 ||
                  (Get.find<CouponController>().coupon != null &&
                      Get.find<CouponController>().freeDelivery))
              ? Get.find<CouponController>().coupon.code
              : null,
          restaurantId: _cartList[0].product.restaurantId,
          address: _address.address,
          latitude: _address.latitude,
          longitude: _address.longitude,
          addressType: _address.addressType,
          contactPersonName: _address.contactPersonName ??
              '${Get.find<UserController>().userInfoModel.fName} '
                  '${Get.find<UserController>().userInfoModel.lName}',
          contactPersonNumber: _address.contactPersonNumber ??
              Get.find<UserController>().userInfoModel.phone,
          discountAmount: _discount,
          taxAmount: _tax,
        ),
        _callback);
  }

  Widget _showBottomSheet(double _totalToPay) {
    print("index of payment method $paymentMethodIndex");

    print("show is $_show");
    if (_show) {
      if (paymentMethodIndex == 1) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              height: 100,
              width: double.infinity,
              color: Colors.grey.shade200,
              alignment: Alignment.center,
              child: Column(
                children: [
                  pay.ApplePayButton(
                    paymentConfigurationAsset: 'gpay.json',
                    paymentItems: _paymentItems,
                    style: pay.ApplePayButtonStyle.black,
                    type: pay.ApplePayButtonType.buy,
                    margin: const EdgeInsets.only(top: 15.0),
                    onPaymentResult: (s) {
                      print("apple pay");
                    },
                    loadingIndicator: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  pay.GooglePayButton(
                      paymentConfigurationAsset: 'gpay.json',
                      width: 150,
                      paymentItems: _paymentItems,
                      //style: pay.GooglePayButtonStyle.black,
                      type: pay.GooglePayButtonType.pay,
                      margin: const EdgeInsets.only(top: 25.0, left: 10),
                      onPaymentResult: (s) {
                        print("google pay ing ing");
                        _show = false;
                        setState(() {});
                      },
                      loadingIndicator: const Center(
                        child: CircularProgressIndicator(),
                      )),
                  ElevatedButton(
                    child: Text("Close"),
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                      primary: Colors.green,
                    ),
                    onPressed: () {
                      _show = false;
                      setState(() {});
                    },
                  )
                ],
              ),
            );
          },
        );
      }
      if (paymentMethodIndex == 2) {
        //initialiseStripe();

        return BottomSheet(
          onClosing: () {
            confirmOrderTabbed = false;
          },
          builder: (context) {
            return Container(
              height: 100,
              width: double.infinity,
              color: Colors.white,
              alignment: Alignment.center,
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                  ),
                  ElevatedButton(
                    child: Text(
                      "Pay",
                      style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontSize: 30,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.deepOrangeAccent,
                      primary: Colors.black87,
                    ),
                    onPressed: () async {
                      //        await makePayment();
                    },
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Text(
                    _totalToPay.toString(),
                    style: TextStyle(
                      color: Colors.deepOrangeAccent,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    } else {
      return null;
    }
  }

  void _callback(bool isSuccess, String message, String orderID) async {
    if (isSuccess) {
      Get.find<OrderController>().stopLoader();
      setState(() {
        paymentMethodIndex = Get.find<OrderController>().paymentMethodIndex;
      });
      print(
          '---index of paymentmethods----${Get.find<OrderController>().paymentMethodIndex}');
      if (_isCashOnDeliveryActive &&
          Get.find<OrderController>().paymentMethodIndex == 0) {
        print("YES I am here");
        Get.offNamed(RouteHelper.getOrderSuccessRoute(orderID, 'success'));
      } else {
        print("NO NO! I am here");
        if (GetPlatform.isWeb) {
          Get.back();
          String hostname = html.window.location.hostname;
          String protocol = html.window.location.protocol;
          String selectedUrl =
              '${AppConstants.BASE_URL}/payment-mobile?order_id=$orderID&&customer_id=${Get.find<UserController>().userInfoModel.id}&&callback=$protocol//$hostname${RouteHelper.orderSuccess}?id=$orderID&status=';
          html.window.open(selectedUrl, "_self");
        } else {
          print("on mobile  YES I am here");

          //    _show = true;
          //    setState(() {

          //   });
          //  Get.offNamed(RouteHelper.getPaymentRoute(orderID, Get.find<UserController>().userInfoModel.id));
        }
      }
      if (is_user_charged) {
        Get.find<OrderController>().clearPrevData();
        Get.find<CouponController>().removeCouponData(false);
      }
    } else {
      showCustomSnackBar(message);
    }
  }

  void makepay() async {
    //initialiseStripe();
    //await makePayment();
  }

  // Future<void> makePayment() async {
  //   try {
  //     paymentIntentData = await createPaymentIntent(
  //         _totalToPay.toString(), 'GBP'); //json.decode(response.body);
  //     // print('Response body==>${response.body.toString()}');
  //     await Stripe.instance
  //         .initPaymentSheet(
  //             paymentSheetParameters: SetupPaymentSheetParameters(
  //                 paymentIntentClientSecret: paymentIntentData['client_secret'],
  //                 //Todo: comment paymnet method
  //                 // applePay: true,
  //                 // googlePay: true,
  //                 // testEnv: true,
  //                 // style: ThemeMode.dark,
  //                 // merchantCountryCode: 'UK',
  //                 merchantDisplayName: 'Salva Fast Food'))
  //         .then((value) {});
  //
  //     ///now finally display payment sheeet
  //
  //     // displayPaymentSheet();
  //   } catch (e, s) {
  //     print('exception:$e$s');
  //   }
  // }

  // displayPaymentSheet() async {
  //   try {
  //     await Stripe.instance
  //         .presentPaymentSheet(
  //             parameters: PresentPaymentSheetParameters(
  //       clientSecret: paymentIntentData['client_secret'],
  //       confirmPayment: true,
  //     ),)
  //         .then((newValue) {
  //       print('payment intent' + paymentIntentData['id'].toString());
  //       print('payment intent' + paymentIntentData['client_secret'].toString());
  //       print('payment intent' + paymentIntentData['amount'].toString());
  //       print('payment intent' + paymentIntentData.toString());
  //       //orderPlaceApi(paymentIntentData!['id'].toString());
  //       is_user_charged = true;
  //       print("---- PAID PAID PAID");
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text("paid successfully")));
  //
  //       paymentIntentData = null;
  //     }).onError((error, stackTrace) {
  //       print("---- NO PAID NO PAID NO PAID");
  //       is_user_charged = false;
  //       print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
  //     });
  //
  //     print("user payment status $is_user_charged");
  //     if (is_user_charged) {
  //       getOrderPlaced(
  //           this.orderController,
  //           this.locationController,
  //           this.carts,
  //           this.restController,
  //           this._scheduleDate,
  //           this._total,
  //           this._discount,
  //           this._tax);
  //     }
  //   } on StripeException catch (e) {
  //     is_user_charged = false;
  //     print("---- NO PAID NO PAID NO PAID");
  //     print('Exception/DISPLAYPAYMENTSHEET==> $e');
  //     print("user payment status $is_user_charged");
  //     showDialog(
  //         context: context,
  //         builder: (_) => AlertDialog(
  //               content: Text("Cancelled "),
  //             ));
  //   } catch (e) {
  //     print('$e');
  //   }
  // }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      print("-- total to pay ****** ${_totalToPay.toString()}");
      Map<String, dynamic> body = {
        'amount': _totalToPay.toString(),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51JCskPGJw4LwnASwJERnuogL4q8PUP3b6Bhaq9jCatRtCA32vSRzI7VyktZIGv2423ZZEU4F3aremQI6QnujK4dl00zCaIVbyD',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      print('Create Intent reponse ===> ${response.body.toString()}');
      print(" SUSCCESS of carged or not ");
      return jsonDecode(response.body);
    } catch (err) {
      print(" Failure  - confimed not charged");
      is_user_charged = false;
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }

  Future<bool> _exitApp(BuildContext context) async {
    return Get.dialog(
        PaymentFailedDialog(orderID: widget.orderModel.id.toString()));
  }
}
