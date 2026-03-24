import 'package:flutter/material.dart';

class TermsAndConditionsMobileView extends StatelessWidget {
  const TermsAndConditionsMobileView({super.key, required this.termsText});

  final String termsText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms and Conditions"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            termsText,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
