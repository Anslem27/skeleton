import 'package:flutter/material.dart';

import '../theme/theme.dart';

class GenericInput extends StatelessWidget {
  final String? label;
  final String? placeholder;
  final TextEditingController? controller;
  final bool obscureText;

  const GenericInput({
    super.key,
    this.label,
    this.placeholder,
    this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppTheme.mutedForeground
                  : AppTheme.darkMutedForeground,
            ),
          ),
        ),
      ],
    );
  }
}
