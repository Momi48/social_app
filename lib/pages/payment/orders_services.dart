import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:social_app/pages/wallet_page.dart';

class OrdersPage extends StatefulWidget {
   
  const OrdersPage({super.key,});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final GlobalKey<FormState> paymentForm = GlobalKey<FormState>();
  final TextEditingController? paymentController = TextEditingController();
  Map<String, dynamic>? paymentIntentData;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Payment'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: paymentForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Enter Amount',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: paymentController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      hintText: 'Enter amount ',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Amount is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: theme.primaryColor,
                    elevation: 5,
                  ),
                  onPressed: () {
                    if (paymentForm.currentState!.validate()) {
                      makePayment( paymentController!.text.toString(), 'USD');
                    }
                  },
                  child: Text(
                    'Make Payment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  makePayment(String amount, String currency) async {
    paymentIntentData = await createPaymnetIntent(amount, currency);

    if (Platform.isIOS) {
      if (paymentIntentData == null) return;
      debugPrint('Sup IOS');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          googlePay: PaymentSheetGooglePay(
            merchantCountryCode: "US",
            currencyCode: "USD",
          ),
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
          merchantDisplayName: 'Muzzammil',
          applePay: PaymentSheetApplePay(merchantCountryCode: 'US'),
        ),
      );
      

      displayPaymentSheet();
    } else {
      if (paymentIntentData == null) return;
      
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          googlePay: PaymentSheetGooglePay(
            merchantCountryCode: "US",
            currencyCode: "USD",
          ),
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
          merchantDisplayName: 'Muzzammil',
        ),
      );
    

      displayPaymentSheet();
    }
  }

  createPaymnetIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': (int.parse(amount) * 100).toString(),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      
   
      if (response.statusCode >= 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Amount is too small. Amount should 100 or Greater '),
            backgroundColor: Colors.red,
          ),
        );
      }
      return jsonDecode(response.body.toString());
    } catch (e) {
      debugPrint('Error $e');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      var paymentIntentId = paymentIntentData!['id'];
      print('Pay is $paymentIntentId');
      Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => WalletPage(
      paymentAmount: paymentController!.text,
      paymentid: paymentIntentId, 
    ),
  )
).then((_) =>{
  setState(() {
    
  })
});
    } on StripeException catch (se) {
      debugPrint('Payment Failed ${se.toString()}');
    } catch (e) {
      debugPrint('Error ${e.toString()}');
    }
  }
  
}
