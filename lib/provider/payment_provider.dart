import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentProvider with ChangeNotifier {
  int _balance = 0;
  String amount = '';
 
  List<Map<String, String>> transactions = [
    {"title": "Angga Big Park", "amount": "0", "paymentId": "dummy1"},
    {"title": "Top Up", "amount": "0", "paymentId": "dummy2"},
  ];
  Map<String, dynamic>? paymentIntentData;
 String? paymentIntentID;
  Map<String, dynamic>? _errorLogs;

  // Getters
  String? get _paymentIntentID => paymentIntentID;
  Map<String, dynamic>? get errorLogs => _errorLogs;
  int get balance => _balance;
   int _currentIndex = 2; // Default to WalletPage (index 2)

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
  /// Add amount to first transaction only
  void addTransaction(String amount, String paymentId) {
    final parsedAmount = int.tryParse(amount) ?? 0.0;
    _balance += int.parse(parsedAmount.toString());

    double firstAmount =
        double.tryParse(transactions[0]['amount'] ?? '0') ?? 0.0;
    firstAmount += parsedAmount;

    transactions[0]['amount'] = firstAmount.toStringAsFixed(2);
    transactions[0]['paymentId'] = paymentId;

    notifyListeners();
  }

  /// Stripe Payment Flow
  Future<void> makePayment(String amount, String currency) async {
    paymentIntentData = await _createPaymentIntent(amount, currency);

    if (paymentIntentData == null) return;

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        googlePay: PaymentSheetGooglePay(
          merchantCountryCode: "US",
          currencyCode: currency,
        ),
        paymentIntentClientSecret: paymentIntentData!['client_secret'],
        customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
        merchantDisplayName: 'Muzzammil',
        applePay: Platform.isIOS
            ? PaymentSheetApplePay(merchantCountryCode: 'US')
            : null,
      ),
    );

    await displayPaymentSheet(amount);
  }

  Future<void> displayPaymentSheet(String amount) async {
    try {
      await Stripe.instance.presentPaymentSheet(
        options: const PaymentSheetPresentOptions(),
      );

      paymentIntentID = paymentIntentData!['id'];
      addTransaction(amount, paymentIntentID!);

      debugPrint("Payment success, ID: $paymentIntentID");
    } on StripeException catch (se) {
      debugPrint('Payment Failed: ${se.toString()}');
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<Map<String, dynamic>?> _createPaymentIntent(
    String amount,
    String currency,
  ) async {
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
      final data = jsonDecode(response.body.toString());
      paymentIntentID = data['id'];
     
      print('Payment ID $paymentIntentID');
      return jsonDecode(response.body.toString());
    } catch (e) {
      debugPrint('createPaymentIntent Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> refundPayment() async {
    if (_balance <= 0 || transactions.isEmpty) {
      debugPrint('No money to refund.');
      return {'success': false, 'message': 'No money to refund'};
    }

    try {
      // Refund the total balance
      // final totalAmount = (_balance * 100).toInt().toString(); // in cents
      print('Total Balance in refund is $_balance');
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/refunds'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'payment_intent': paymentIntentID,
          'amount': _balance.toString(),
        },
      );
      print('Payment ID in refund is $paymentIntentID');
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Reset balance and clear transactions
        transactions[0]['amount'] = '0';

        notifyListeners();

        return {
          'success': true,
          'refundId': responseData['id'],
          'status': responseData['status'],
        };
      } else {
        throw Exception(responseData['error']['message'] ?? 'Refund failed');
      }
    } catch (e) {
      debugPrint('Refund error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

// In your PaymentProvider class


  Future<Map<String, dynamic>> fetchErrorLogs() async {
    if (_paymentIntentID == null) {
      _errorLogs = {
        "status": "no_id",
        "amount": 0,
        "message": "No payment intent ID available",
      };
      notifyListeners();
      return _errorLogs!;
    }

    try {
      final response = await http.get(
        Uri.parse('https://api.stripe.com/v1/payment_intents/$_paymentIntentID'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      final data = jsonDecode(response.body);
      final status = data['status'];
      final amount = data['amount'];
      final method = data['payment_method'];
      paymentIntentID = data['id'];

      if (response.statusCode == 200 && method == null) {
        _errorLogs = {
          "status": status,
          "amount": amount,
          "message": "Payment details retrieved",
        };
      } else {
        _errorLogs = {
          "status": "error",
          "amount": 0,
          "message": "Failed to fetch payment details",
        };
      }

      notifyListeners();
      return _errorLogs!;
    } catch (e) {
      _errorLogs = {
        "status": "error",
        "amount": 0,
        "message": "Exception occurred: $e",
      };
      notifyListeners();
      return _errorLogs!;
    }
  }

  /// Helper function to set paymentIntentID manually if needed
  void setPaymentIntent(String id) {
    paymentIntentID = id;
    notifyListeners();
  }
}
