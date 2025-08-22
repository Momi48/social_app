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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet"),
        elevation: 2,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center( // centers the column horizontally
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // centers vertically
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Input field for amount
              TextField(
                controller: amountController,
                textAlign: TextAlign.center, // centers text inside field
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter amount",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Pay button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  backgroundColor: theme.primaryColor,
                  elevation: 6,
                ),
                onPressed: () {
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
                  
                  //amountController.clear();
                },
                child: const Text(
                  'Make Payment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Help button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  backgroundColor: Colors.redAccent,
                  elevation: 6,
                ),
                onPressed: () {
                  final navigationProvider =
                      Provider.of<PaymentProvider>(context, listen: false);
                  navigationProvider.setCurrentIndex(3);
                },
                child: const Text(
                  'Payment issue? Tap here to contact our helpline.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
