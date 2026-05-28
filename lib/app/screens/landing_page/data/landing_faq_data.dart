import 'package:saas/app/screens/landing_page/controllers/faq_chatbot_controller.dart';

/// FAQ cards shown in landing page section (keep original three only).
const landingFaqCardEntries = <FaqChatEntry>[
  FaqChatEntry(
    question: 'Can I customize the notification messages?',
    answer:
        'Absolutely! You can fully customize the content, timing, and channel (WhatsApp, Email) for every notification sent.',
  ),
  FaqChatEntry(
    question: 'Is my customer data secure?',
    answer:
        'Yes, we use bank-grade encryption and are fully GDPR and SOC2 compliant. Your data is isolated and protected at all times.',
  ),
  FaqChatEntry(
    question: 'What businesses is Recrip best for?',
    answer:
        'Recrip is designed for any business with recurring subscriptions, including gyms, salons, clinics, SaaS, and service providers.',
  ),
];

/// Extended FAQ source used by the chatbot retrieval.
const landingChatbotEntries = <FaqChatEntry>[
  ...landingFaqCardEntries,
  FaqChatEntry(
    question: 'What channels does Recrip support for reminders?',
    answer:
        'Recrip supports WhatsApp and Email reminders. Starter includes WhatsApp reminders, while Growth supports WhatsApp and Email reminders.',
  ),
  FaqChatEntry(
    question: 'How do I get started with Recrip?',
    answer:
        'Start in three steps: add your customers, set renewal schedules, then automate follow-ups while tracking revenue in real time.',
  ),
  FaqChatEntry(
    question: 'Does Recrip provide analytics?',
    answer:
        'Yes. Recrip includes an analytics dashboard to track revenue, renewals, and customer behavior insights.',
  ),
  FaqChatEntry(
    question: 'Does Recrip help recover missed payments?',
    answer:
        'Yes. Recrip provides payment recovery with automated retries to help reduce churn and recover missed payments.',
  ),
  FaqChatEntry(
    question: 'What is included in the Starter plan?',
    answer:
        'Starter is priced at ₹1499 and includes 300 members, WhatsApp reminders, renewal alerts, default reminders, and current-month report export.',
  ),
  FaqChatEntry(
    question: 'What is included in the Growth plan?',
    answer:
        'Growth is priced at ₹2499 and includes unlimited members, WhatsApp/Email reminders, advanced insights, custom reminders, custom ad templates, priority support, and custom report export.',
  ),
  FaqChatEntry(
    question: 'Do you offer a free trial?',
    answer:
        'Yes. Recrip offers a free 14-day trial with no setup fees and no credit card required.',
  ),
  FaqChatEntry(
    question: 'Can I cancel anytime?',
    answer: 'Yes, you can cancel anytime.',
  ),
  FaqChatEntry(
    question: 'Is priority support available?',
    answer:
        'Yes. Priority support is available 24/7 and is also included in the Growth plan.',
  ),
  FaqChatEntry(
    question: 'Can I import my existing customer list?',
    answer:
        'Yes. You can import your existing customer list or sync with your current CRM to get started quickly.',
  ),
];
