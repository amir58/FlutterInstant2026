import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingOverlay {
  static BuildContext?
  _dialogContext; // Tracks the exact context of the dialog

  static void show(BuildContext context) {
    // Prevent opening multiple overlays simultaneously
    if (_dialogContext != null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        _dialogContext =
            dialogContext; // Capture the dialog's unique context

        return const PopScope(
          canPop:
              false, // Prevents Android back button from closing it
          child: Center(
            child: SpinKitFadingCircle(
              color: Colors.white,
              size: 50.0,
            ),
          ),
        );
      },
    ).then((_) {
      _dialogContext = null; // Reset when dismissed safely
    });
  }

  static void hide() {
    // Only close if the dialog context exists and is currently active
    if (_dialogContext != null && _dialogContext!.mounted) {
      Navigator.of(_dialogContext!).pop();
      _dialogContext = null;
    }
  }
}
