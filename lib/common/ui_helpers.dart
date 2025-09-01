// lib/common/ui_helpers.dart
import 'package:flutter/material.dart';

/// Common reusable UI widgets across games with Viking theme.
class UIHelpers {
  /// Themed dropdown menu with Viking styling
  static Widget themedDropdown<T>({
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required String hint,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    return DropdownButton<T>(
      value: value,
      hint: Text(
        hint,
        style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
      ),
      items: items,
      onChanged: onChanged,
      dropdownColor: theme.colorScheme.secondary,
      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
      iconEnabledColor: theme.iconTheme.color,
      underline: Container(height: 2, color: theme.iconTheme.color),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  /// Standard player score/turn display with Viking theme
  static Widget playerStatus(
    BuildContext context,
    String name,
    int score, {
    bool isActive = false,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive
            ? theme.primaryColor.withValues(alpha: 0.3)
            : theme.colorScheme.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.iconTheme.color!, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.shield,
            color: isActive ? theme.primaryColor : Colors.grey,
          ),
          const SizedBox(width: 6),
          Text(
            "$name: $score",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  /// Viking-themed dice rendering for Liar’s Dice, Yatzy
  static Widget vikingDiceFace(
    BuildContext context,
    int value, {
    double size = 55,
  }) {
    final theme = Theme.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: theme.iconTheme.color!, width: 2),
        borderRadius: BorderRadius.circular(6),
        color: theme.cardColor,
      ),
      alignment: Alignment.center,
      child: Text(
        value.toString(),
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFFFD700), // Viking yellow
        ),
      ),
    );
  }

  /// Card rendering for Poker/Solitaire/Uno/Cribbage with Viking theme
  static Widget cardFace(
    BuildContext context,
    String label, {
    double width = 60,
    double height = 90,
  }) {
    final theme = Theme.of(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.iconTheme.color!, width: 2),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
      ),
    );
  }

  /// Action button with Viking theme
  static Widget actionButton(
    BuildContext context,
    String label,
    VoidCallback? onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: Theme.of(context).elevatedButtonTheme.style,
      child: Text(
        label,
        style: Theme.of(
          context,
        ).elevatedButtonTheme.style?.textStyle?.resolve({}),
      ),
    );
  }

  /// Generic status banner with Viking theme
  static Widget statusBanner(BuildContext context, String message) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.all(8),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
