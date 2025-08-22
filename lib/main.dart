import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:social_app/provider/payment_provider.dart';
import 'package:social_app/screen/home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await dotenv.load(fileName: ".env");
  Stripe.publishableKey = dotenv.env["STRIPE_PUBLISHED_KEY"].toString();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaymentProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:HomeScreen()
      ),
    );
  }
}

