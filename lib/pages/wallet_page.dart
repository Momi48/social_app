import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:social_app/global/global_variablles.dart';
import 'package:social_app/pages/payment/orders_services.dart';
import 'package:social_app/widgets/no_transaction.dart';

// ignore: must_be_immutable
class WalletPage extends StatefulWidget {
  String? paymentAmount;
  final String? paymentid;
  WalletPage({super.key, this.paymentAmount, this.paymentid});

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
     List<Map<String, dynamic>> transactions = [
      {
        'id': 1,
        'title': 'Angga Big Park',
        'amount': widget.paymentAmount ?? '0',
      },

      {'id': 2, 'title': 'Top Up', 'amount': "0"},
    ];
    return Scaffold(
      appBar: AppBar(title: Text("Wallet"),
      actions: [
       
      ],
      
      ),
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
                    "\$${widget.paymentAmount ?? '0'}",
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
                            "2208 1996 4900",
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
                              refundPayment(
                                widget.paymentid.toString(),
                                widget.paymentAmount.toString(),
                              );
                              print(
                                'Here in result is ${widget.paymentid} ${widget.paymentAmount}',
                              );
                              setState(() {});
                            },
                            icon: Icon(Icons.back_hand),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(transactions[index]['title'], style: style),
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
                              //   SizedBox(height: 2),
                              // Row(children: [
                              //    Transform.translate(
                              //         offset: const Offset(-2, 0),
                              //         child:  Icon(Icons.lock_clock, size: 20),
                              //       ),

                              //   Text('${transactions[index]['date']}', style: greyStyle),
                              // ],)
                          
                            ],
                          
                          ),
                        );
                      },
                    ),
                  )
                // No Transaction Section
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrdersPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> refundPayment(
    String paymentid,
    String paymentAmount,
  ) async {
    try {
      // 1. Prepare Stripe API request
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/refunds'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'payment_intent': paymentid, 'amount': paymentAmount},
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          widget.paymentAmount = '0'; // Reset to zero
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Refunded Amount ${widget.paymentAmount} Successfully ',
            ),
            backgroundColor: Colors.green,
          ),
        );
        return {
          'success': true,
          'refundId': responseData['id'],
          'status': responseData['status'],
        };
      } else {
        throw Exception(responseData['error']['message'] ?? 'Refund failed');
      }
    } catch (e) {
      throw Exception('Refund error: $e');
    }
  }
}
