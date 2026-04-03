import 'package:flutter/material.dart';

ThemeData popupMenuInteractionTheme(BuildContext context) {
  return Theme.of(context).copyWith(
    hoverColor: Colors.transparent,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    focusColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
  );
}
