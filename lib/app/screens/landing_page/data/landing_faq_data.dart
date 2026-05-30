import 'package:saas/app/screens/landing_page/controllers/faq_chatbot_controller.dart';

/// FAQ cards shown in landing page section (keep original three only).
const landingFaqCardEntries = <FaqChatEntry>[
  FaqChatEntry(
    question: 'Can I customize the notification messages?',
    answer:
        'Absolutely! You can fully customize the content, timing, and channel (WhatsApp, Email) for every notification sent.',
    relatedQuestions: [
      'What channels does Recrip support for reminders?',
      'How do I get started with Recrip?',
      'Does Recrip help recover missed payments?',
    ],
  ),
  FaqChatEntry(
    question: 'Is my customer data secure?',
    answer:
        'Yes, we use bank-grade encryption and are fully GDPR and SOC2 compliant. Your data is isolated and protected at all times.',
    relatedQuestions: [
      'Can I import my existing customer list?',
      'What businesses is Recrip best for?',
      'Does Recrip provide analytics?',
    ],
  ),
  FaqChatEntry(
    question: 'What businesses is Recrip best for?',
    answer:
        'Recrip is designed for any business with recurring subscriptions, including gyms, salons, clinics, SaaS, and service providers.',
    relatedQuestions: [
      'How do I get started with Recrip?',
      'Can I import my existing customer list?',
      'What can I manage from the dashboard?',
    ],
  ),
];

/// Extended FAQ source used by the chatbot retrieval.
const landingChatbotEntries = <FaqChatEntry>[
  ...landingFaqCardEntries,
  FaqChatEntry(
    question: 'What channels does Recrip support for reminders?',
    answer:
        'Recrip supports WhatsApp and Email reminders. Starter includes WhatsApp reminders, while Growth supports WhatsApp and Email reminders.',
    relatedQuestions: [
      'Can I customize the notification messages?',
      'What is included in the Starter plan?',
      'What is included in the Growth plan?',
    ],
  ),
  FaqChatEntry(
    question: 'How do I get started with Recrip?',
    answer:
        'Start in three steps: add your customers, create subscription plans, then automate reminders while tracking renewals and revenue from the dashboard.',
    relatedQuestions: [
      'Can I import my existing customer list?',
      'What can I manage from the dashboard?',
      'Does Recrip provide analytics?',
    ],
  ),
  FaqChatEntry(
    question: 'Does Recrip provide analytics?',
    answer:
        'Yes. Recrip includes analytics for revenue, renewals, missed payments, and member activity so you can see where follow-up is needed and what revenue has been recovered.',
    relatedQuestions: [
      'What reports can I export?',
      'What can I manage from the dashboard?',
      'Does Recrip help recover missed payments?',
    ],
  ),
  FaqChatEntry(
    question: 'Does Recrip help recover missed payments?',
    answer:
        'Yes. Recrip helps reduce churn with renewal tracking, reminder automation, and follow-up workflows that help bring expiring or expired members back into active status.',
    relatedQuestions: [
      'What channels does Recrip support for reminders?',
      'Does Recrip provide analytics?',
      'What can I manage from the dashboard?',
    ],
  ),
  FaqChatEntry(
    question: 'What is included in the Starter plan?',
    answer:
        'Starter is priced at ₹1499 and includes 300 members, WhatsApp reminders, renewal alerts, default reminders, and current-month report export.',
    relatedQuestions: [
      'What is included in the Growth plan?',
      'Do you offer a free trial?',
      'Can I cancel anytime?',
    ],
  ),
  FaqChatEntry(
    question: 'What is included in the Growth plan?',
    answer:
        'Growth is priced at ₹2499 and includes unlimited members, WhatsApp/Email reminders, advanced insights, custom reminders, custom ad templates, priority support, and custom report export.',
    relatedQuestions: [
      'What is included in the Starter plan?',
      'Is priority support available?',
      'Do you offer a free trial?',
    ],
  ),
  FaqChatEntry(
    question: 'Do you offer a free trial?',
    answer:
        'Yes. Recrip offers a free 14-day trial with no setup fees and no credit card required.',
    relatedQuestions: [
      'Can I cancel anytime?',
      'What is included in the Starter plan?',
      'What is included in the Growth plan?',
    ],
  ),
  FaqChatEntry(
    question: 'Can I cancel anytime?',
    answer: 'Yes, you can cancel anytime.',
    relatedQuestions: [
      'Do you offer a free trial?',
      'What is included in the Starter plan?',
      'Is priority support available?',
    ],
  ),
  FaqChatEntry(
    question: 'Is priority support available?',
    answer:
        'Yes. Priority support is available 24/7 and is also included in the Growth plan.',
    relatedQuestions: [
      'What is included in the Growth plan?',
      'Can I cancel anytime?',
      'How do I get started with Recrip?',
    ],
  ),
  FaqChatEntry(
    question: 'Can I import my existing customer list?',
    answer:
        'Yes. You can import your existing customer list or sync with your current CRM to get started quickly.',
    relatedQuestions: [
      'How do I get started with Recrip?',
      'Is my customer data secure?',
      'What businesses is Recrip best for?',
    ],
  ),
  FaqChatEntry(
    question: 'What can I manage from the dashboard?',
    answer:
        'The dashboard gives you a quick view of active members, upcoming expiries, renewals, reminders, revenue insights, and action items so you can manage day-to-day subscription operations from one place.',
    relatedQuestions: [
      'Does Recrip provide analytics?',
      'Does Recrip help recover missed payments?',
      'What reports can I export?',
    ],
  ),
  FaqChatEntry(
    question: 'What reports can I export?',
    answer:
        'Recrip lets you export renewal and revenue-focused reports so you can review business performance, track recovered revenue, and share current-period results with your team.',
    relatedQuestions: [
      'Does Recrip provide analytics?',
      'What can I manage from the dashboard?',
      'What is included in the Growth plan?',
    ],
  ),
  FaqChatEntry(
    question: 'Can Recrip manage members and subscription plans?',
    answer:
        'Yes. Recrip is built to manage members, subscription plans, renewal dates, reminder workflows, and payment-related follow-up in one recurring-revenue system.',
    relatedQuestions: [
      'How do I get started with Recrip?',
      'What can I manage from the dashboard?',
      'What businesses is Recrip best for?',
    ],
  ),
];
