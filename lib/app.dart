import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app_state.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/shell/app_shell.dart';
import 'l10n/app_localizations.dart';

class LighterApp extends ConsumerStatefulWidget {
  const LighterApp({super.key});

  @override
  ConsumerState<LighterApp> createState() => _LighterAppState();
}

class _LighterAppState extends ConsumerState<LighterApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final controller = ref.read(appControllerProvider);
    _router = GoRouter(
      initialLocation: controller.onboardingComplete ? '/app' : '/onboarding',
      refreshListenable: controller,
      redirect: (context, state) {
        final inOnboarding = state.matchedLocation == '/onboarding';
        if (!controller.onboardingComplete && !inOnboarding) {
          return '/onboarding';
        }
        if (controller.onboardingComplete && inOnboarding) return '/app';
        return null;
      },
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(path: '/app', builder: (context, state) => const AppShell()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(appControllerProvider);
    return MaterialApp.router(
      title: 'Lighter',
      debugShowCheckedModeBanner: false,
      theme: buildLighterTheme(),
      locale: controller.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      routerConfig: _router,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: MediaQuery.textScalerOf(
            context,
          ).clamp(minScaleFactor: .9, maxScaleFactor: 1.35),
        ),
        child: child!,
      ),
    );
  }
}
