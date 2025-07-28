import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:provider/provider.dart';
import 'package:skeleton/app/screens/home/quotes.dart';
import 'package:skeleton/app/theme/theme.dart';
import 'package:skeleton/app/helpers/core/shared_prefs.dart';
import 'home/components.dart';
import 'home/home.dart';
import 'home/movies.dart';
import 'settings/settings.dart';

class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key});

  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Home(),
    const Components(),
    const Quotes(),
    const Movies(),
    const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<Prefs>(
      builder: (context, prefs, child) {
        final isDarkMode =
            prefs.themeMode == ThemeMode.dark ||
            (prefs.themeMode == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);

        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(
                  isDarkMode ? TablerIcons.sun : TablerIcons.moon,
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppTheme.mutedForeground
                      : AppTheme.darkMutedForeground,
                ),
                onPressed: () {
                  final newTheme = isDarkMode ? 'light' : 'dark';
                  prefs.setTheme(selectedTheme: newTheme);
                },
              ),
            ],
          ),
          body: _pages[_currentIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppTheme.border
                      : AppTheme.darkBorder,
                  width: 1,
                ),
              ),
            ),
            child: NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) =>
                  setState(() => _currentIndex = index),
              destinations: [
                NavigationDestination(
                  icon: Icon(
                    TablerIcons.home_spark,
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppTheme.mutedForeground
                        : AppTheme.darkMutedForeground,
                  ),
                  selectedIcon: Icon(
                    TablerIcons.home_spark,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(
                    TablerIcons.components,
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppTheme.mutedForeground
                        : AppTheme.darkMutedForeground,
                  ),
                  selectedIcon: Icon(
                    TablerIcons.components,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: 'Samples',
                ),
                NavigationDestination(
                  icon: Icon(
                    TablerIcons.quote,
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppTheme.mutedForeground
                        : AppTheme.darkMutedForeground,
                  ),
                  selectedIcon: Icon(
                    TablerIcons.quote,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: 'Quotes',
                ),
                NavigationDestination(
                  icon: Icon(
                    TablerIcons.movie,
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppTheme.mutedForeground
                        : AppTheme.darkMutedForeground,
                  ),
                  selectedIcon: Icon(
                    TablerIcons.movie,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: 'Movies',
                ),
                NavigationDestination(
                  icon: Icon(
                    TablerIcons.settings,
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppTheme.mutedForeground
                        : AppTheme.darkMutedForeground,
                  ),
                  selectedIcon: Icon(
                    TablerIcons.settings_filled,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
