import 'package:flutter/material.dart';

class ThemeUtils {
  static Color getContrastColor(Color color) {
    // Calculate the perceptive luminance (aka luma) - human eye favors green color
    final double luma = ((0.299 * color.red) + (0.587 * color.green) + (0.114 * color.blue)) / 255;
    // Return black for bright colors, white for dark colors
    return luma > 0.5 ? Colors.black : Colors.white;
  }

  static Color getReadableTextColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  static Color getSecondaryTextColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? Colors.white70 : Colors.black54;
  }

  static Color getBackgroundColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? Colors.grey[900]! : Colors.white;
  }

  static Color getCardColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? Colors.grey[800]! : Colors.white;
  }

  static Color getDividerColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? Colors.white24 : Colors.black12;
  }

  static TextStyle getTitleStyle(BuildContext context) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: getReadableTextColor(context),
    );
  }

  static TextStyle getSubtitleStyle(BuildContext context) {
    return TextStyle(
      fontSize: 14,
      color: getSecondaryTextColor(context),
    );
  }

  static TextStyle getBodyStyle(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      color: getReadableTextColor(context),
    );
  }
}