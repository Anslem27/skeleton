import 'package:flutter/material.dart';
import 'package:skeleton/app/theme/theme.dart';
import 'package:skeleton/app/widgets/generic_card.dart';

import '../../widgets/button.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'A beautiful flutter theme app skeleton',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppTheme.mutedForeground
                  : AppTheme.darkMutedForeground,
            ),
          ),
          const SizedBox(height: 24),
          GenericCard(
            title: 'Getting Started',
            description:
                'Explore the components and see how they work together.',
            child: Column(
              children: [
                Button(text: 'Primary Button', onPressed: () {}),
                const SizedBox(height: 12),
                Button(
                  text: 'Secondary Button',
                  variant: ButtonVariant.secondary,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GenericCard(
            title: 'Theme Features',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FeatureItem(
                  icon: Icons.palette,
                  title: 'Color Palette',
                  description: 'Beautiful slate colors for modern UI',
                ),
                _FeatureItem(
                  icon: Icons.dark_mode,
                  title: 'Dark/Light Mode',
                  description: 'Seamless theme switching',
                ),
                _FeatureItem(
                  icon: Icons.design_services,
                  title: 'Clean Design',
                  description: 'Minimal and elegant components',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).brightness == Brightness.light
                ? AppTheme.mutedForeground
                : AppTheme.darkMutedForeground,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppTheme.mutedForeground
                        : AppTheme.darkMutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
