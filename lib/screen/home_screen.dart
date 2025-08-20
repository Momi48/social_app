import 'package:flutter/material.dart';
import 'package:social_app/global/global_variablles.dart';
import 'package:social_app/pages/discover_page.dart';
import 'package:social_app/pages/payment/orders_services.dart';
import 'package:social_app/pages/settings_page.dart';
import 'package:social_app/pages/wallet_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//PersistentTabController controller = PersistentTabController(initialIndex: 2);
  List<Widget> pages = [DiscoverPage(), OrdersPage(), WalletPage(), SettingsPage()];
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
       body: IndexedStack(
        index: currentIndex,
        children: pages,
      
      ),
         bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          iconSize: 30,
          items:  [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore,),
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
              label: 'Settigs',
            
            ),
            
          ],
          selectedItemColor: containerColor,
          unselectedItemColor: Colors.grey,
          ),
    );
    
    //  PersistentTabView(
    //   controller: controller,
    //     tabs: [
         
    //       PersistentTabConfig(
    //         screen: DiscoverPage(),
    //         item: ItemConfig(
    //           icon: Icon(Icons.home),
    //           title: "Home",
    //         ),
    //       ),
    //       PersistentTabConfig(
    //         screen: OrdersPage(),
    //         item: ItemConfig(
    //           icon: Icon(Icons.shopping_bag),
    //           title: "Order",
    //         ),
    //       ),
    //        PersistentTabConfig(
    //         screen: WalletPage(),
    //         item: ItemConfig(
    //           icon: Icon(Icons.wallet),
    //           title: "Wallet Page",
    //         ),
    //       ),
    //         PersistentTabConfig(
    //         screen: SettingsPage(),
    //         item: ItemConfig(
    //           icon: Icon(Icons.settings),
    //           title: "Setting ",
    //         ),
    //       ),
    //     ],
    //     navBarBuilder: (NavBarConfig navBar) => NeumorphicBottomNavBar(navBarConfig: navBar),
    // );

 
}
}

