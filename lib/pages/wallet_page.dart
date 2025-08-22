import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:social_app/global/global_variablles.dart';
import 'package:social_app/pages/payment/orders_services.dart';
import 'package:social_app/provider/payment_provider.dart';
import 'package:social_app/widgets/no_transaction.dart';
import 'package:uuid/uuid.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final style = TextStyle(fontWeight: FontWeight.bold, fontSize: 25);
  final greyStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Colors.grey,
  );
  
  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<PaymentProvider>(context);
    final transactions = walletProvider.transactions;
  final uuid = Uuid();
String randomId = uuid.v4();
    return Scaffold(
      appBar: AppBar(title: Text("Wallet"), actions: []),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Balance Card
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "\$${transactions.isNotEmpty ? transactions[0]['amount'] : '0'}",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  //Name + Card Number
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Angga Risky",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(height: 5),
                          Text(
                            randomId,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      Icon(LucideIcons.wallet, color: Colors.white, size: 20),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                transactions.isNotEmpty
                    ? Text(
                        'Latest\nTransaction ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )
                    : Text(''),
                transactions.isNotEmpty
                    ? Text(
                        'View All',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )
                    : Text(''),
              ],
            ),
            SizedBox(height: 15),

            transactions.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: containerColor,
                            maxRadius: 30,
                            minRadius: 10,
                            child: Icon(
                              Icons.wallet,
                              size: 28,
                              color: Colors.white,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              walletProvider.refundPayment();
                            },
                            icon: Icon(Icons.back_hand),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(transactions[index]['title'].toString(), style: style),
                              Row(
                                children: [
                                  Transform.translate(
                                    offset: const Offset(-2, 0),
                                    child: Icon(
                                      Icons.currency_bitcoin,
                                      size: 20,
                                    ),
                                  ),
                                  Text(
                                    " \$${transactions[index]['amount']}",
                                    style: greyStyle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : Column(
                    children: [
                      Image.asset(
                        'images/no_transaction.png',
                        width: 180,
                        height: 170,
                      ),
                      Text(
                        "No Transaction",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "You have no transactions data at this moment\n"
                        "and perhaps you can start booking a spot",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      NoTransaction(
                        onTap: () {
                          final navigationProvider = Provider.of<PaymentProvider>(context, listen: false);
    navigationProvider.setCurrentIndex(1);
                        },
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
