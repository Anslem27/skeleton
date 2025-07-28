import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeleton/app/screens/logs.dart';
import 'package:skeleton/app/theme/theme.dart';
import 'package:skeleton/app/widgets/generic_card.dart';
import '../../helpers/core/shared_prefs.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Prefs>(
      builder: (context, prefs, child) {
        final currentTheme = prefs.theme ?? 'system';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              GenericCard(
                title: 'Appearance',
                description: 'Customize the look and feel',
                child: Column(
                  children: [
                    _SettingItem(
                      title: 'Theme',
                      subtitle: 'Switch between light, dark, and system mode',
                      trailing: DropdownButton<String>(
                        borderRadius: BorderRadius.circular(8),
                        value:
                            ['light', 'dark', 'system'].contains(currentTheme)
                            ? currentTheme
                            : 'system',
                        items: const [
                          DropdownMenuItem(
                            value: 'light',
                            child: Text('Light'),
                          ),
                          DropdownMenuItem(value: 'dark', child: Text('Dark')),
                          DropdownMenuItem(
                            value: 'system',
                            child: Text('System'),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            prefs.setTheme(selectedTheme: newValue);
                          }
                        },
                      ),
                    ),
                    _SettingItem(
                      title: 'Font Size',
                      subtitle: 'Adjust text size',
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GenericCard(
                title: 'About',
                description: 'App information',
                child: Column(
                  children: [
                    _SettingItem(title: 'Version', subtitle: '1.0.0'),
                    _SettingItem(title: 'Build', subtitle: 'Slate Theme Demo'),
                    _SettingItem(
                      title: 'Logs',
                      subtitle: 'See app logs',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AppLogs(),
                          ),
                        );
                      },
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SettingItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;
  final Function()? onTap;

  const _SettingItem({
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
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
            const SizedBox(width: 5),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
