import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../learning/learning_screen.dart';
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
    final accent = LighterAccentPalette.of(context);
    return GlassScaffold(
      extendBody: true,
      edgeFade: false,
      background: const _LighterGlassBackground(),
      body: IndexedStack(
        index: index,
        children: [
          const TodayScreen(),
          const ProgressScreen(),
          LearningScreen(active: index == 2),
          const ProfileScreen(),
        ],
      ),
      bottomBar: GlassTabBar.bottom(
        selectedIndex: index,
        onTabSelected: (value) => setState(() => index = value),
        quality: GlassQuality.premium,
        barHeight: 62,
        horizontalPadding: 20,
        verticalPadding: 20,
        indicatorColor: accent.tint.withValues(alpha: .78),
        selectedIconColor: accent.pressed,
        unselectedIconColor: AppColors.muted,
        selectedLabelColor: accent.pressed,
        unselectedLabelColor: AppColors.muted,
        interactionGlowColor: accent.primary.withValues(alpha: .24),
        settings: LiquidGlassSettings(
          glassColor: Colors.white.withValues(alpha: .16),
          thickness: 24,
          blur: 8,
          chromaticAberration: .004,
          lightIntensity: .58,
          ambientStrength: .14,
          saturation: 1.15,
          shadowElevation: 2,
        ),
        tabs: [
          GlassTab(
            icon: const Icon(CupertinoIcons.clock),
            activeIcon: const Icon(CupertinoIcons.clock_fill),
            label: s.today,
          ),
          GlassTab(
            icon: const Icon(CupertinoIcons.chart_bar),
            activeIcon: const Icon(CupertinoIcons.chart_bar_fill),
            label: s.progress,
          ),
          GlassTab(
            icon: const Icon(CupertinoIcons.book),
            activeIcon: const Icon(CupertinoIcons.book_fill),
            label: s.learn,
          ),
          GlassTab(
            icon: const Icon(CupertinoIcons.person),
            activeIcon: const Icon(CupertinoIcons.person_fill),
            label: s.me,
          ),
        ],
      ),
    );
  }
}

class _LighterGlassBackground extends StatelessWidget {
  const _LighterGlassBackground();

  @override
  Widget build(BuildContext context) {
    final accent = LighterAccentPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.backgroundStart,
            accent.backgroundMiddle,
            accent.backgroundEnd,
          ],
          stops: const [0, .62, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -90,
            bottom: -110,
            child: _GlassGlow(color: accent.soft, size: 270),
          ),
          Positioned(
            right: -80,
            bottom: -70,
            child: _GlassGlow(color: AppColors.purpleTint, size: 230),
          ),
        ],
      ),
    );
  }
}

class _GlassGlow extends StatelessWidget {
  const _GlassGlow({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(
        colors: [color.withValues(alpha: .62), color.withValues(alpha: 0)],
      ),
    ),
  );
}
