import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Opens [modal] with a bottom-to-top (fullscreen) animation when on mobile
/// (width < 600), otherwise as a dialog. Use this so mobile view modals
/// match the edit-action slide-up behavior.
void openModalWithTransition(BuildContext context, Widget modal) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < 600) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(fullscreenDialog: true, builder: (_) => modal),
    );
  } else {
    Get.dialog(modal);
  }
}
