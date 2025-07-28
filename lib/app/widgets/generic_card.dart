import 'package:flutter/material.dart';

import '../theme/theme.dart';

class GenericCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? description;

  const GenericCard({
    super.key,
    required this.child,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
            ],
            if (description != null) ...[
              Text(
                description!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppTheme.mutedForeground
                      : AppTheme.darkMutedForeground,
                ),
              ),
              const SizedBox(height: 16),
            ],
            child,
          ],
        ),
      ),
    );
  }
}
