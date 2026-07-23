import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../profile/profile_screen.dart';
import '../progress/progress_screen.dart';
import '../today/today_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: const [TodayScreen(), ProgressScreen(), ProfileScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: [
          NavigationDestination(
            icon: const Icon(CupertinoIcons.clock),
            selectedIcon: const Icon(CupertinoIcons.clock_fill),
            label: s.today,
          ),
          NavigationDestination(
            icon: const Icon(CupertinoIcons.chart_bar),
            selectedIcon: const Icon(CupertinoIcons.chart_bar_fill),
            label: s.progress,
          ),
          NavigationDestination(
            icon: const Icon(CupertinoIcons.person),
            selectedIcon: const Icon(CupertinoIcons.person_fill),
            label: s.me,
          ),
        ],
      ),
    );
  }
}
