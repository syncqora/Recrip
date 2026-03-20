import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'views/terms_and_conditions_mobile_view.dart';
import 'views/terms_and_conditions_tablet_view.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  static const String _termsText =
      "Terms and Conditions\n\n"
      "1. Introduction\n"
      "Welcome to our application. By using our service, you agree to these terms.\n\n"
      "2. Usage Policy\n"
      "You agree to use this application only for lawful purposes...\n\n"
      "3. Privacy\n"
      "Your privacy is important to us. Please read our privacy policy for more details...\n\n"
      "4. Changes to Terms\n"
      "We reserve the right to modify these terms at any time. Your continued use of the application constitutes acceptance of the new terms.";

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 600) {
      return const TermsAndConditionsMobileView(termsText: _termsText);
    }

    if (width < 1024) {
      return const TermsAndConditionsTabletView(termsText: _termsText);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Terms and Conditions")),
      body: const Padding(
        padding: EdgeInsets.all(48),
        child: SingleChildScrollView(
          child: Text(
            _termsText,
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
