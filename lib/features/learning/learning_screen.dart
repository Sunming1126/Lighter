import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import 'learning_content.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key, required this.active});

  final bool active;

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen>
    with WidgetsBindingObserver {
  static const _slideDuration = Duration(seconds: 4);
  static const _manualPause = Duration(seconds: 8);
  static const _initialPage = 1000;

  final PageController _pageController = PageController(
    initialPage: _initialPage,
  );
  Timer? _timer;
  Timer? _resumeTimer;
  int _page = _initialPage;
  bool _appVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncTimer();
  }

  @override
  void didUpdateWidget(covariant LearningScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.active != widget.active) _syncTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appVisible = state == AppLifecycleState.resumed;
    _syncTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _resumeTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  bool get _reduceMotion =>
      MediaQuery.maybeOf(context)?.disableAnimations ?? false;

  void _syncTimer() {
    _timer?.cancel();
    _timer = null;
    if (!widget.active || !_appVisible || _reduceMotion) return;
    _timer = Timer.periodic(_slideDuration, (_) => _advanceCarousel());
  }

  void _pauseForManualInteraction() {
    _timer?.cancel();
    _resumeTimer?.cancel();
    _resumeTimer = Timer(_manualPause, () {
      if (widget.active && _appVisible && !_reduceMotion) {
        _advanceCarousel();
      }
      _syncTimer();
    });
  }

  void _advanceCarousel() {
    if (!_pageController.hasClients) return;
    _pageController.nextPage(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final content = LearningContent.localized(s);
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(title: s.learn, subtitle: s.learningSubtitle),
            Expanded(
              child: ListView(
                key: const PageStorageKey('learning-scroll'),
                padding: const EdgeInsets.fromLTRB(
                  22,
                  4,
                  22,
                  kFloatingNavigationClearance,
                ),
                children: [
                  _HeroCarousel(
                    controller: _pageController,
                    slides: content.heroes,
                    page: _page,
                    onPageChanged: (value) => setState(() => _page = value),
                    onManualInteraction: _pauseForManualInteraction,
                    onOpen: (id) => _openArticle(content, id),
                  ),
                  const SizedBox(height: 14),
                  _TopicStrip(
                    topics: content.topics,
                    onOpen: (id) => _openArticle(content, id),
                  ),
                  const SizedBox(height: 26),
                  _ArticleSection(
                    title: s.learningBeginnerGuide,
                    articles: content.section(LearningSection.beginner),
                    onOpen: (article) => _pushArticle(article),
                  ),
                  const SizedBox(height: 26),
                  _ArticleSection(
                    title: s.learningBenefitsSection,
                    articles: content.section(LearningSection.benefits),
                    onOpen: (article) => _pushArticle(article),
                  ),
                  const SizedBox(height: 26),
                  _ArticleSection(
                    title: s.learningWomenSection,
                    articles: content.section(LearningSection.women),
                    onOpen: (article) => _pushArticle(article),
                  ),
                  const SizedBox(height: 26),
                  _ArticleSection(
                    title: s.learningFaqSection,
                    articles: content.section(LearningSection.faq),
                    onOpen: (article) => _pushArticle(article),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openArticle(LearningContent content, String id) =>
      _pushArticle(content.article(id));

  Future<void> _pushArticle(LearningArticle article) =>
      Navigator.of(context).push(
        CupertinoPageRoute<void>(
          builder: (_) => LearningArticleScreen(article: article),
        ),
      );
}

class _HeroCarousel extends StatelessWidget {
  const _HeroCarousel({
    required this.controller,
    required this.slides,
    required this.page,
    required this.onPageChanged,
    required this.onManualInteraction,
    required this.onOpen,
  });

  final PageController controller;
  final List<LearningHeroSlide> slides;
  final int page;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onManualInteraction;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final activeIndex = page % slides.length;
    final largeText = MediaQuery.textScalerOf(context).scale(1) > 1.2;
    return Column(
      children: [
        SizedBox(
          height: largeText ? 280 : 210,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: NotificationListener<ScrollStartNotification>(
              onNotification: (notification) {
                if (notification.dragDetails != null) onManualInteraction();
                return false;
              },
              child: PageView.builder(
                key: const Key('learning-hero-carousel'),
                controller: controller,
                onPageChanged: onPageChanged,
                itemBuilder: (context, index) {
                  final slide = slides[index % slides.length];
                  return _HeroSlide(
                    slide: slide,
                    onTap: () => onOpen(slide.articleId),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 9),
        Semantics(
          label: '${activeIndex + 1} / ${slides.length}',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              slides.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: index == activeIndex ? 18 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: index == activeIndex
                      ? AppColors.accent
                      : AppColors.borderStrong,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroSlide extends StatelessWidget {
  const _HeroSlide({required this.slide, required this.onTap});

  final LearningHeroSlide slide;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: '${slide.title}. ${slide.summary}',
    child: Material(
      color: AppColors.surface,
      child: InkWell(
        key: Key('learning-hero-${slide.id}'),
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              slide.assetPath,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              semanticLabel: slide.title,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xF7FFFFFF),
                    Color(0xE8FFFFFF),
                    Color(0x00FFFFFF),
                  ],
                  stops: [0, .45, .76],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 24, 144, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .76),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      AppLocalizations.of(context).learningBeginHere,
                      style: const TextStyle(
                        color: AppColors.accentPressed,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    slide.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 22,
                      height: 1.18,
                      color: AppColors.strong,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    slide.summary,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.35,
                      color: AppColors.foreground,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _TopicStrip extends StatelessWidget {
  const _TopicStrip({required this.topics, required this.onOpen});

  final List<LearningTopic> topics;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    clipBehavior: Clip.none,
    child: Row(
      children: topics.map((topic) {
        final style = _topicStyle(topic.id);
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ActionChip(
            key: Key('learning-topic-${topic.id}'),
            onPressed: () => onOpen(topic.articleId),
            avatar: Icon(style.$1, size: 15, color: style.$2),
            label: Text(topic.label),
            labelStyle: const TextStyle(
              color: AppColors.foreground,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            side: BorderSide(color: Colors.white.withValues(alpha: .82)),
            backgroundColor: style.$3,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            shape: const StadiumBorder(),
          ),
        );
      }).toList(),
    ),
  );

  (IconData, Color, Color) _topicStyle(String id) => switch (id) {
    'safe' => (
      CupertinoIcons.shield_lefthalf_fill,
      AppColors.accentPressed,
      AppColors.accentTint,
    ),
    'beginner' => (
      CupertinoIcons.compass_fill,
      AppColors.water,
      AppColors.waterTint,
    ),
    'benefits' => (
      CupertinoIcons.leaf_arrow_circlepath,
      AppColors.weight,
      AppColors.weightTint,
    ),
    'women' => (
      CupertinoIcons.heart_fill,
      AppColors.coral,
      AppColors.coralTint,
    ),
    _ => (
      CupertinoIcons.question_circle_fill,
      AppColors.purple,
      AppColors.purpleTint,
    ),
  };
}

class _ArticleSection extends StatelessWidget {
  const _ArticleSection({
    required this.title,
    required this.articles,
    required this.onOpen,
  });

  final String title;
  final List<LearningArticle> articles;
  final ValueChanged<LearningArticle> onOpen;

  @override
  Widget build(BuildContext context) {
    final largeText = MediaQuery.textScalerOf(context).scale(1) > 1.2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title),
        SizedBox(
          height: largeText ? 248 : 232,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: articles.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) => _ArticleCard(
              article: articles[index],
              onTap: () => onOpen(articles[index]),
            ),
          ),
        ),
      ],
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article, required this.onTap});

  final LearningArticle article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 238,
    child: LighterCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(23)),
            child: SizedBox(
              width: double.infinity,
              height: 108,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    article.assetPath,
                    fit: BoxFit.cover,
                    alignment: Alignment.centerRight,
                    semanticLabel: article.title,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xF2FFFFFF),
                          Color(0xB8FFFFFF),
                          Color(0x00FFFFFF),
                        ],
                        stops: [0, .42, .7],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 112,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: Text(
                          article.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.strong,
                            fontSize: 13,
                            height: 1.25,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -.1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 13, 15, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    article.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.35,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class LearningArticleScreen extends StatelessWidget {
  const LearningArticleScreen({super.key, required this.article});

  final LearningArticle article;

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.background.withValues(alpha: .94),
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                key: const Key('learning-article-back'),
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(CupertinoIcons.back, size: 21),
                tooltip: s.back,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 38),
              sliver: SliverList.list(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: AspectRatio(
                      aspectRatio: 2,
                      child: Image.asset(
                        article.assetPath,
                        fit: BoxFit.cover,
                        semanticLabel: article.title,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    article.summary,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppColors.muted),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    article.body,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(height: 1.68),
                  ),
                  const SizedBox(height: 24),
                  LighterCard(
                    color: AppColors.coralTint,
                    borderColor: AppColors.coral.withValues(alpha: .16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          CupertinoIcons.heart_circle_fill,
                          color: AppColors.coral,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.learningAttention,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 7),
                              Text(
                                article.safety,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.foreground),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  SectionTitle(s.learningSources),
                  LighterCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (
                          var index = 0;
                          index < article.sources.length;
                          index++
                        ) ...[
                          _SourceRow(source: article.sources[index]),
                          if (index < article.sources.length - 1)
                            const Divider(height: 1, indent: 16, endIndent: 16),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    s.learningSourceFootnote,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      color: AppColors.faint,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({required this.source});

  final LearningSource source;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () async {
      await Clipboard.setData(ClipboardData(text: source.url));
      if (context.mounted) {
        showMessage(context, AppLocalizations.of(context).learningCopied);
      }
    },
    borderRadius: BorderRadius.circular(24),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.doc_text_search,
            color: AppColors.accentPressed,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              source.title,
              style: const TextStyle(
                color: AppColors.foreground,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(
            CupertinoIcons.doc_on_clipboard,
            color: AppColors.faint,
            size: 17,
          ),
        ],
      ),
    ),
  );
}
