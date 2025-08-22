import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/provider/payment_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<Map<String, dynamic>> settingsItems = [
    {
      'icon': Icons.lock_outline,
      'title': 'Privacy & Security',
      'content': 'Update password, enable 2FA, and privacy controls.',
    },
    {
      'icon': Icons.headset_mic_outlined,
      'title': 'Help and Support',
      'content': 'Helpline Number: 12234-248391-2124.',
    },
    {
      'icon': Icons.info_outline,
      'title': 'About',
      'content': 'App version, licenses, and other details.',
    },
    {
      'icon': Icons.error,
      'title': 'Error',
      'content': 'Error Logs',
    }
  ];

  String? paymentIntentID; // You need to get this from somewhere

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Hello');
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: settingsItems.length,
        itemBuilder: (context, index) {
          final item = settingsItems[index];

          return ExpansionTile(
            leading: Icon(
              item['icon'],
              color: const Color(0xff0d0d0d),
            ),
            title: Text(item['title']),
            children: [
              if (item['title'] == 'Error')
  Consumer<PaymentProvider>(
    builder: (context, paymentProvider, child) {
      final logs = paymentProvider.errorLogs;
        
          
      if (logs != null && logs['status'] != 'requires_payment_method') {
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No Error Found')
        );

      }
     else if(logs == null){
       return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Updated Failed Payment Will be Shown Here')
        );
     }   
     
     print("logs is $logs");
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Payment Failed Status: ${logs!['status']}"),
            SizedBox(height: 8),
            Text("Failed to send ${logs['amount'] / 100}  "),
            SizedBox(height: 8),
            Text("Error Log Message: ${logs['message']}"),
          ],
        ),
      );
    },
  )

              else
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    item['content'],
                    style: const TextStyle(fontSize: 14, color: Color(0xff0d0d0d)),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}