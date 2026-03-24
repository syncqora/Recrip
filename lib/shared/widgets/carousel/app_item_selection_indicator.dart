import 'package:flutter/material.dart';
import '../../themes/design.dart';

class AppItemSelectionIndicator extends StatelessWidget {
  final int selectedItemIndex;
  final int mediaListLength;

  const AppItemSelectionIndicator({
    Key? key,
    required this.selectedItemIndex,
    required this.mediaListLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    buildIndicatorDots();
    return mediaListLength == 1
        ? const SizedBox()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: buildIndicatorDots(),
          );
  }

  List<Widget> buildIndicatorDots() {
    final List<Widget> indicatorList = [];
    for (int i = 0; i < mediaListLength; i++) {
      indicatorList.add(
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i == selectedItemIndex
                ? Color(0xFF1E1E1E)
                : Color(0xFFD9D9D9),
          ),
          height: i == selectedItemIndex ? 8 : 6,
          width: i == selectedItemIndex ? 8 : 6,
        ),
      );
    }
    return indicatorList;
  }
}
