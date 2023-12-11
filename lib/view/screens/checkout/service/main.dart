// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:efood_multivendor/view/screens/checkout/service/home_screen.dart';
import 'package:flutter/material.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  // Stripe.publishableKey = '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';
  //
  // await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

