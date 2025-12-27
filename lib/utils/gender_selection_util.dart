import 'package:flutter/material.dart';
import '../screens/theme/gender_selection_screen.dart';

/// Utility function to show gender selection popup dialog
///
/// Call this function to display the gender selection screen in a dialog
///
/// Parameters:
/// - [context]: BuildContext for navigation
/// - [onGenderChanged]: Callback function that receives the selected gender (true for girl, false for boy)
Future<void> showGenderSelectionPopup(
  BuildContext context, {
  required Function(bool) onGenderChanged,
}) {
  return showDialog(
    context: context,
    builder: (context) => GenderSelectionScreen(
      onGenderSelected: (gender) async {
        onGenderChanged(gender);
        Navigator.pop(context);
      },
    ),
  );
}
