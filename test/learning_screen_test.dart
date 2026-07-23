import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lighter/core/theme/app_theme.dart';
import 'package:lighter/features/learning/learning_content.dart';
import 'package:lighter/features/learning/learning_screen.dart';
import 'package:lighter/l10n/app_localizations.dart';

void main() {
  Widget app({Locale locale = const Locale('zh')}) => MaterialApp(
    theme: buildLighterTheme(),
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    home: const LearningScreen(active: true),
  );

  testWidgets('shows five learning topics and opens a short article', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(app());
    await tester.pump();

    expect(find.byKey(const Key('learning-hero-carousel')), findsOneWidget);
    for (final id in ['safe', 'beginner', 'benefits', 'women', 'faq']) {
      expect(find.byKey(Key('learning-topic-$id')), findsOneWidget);
    }

    await tester.tap(find.byKey(const Key('learning-topic-beginner')));
    await tester.pumpAndSettle();

    expect(find.text('什么是间歇性断食？'), findsOneWidget);
    expect(find.text('你需要注意'), findsOneWidget);
    expect(find.text('医学资料来源'), findsOneWidget);

    await tester.tap(find.byKey(const Key('learning-article-back')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('learning-hero-carousel')), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('carousel advances, pauses after a swipe, then resumes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(app());
    await tester.pump();
    PageView pageView() => tester.widget<PageView>(find.byType(PageView));

    final start = pageView().controller!.page!;
    await tester.pump(const Duration(seconds: 4));
    await tester.pump(const Duration(milliseconds: 450));
    expect(pageView().controller!.page, closeTo(start + 1, .01));

    await tester.drag(find.byType(PageView), const Offset(-320, 0));
    await tester.pumpAndSettle();
    final afterSwipe = pageView().controller!.page!;

    await tester.pump(const Duration(seconds: 7));
    expect(pageView().controller!.page, closeTo(afterSwipe, .01));

    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 450));
    expect(pageView().controller!.page, closeTo(afterSwipe + 1, .01));

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('English content builds at large text scale without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          size: Size(390, 844),
          textScaler: TextScaler.linear(1.35),
        ),
        child: app(locale: const Locale('en')),
      ),
    );
    await tester.pump();

    expect(find.text('Learn'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('localized content exposes eight sourced articles', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(app());
    context = tester.element(find.byType(LearningScreen));
    final content = LearningContent.localized(AppLocalizations.of(context));

    expect(content.heroes, hasLength(5));
    expect(content.topics, hasLength(5));
    expect(content.articles, hasLength(8));
    expect(
      content.articles.every((article) => article.sources.isNotEmpty),
      isTrue,
    );

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
