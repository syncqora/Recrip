class RouteArgsModel {
  final String fromRoute;
  final String redirectTo;
  final dynamic arguments;

  RouteArgsModel({
    required this.fromRoute,
    required this.redirectTo,
    this.arguments,
  });
}
