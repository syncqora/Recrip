import 'package:flutter/material.dart';
import 'package:get/get.dart';

final Set<Type> _openModals = {};

/// Opens [modal] with a bottom-to-top (fullscreen) animation when on mobile
/// (width < 600), otherwise as a dialog. Use this so mobile view modals
/// match the edit-action slide-up behavior.
///
/// Prevents opening the same modal type if it's already displayed.
void openModalWithTransition(BuildContext context, Widget modal) {
  final modalType = modal.runtimeType;
  if (_openModals.contains(modalType) || Get.isDialogOpen == true) return;
  _openModals.add(modalType);

  final width = MediaQuery.sizeOf(context).width;
  if (width < 600) {
    Navigator.of(context)
        .push<void>(
          MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (_) => modal,
          ),
        )
        .then((_) => _openModals.remove(modalType));
  } else {
    Get.dialog(
      modal,
      useSafeArea: false,
    ).then((_) => _openModals.remove(modalType));
  }
}

/// Opens a dialog with built-in duplicate prevention.
/// Returns false if the dialog was blocked (already open).
bool openDialogOnce(Widget dialog) {
  if (Get.isDialogOpen == true) return false;
  Get.dialog(dialog, useSafeArea: false);
  return true;
}
