import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/global/global_variablles.dart';
import 'package:social_app/pages/discover_page.dart';
import 'package:social_app/pages/payment/orders_services.dart';
import 'package:social_app/pages/settings_page.dart';
import 'package:social_app/pages/wallet_page.dart';
import 'package:social_app/provider/payment_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentProvider>(
      builder: (context, navigationProvider, child) {
        final List<Widget> pages = [
          DiscoverPage(),
          OrderServices(),
          WalletPage(),
          SettingsPage(),
        ];

        return Scaffold(
          body: IndexedStack(
            index: navigationProvider.currentIndex,
            children: pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: navigationProvider.currentIndex,
            onTap: (value) {
              navigationProvider.setCurrentIndex(value);
            },
            iconSize: 30,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: 'Discover',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.wallet),
                label: 'Wallet',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            selectedItemColor: containerColor,
            unselectedItemColor: Colors.grey,
          ),
        );
      },
    );
  }
}