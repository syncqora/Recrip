class NavigationRule {
  final String page;
  final bool Function() condition;
  final String redirectPage;
  final dynamic arguments;

  NavigationRule({
    required this.page,
    required this.condition,
    required this.redirectPage,
    this.arguments,
  });
}
