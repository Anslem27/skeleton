import 'package:flutter/material.dart';
import 'package:skeleton/app/theme/theme.dart';
import 'package:skeleton/app/widgets/generic_card.dart';
import 'package:skeleton/app/widgets/generic_input.dart';

import '../../widgets/button.dart';

class Components extends StatelessWidget {
  const Components({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Components',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          GenericCard(
            title: 'Buttons',
            description: 'Different button variants',
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Button(text: 'Primary', onPressed: () {}),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Button(
                        text: 'Secondary',
                        variant: ButtonVariant.secondary,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Button(
                  text: 'Ghost Button',
                  variant: ButtonVariant.ghost,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GenericCard(
            title: 'Inputs',
            description: 'Form inputs with labels',
            child: Column(
              children: [
                const GenericInput(
                  label: 'Email',
                  placeholder: 'Enter your email',
                ),
                const SizedBox(height: 16),
                const GenericInput(
                  label: 'Password',
                  placeholder: 'Enter your password',
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                Button(text: 'Submit', onPressed: () {}),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GenericCard(
            title: 'Lists',
            description: 'Example list items',
            child: Column(
              children: [
                _ListItem(
                  title: 'Profile Settings',
                  subtitle: 'Manage your account preferences',
                  icon: Icons.person,
                ),
                _ListItem(
                  title: 'Notifications',
                  subtitle: 'Configure notification settings',
                  icon: Icons.notifications,
                ),
                _ListItem(
                  title: 'Privacy',
                  subtitle: 'Control your privacy settings',
                  icon: Icons.security,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _ListItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).brightness == Brightness.light
                ? AppTheme.border
                : AppTheme.darkBorder,
            width: 1,
          ),
        ),
      ),
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
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppTheme.mutedForeground
                        : AppTheme.darkMutedForeground,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 20,
            color: Theme.of(context).brightness == Brightness.light
                ? AppTheme.mutedForeground
                : AppTheme.darkMutedForeground,
          ),
        ],
      ),
    );
  }
}
