import 'package:flutter/material.dart';
import 'theme.dart';

class DiceWidget extends StatefulWidget {
  final int value;
  final bool isHeld;
  final VoidCallback onTap;
  final double size;
  final String? rank; // Add rank parameter

  const DiceWidget({
    super.key,
    required this.value,
    required this.isHeld,
    required this.onTap,
    this.size = 80.0,
    this.rank, // Optional rank display
  });

  @override
  State<DiceWidget> createState() => _DiceWidgetState();
}

class _DiceWidgetState extends State<DiceWidget> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      onTap: widget.onTap,
      child: Container(
        width: widget.size,
        height: widget.size,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/common/dice_background.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.isHeld
                ? VikingTheme.accentYellow
                : VikingTheme.bodyText.withValues(alpha: 0.3),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: isPressed ? const Offset(2, 2) : const Offset(4, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Large centered face value
            Center(
              child: Text(
                widget.value.toString(),
                style: TextStyle(
                  color: VikingTheme.accentYellow,
                  fontSize: widget.size * 0.5,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 2,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
            // Rank display if provided
            if (widget.rank != null)
              Positioned(
                top: 4,
                left: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: VikingTheme.cardBackground.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.rank!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: VikingTheme.accentYellow,
                      fontSize: widget.size * 0.2,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 1,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            // Hold indicator
            if (widget.isHeld)
              Positioned(
                right: 4,
                bottom: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: VikingTheme.cardBackground.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.lock,
                    color: VikingTheme.accentYellow,
                    size: widget.size * 0.25,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
