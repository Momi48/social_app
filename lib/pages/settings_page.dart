import 'package:flutter/material.dart';

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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings "),
        
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: settingsItems.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            leading: Icon(
              settingsItems[index]['icon'],
              color: Color(0xff0d0d0d),
            ),
            title: Text(settingsItems[index]['title']),

            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  settingsItems[index]['content'],
                  
                  style: TextStyle(fontSize: 14, color: Color(0xff0d0d0d)),
                ),
                
              ),
              
            ],
          );
        },
      ),
    );
  }
}
