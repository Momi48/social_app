import 'package:flutter/material.dart';
import 'package:social_app/global/global_variablles.dart';

class NoTransaction extends StatelessWidget {
  final VoidCallback onTap;
  const NoTransaction({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 55,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(30),
        ),
        
        child: Center(
          child: Text(
            'Top Up Money',
            style: TextStyle(
              color: backgroundColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
