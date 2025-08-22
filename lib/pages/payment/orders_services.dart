import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/provider/payment_provider.dart';

class OrderServices extends StatefulWidget {
  const OrderServices({super.key});

  @override
  State<OrderServices> createState() => _OrderServicesState();
}

class _OrderServicesState extends State<OrderServices> {
  final TextEditingController amountController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<PaymentProvider>(context);
    String? paymentIntentID;
    return Scaffold(
      appBar: AppBar(title: const Text("Wallet")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input field for amount
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter amount",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Pay button
            ElevatedButton(
              onPressed: () async {
                final amount = amountController.text.trim();
                if (amount.isNotEmpty) {
                  
                  final paymentProvider = Provider.of<PaymentProvider>(
                    context,
                    listen: false,
                  );

                  walletProvider.makePayment(amount, "USD").then((_) {
                    paymentProvider.fetchErrorLogs();
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter an amount")),
                  );
                }
              },
              child: const Text("Pay"),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
