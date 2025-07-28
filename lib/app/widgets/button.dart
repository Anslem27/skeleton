// Custom Components
import 'package:flutter/material.dart';

enum ButtonVariant { primary, secondary, ghost }

enum ButtonSize { small, medium, large }

class Button extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;

  const Button({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton(onPressed: onPressed, child: Text(text));
      case ButtonVariant.secondary:
        return OutlinedButton(onPressed: onPressed, child: Text(text));
      case ButtonVariant.ghost:
        return TextButton(onPressed: onPressed, child: Text(text));
    }
  }
}
