import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Chatbot question/answer source item.
class FaqChatEntry {
  /// Creates an FAQ source entry used by the chatbot.
  const FaqChatEntry({
    required this.question,
    required this.answer,
    this.relatedQuestions = const <String>[],
  });

  /// Exact question text to match.
  final String question;

  /// Bot answer returned for this exact question.
  final String answer;

  /// Suggested follow-up questions shown after this answer.
  final List<String> relatedQuestions;
}

/// Individual chat message shown in the chatbot UI.
class FaqChatMessage {
  /// Creates one user or bot message.
  const FaqChatMessage({required this.text, required this.isBot});

  /// Message text.
  final String text;

  /// True for bot message, false for user message.
  final bool isBot;
}

/// GetX controller for the landing page FAQ chatbot.
class FaqChatbotController extends GetxController {
  /// Creates the chatbot controller with predefined FAQ entries.
  FaqChatbotController({
    required List<FaqChatEntry> entries,
    this.greetingMessage = _kFaqChatGreetingMessage,
    this.fallbackMessage = _kFaqChatFallbackMessage,
  }) : _entries = entries;

  final List<FaqChatEntry> _entries;
  static const int _majorQuestionCount = 4;
  static const Set<String> _stopWords = {
    'a',
    'an',
    'and',
    'are',
    'as',
    'at',
    'be',
    'by',
    'can',
    'do',
    'for',
    'from',
    'how',
    'i',
    'in',
    'is',
    'it',
    'of',
    'on',
    'or',
    'the',
    'to',
    'we',
    'what',
    'when',
    'which',
    'with',
    'you',
    'your',
  };

  /// Initial bot greeting shown in the chat.
  final String greetingMessage;

  /// Bot reply used when no exact FAQ match is found.
  final String fallbackMessage;

  /// Input controller for the chat text field.
  final TextEditingController inputController = TextEditingController();

  /// Reactive chat transcript (user + bot).
  final RxList<FaqChatMessage> messages = <FaqChatMessage>[].obs;
  final RxBool isBotTyping = false.obs;
  final RxBool showMajorQuestions = true.obs;
  final RxList<FaqChatEntry> suggestedEntries = <FaqChatEntry>[].obs;

  /// Top suggested questions displayed as quick chips.
  List<FaqChatEntry> get majorEntries {
    final count = _entries.length < _majorQuestionCount
        ? _entries.length
        : _majorQuestionCount;
    return _entries.take(count).toList(growable: false);
  }

  @override
  void onInit() {
    super.onInit();
    messages.add(FaqChatMessage(text: greetingMessage, isBot: true));
    suggestedEntries.assignAll(majorEntries);
  }

  /// Sends one user message and appends bot response.
  Future<void> submitQuestion([String? value]) async {
    final question = (value ?? inputController.text).trim();
    if (question.isEmpty) return;
    if (isBotTyping.value) return;

    final bestEntry = _retrieveBestEntry(question);
    final response = bestEntry?.answer ?? fallbackMessage;

    inputController.clear();
    messages.add(FaqChatMessage(text: question, isBot: false));
    isBotTyping.value = true;
    showMajorQuestions.value = false;

    await Future<void>.delayed(_typingDelayFor(response));

    isBotTyping.value = false;
    messages.add(FaqChatMessage(text: response, isBot: true));
    suggestedEntries.assignAll(_suggestionsFor(bestEntry));
    showMajorQuestions.value = true;
  }

  List<FaqChatEntry> _suggestionsFor(FaqChatEntry? entry) {
    if (entry == null || entry.relatedQuestions.isEmpty) {
      return majorEntries;
    }

    final suggestions = <FaqChatEntry>[];
    for (final question in entry.relatedQuestions) {
      final match = _entries.firstWhereOrNull(
        (candidate) =>
            candidate.question.trim().toLowerCase() ==
            question.trim().toLowerCase(),
      );
      if (match != null) {
        suggestions.add(match);
      }
    }

    return suggestions.isEmpty ? majorEntries : suggestions;
  }

  Duration _typingDelayFor(String response) {
    final charCount = response.length;
    final ms = (charCount * 14).clamp(900, 2200);
    return Duration(milliseconds: ms);
  }

  FaqChatEntry? _retrieveBestEntry(String query) {
    final normalizedQuery = query.trim().toLowerCase();
    for (final entry in _entries) {
      if (entry.question.trim().toLowerCase() == normalizedQuery) {
        return entry;
      }
    }

    final queryTokens = _tokenize(normalizedQuery);
    if (queryTokens.isEmpty) return null;

    FaqChatEntry? best;
    var bestScore = 0;

    for (final entry in _entries) {
      final searchable = '${entry.question} ${entry.answer}'.toLowerCase();
      final entryTokens = _tokenize(searchable);
      if (entryTokens.isEmpty) continue;

      var overlap = 0;
      for (final token in queryTokens) {
        if (entryTokens.contains(token)) overlap++;
      }

      final phraseBonus = searchable.contains(normalizedQuery) ? 2 : 0;
      final score = overlap + phraseBonus;
      if (score > bestScore) {
        bestScore = score;
        best = entry;
      }
    }

    return bestScore > 0 ? best : null;
  }

  Set<String> _tokenize(String text) {
    final sanitized = text.replaceAll(RegExp(r'[^a-z0-9 ]'), ' ').trim();
    if (sanitized.isEmpty) return <String>{};
    return sanitized
        .split(RegExp(r'\s+'))
        .where((token) => token.length > 2 && !_stopWords.contains(token))
        .toSet();
  }

  @override
  void onClose() {
    inputController.dispose();
    messages.close();
    isBotTyping.close();
    showMajorQuestions.close();
    suggestedEntries.close();
    super.onClose();
  }
}

const _kFaqChatGreetingMessage =
    'Hi there! How can I help you today?';
const _kFaqChatFallbackMessage =
    "I couldn't find that in our FAQs. Please ask one of the listed FAQ questions.";
