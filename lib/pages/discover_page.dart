import 'package:flutter/material.dart';
import 'package:social_app/ad/ad_helper.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  void initState() {
    super.initState();
    AdHelper.loadBannerAd();
  }
  @override
  void dispose() {
    super.dispose();
    AdHelper.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Discover"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Monetization card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.monetization_on, color: Colors.green),
              title: const Text("A great way to monetize your app!"),
            ),
          ),
          const SizedBox(height: 16),

          // Ad Section
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child:  AdHelper.showBannerAd() 
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Buy Blue Ticket
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              leading: Icon(Icons.confirmation_num, color: Colors.blue.shade700),
              title: const Text("Buy Blue Ticket"),
              subtitle: const Text("Special pass for premium entry"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
              onTap: () {
                // Handle blue ticket purchase
              },
            ),
          ),
          const SizedBox(height: 12),

          // Entry Ticket
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              leading: Icon(Icons.attach_money, color: Colors.green.shade700),
              title: const Text("Entry Ticket"),
              subtitle: const Text("Cost: 4000/-"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
              onTap: () {
                // Handle entry ticket purchase
              },
            ),
          ),
        ],
      ),
    );
  }
}
