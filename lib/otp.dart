// import 'dart:async';
//
// import 'package:efood_multivendor/test.dart';
// import 'package:efood_multivendor/view/screens/auth/widget/code_picker_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:pinput/pinput.dart';
//
// class OtpView extends StatefulWidget {
//   const OtpView({Key key}) : super(key: key);
//
//   @override
//   State<OtpView> createState() => _OtpViewState();
// }
//
// class _OtpViewState extends State<OtpView> {
// // text controller
//   final TextEditingController _myController = TextEditingController();
//
//   int countdownSeconds = 10;
//   Timer timer;
//
//   @override
//   void initState() {
//     super.initState();
//     startCountdown();
//   }
//
//   void startCountdown() {
//     timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
//       setState(() {
//         if (countdownSeconds > 0) {
//           countdownSeconds--;
//         } else {
//           timer.cancel();
//         }
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               tileMode: TileMode.mirror,
//               colors: [
//             Colors.black.withOpacity(0.10000000149011612),
//             Colors.black.withOpacity(0.10000000149011612),
//             Colors.black.withOpacity(0.10000000149011612),
//             Color(0xff000000),
//           ])),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           leading: Container(
//             margin: EdgeInsets.only(top: 20, right: 10, bottom: 16),
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 1,
//                       spreadRadius: 1,
//                       offset: Offset(0, 3))
//                 ],
//                 border: Border.all(color: Color(0xFFDDD7FF), width: 1),
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(15),
//                     bottomRight: Radius.circular(15))),
//             child: Icon(Icons.arrow_back_ios, size: 14, color: Colors.black),
//           ),
//         ),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Image.asset('assets/image/mobileGif.png', width: 219, height: 200),
//             SizedBox(height: 26),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text.rich(
//                   TextSpan(
//                     children: [
//                       TextSpan(
//                         text: 'Vous avez reçu un ',
//                         style: TextStyle(
//                           color: Color(0xFFEDEDED),
//                           fontSize: 15,
//                           fontFamily: 'Montaga',
//                           fontWeight: FontWeight.w400,
//                           height: 0,
//                         ),
//                       ),
//                       TextSpan(
//                         text: 'OTP',
//                         style: TextStyle(
//                           color: Color(0xFF9F85FF),
//                           fontSize: 15,
//                           fontFamily: 'Montaga',
//                           fontWeight: FontWeight.w400,
//                           height: 0,
//                         ),
//                       ),
//                       TextSpan(
//                         text: ' sur votre numéro.',
//                         style: TextStyle(
//                           color: Color(0xFFEDEDED),
//                           fontSize: 15,
//                           fontFamily: 'Montaga',
//                           fontWeight: FontWeight.w400,
//                           height: 0,
//                         ),
//                       ),
//                     ],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 Image.asset('assets/image/search.png', width: 20, height: 20)
//               ],
//             ),
//             SizedBox(height: 26),
// // display the entered numbers
//             OtpFieldsView(pinController: _myController),
//             SizedBox(height: 26),
//             SizedBox(
//               width: 271,
//               child: Text.rich(
//                 TextSpan(
//                   children: [
//                     TextSpan(
//                       text: 'Vous n\'avez pas reçu l’',
//                       style: TextStyle(
//                         color: Color(0xFFEDEDED),
//                         fontSize: 15,
//                         fontFamily: 'Montaga',
//                         fontWeight: FontWeight.w400,
//                         height: 0.09,
//                       ),
//                     ),
//                     TextSpan(
//                       text: 'Accès',
//                       style: TextStyle(
//                         color: Color(0xFF9F85FF),
//                         fontSize: 15,
//                         fontFamily: 'Montaga',
//                         fontWeight: FontWeight.w400,
//                         height: 0.09,
//                       ),
//                     ),
//                     TextSpan(
//                       text: ' ?',
//                       style: TextStyle(
//                         color: Color(0xFFEDEDED),
//                         fontSize: 15,
//                         fontFamily: 'Montaga',
//                         fontWeight: FontWeight.w400,
//                         height: 0.09,
//                       ),
//                     ),
//                     TextSpan(
//                       text: '\n\'Renvoyer dans 00:$countdownSeconds',
//                       style: TextStyle(
//                         color: Color(0xFF9F85FF),
//                         fontSize: 15,
//                         fontFamily: 'Montaga',
//                         fontWeight: FontWeight.w400,
//                         decoration: TextDecoration.underline,
//                       ),
//                     )
//                   ],
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             SizedBox(height: 26),
// // implement the custom NumPad
//             NumPad(
//               buttonSize: 75,
//               buttonColor: Colors.white,
//               controller: _myController,
//               delete: () {
//                 _myController.text = _myController.text
//                     .substring(0, _myController.text.length - 1);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class NumPad extends StatelessWidget {
//   final double buttonSize;
//   final Color buttonColor;
//   final Color iconColor;
//   final TextEditingController controller;
//   final Function delete;
//   final Function onSubmit;
//
//   const NumPad({
//     Key key,
//     this.buttonSize = 70,
//     this.buttonColor = Colors.grey,
//     this.iconColor = Colors.amber,
//     this.delete,
//     this.onSubmit,
//     this.controller,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(left: 30, right: 30),
//       child: Column(
//         children: [
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             // implement the number keys (from 0 to 9) with the NumberButton widget
//             // the NumberButton widget is defined in the bottom of this file
//             children: [
//               NumberButton(
//                 number: 1,
//                 size: buttonSize,
//                 shadowColor: [
//                   BoxShadow(color: Colors.black, blurRadius: 0, spreadRadius: 0)
//                 ],
//                 controller: controller,
//               ),
//               NumberButton(
//                 number: 2,
//                 size: buttonSize,
//                 shadowColor: [
//                   BoxShadow(color: Colors.black, blurRadius: 0, spreadRadius: 0)
//                 ],
//                 controller: controller,
//               ),
//               NumberButton(
//                 number: 3,
//                 size: buttonSize,
//                 shadowColor: [
//                   BoxShadow(color: Colors.black, blurRadius: 0, spreadRadius: 0)
//                 ],
//                 controller: controller,
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               NumberButton(
//                 number: 4,
//                 size: buttonSize,
//                 shadowColor: [
//                   BoxShadow(color: Colors.black, blurRadius: 0, spreadRadius: 0)
//                 ],
//                 controller: controller,
//               ),
//               NumberButton(
//                 number: 5,
//                 size: buttonSize,
//                 shadowColor: [
//                   BoxShadow(color: Colors.black, blurRadius: 0, spreadRadius: 0)
//                 ],
//                 controller: controller,
//               ),
//               NumberButton(
//                 number: 6,
//                 size: buttonSize,
//                 shadowColor: [
//                   BoxShadow(color: Colors.black, blurRadius: 0, spreadRadius: 0)
//                 ],
//                 controller: controller,
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               NumberButton(
//                 number: 7,
//                 size: buttonSize,
//                 shadowColor: [
//                   BoxShadow(color: Colors.black, blurRadius: 0, spreadRadius: 0)
//                 ],
//                 controller: controller,
//               ),
//               NumberButton(
//                 number: 8,
//                 size: buttonSize,
//                 shadowColor: [
//                   BoxShadow(color: Colors.black, blurRadius: 0, spreadRadius: 0)
//                 ],
//                 controller: controller,
//               ),
//               NumberButton(
//                 number: 9,
//                 size: buttonSize,
//                 shadowColor: [
//                   BoxShadow(color: Colors.black, blurRadius: 0, spreadRadius: 0)
//                 ],
//                 controller: controller,
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               // this button is used to delete the last number
//               SizedBox(
//                 height: 40,
//                 width: 70,
//                 child: IconButton(
//                   onPressed: () => delete(),
//                   icon: Icon(
//                     Icons.keyboard_double_arrow_left,
//                     color: Colors.white,
//                     size: 22,
//                   ),
//                   iconSize: buttonSize,
//                 ),
//               ),
//               NumberButton(
//                 number: 0,
//                 size: buttonSize,
//                 color: [Colors.black, Colors.black, Colors.black, Colors.black],
//                 numberColors: Colors.white,
//                 shadowColor: [
//                   BoxShadow(color: Colors.black, blurRadius: 0, spreadRadius: 0)
//                 ],
//                 borderColors: Color(0xffffffff),
//                 borderRadius: 20,
//                 controller: controller,
//               ),
//               // this button is used to submit the entered value
//               SizedBox(
//                 height: 40,
//                 width: 70,
//                 child: Image.asset('assets/image/aigle.png',
//                     width: 56, height: 50),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class OtpFieldsView extends StatefulWidget {
//   TextEditingController pinController;
//
//   OtpFieldsView({this.pinController});
//
//   @override
//   State<OtpFieldsView> createState() => _OtpFieldsViewState();
// }
//
// class _OtpFieldsViewState extends State<OtpFieldsView> {
//   // final pinController = TextEditingController();
//   final focusNode = FocusNode();
//   final formKey = GlobalKey<FormState>();
//
//   String _otp;
//
//   @override
//   void dispose() {
//     // pinController.removeListener(_updateFieldsFilled);
//     focusNode.dispose();
//     // _fieldsFilled.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const focusedBorderColor = Colors.white;
//     const fillColor = Color.fromRGBO(243, 246, 249, 0);
//     const borderColor = Colors.grey;
//
//     final defaultPinTheme = PinTheme(
//       width: 56,
//       height: 56,
//       textStyle: const TextStyle(
//         fontSize: 22,
//         color: Color.fromRGBO(30, 60, 87, 1),
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//     );
//     return Form(
//       key: formKey,
//       child: Directionality(
//         // Specify direction if desired
//         textDirection: TextDirection.ltr,
//         child: Pinput(
//           controller: widget.pinController,
//           focusNode: focusNode,
//           readOnly: true,
//           androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
//           listenForMultipleSmsOnAndroid: true,
//           defaultPinTheme: defaultPinTheme.copyDecorationWith(),
//           separatorBuilder: (index) => SizedBox(width: 10),
//           onClipboardFound: (value) {
//             debugPrint('onClipboardFound: $value');
//           },
//           hapticFeedbackType: HapticFeedbackType.lightImpact,
//           onCompleted: (pin) {
//             debugPrint('onCompleted: $pin');
//           },
//           cursor: SizedBox.shrink(),
//           focusedPinTheme: defaultPinTheme,
//           submittedPinTheme: defaultPinTheme,
//           errorPinTheme: defaultPinTheme,
//         ),
//       ),
//     );
//   }
// }
