import 'package:flutter/material.dart';

class TermsAndConditionsTabletView extends StatelessWidget {
  const TermsAndConditionsTabletView({super.key, required this.termsText});

  final String termsText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Terms and Conditions")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
        child: SingleChildScrollView(
          child: Text(
            termsText,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
