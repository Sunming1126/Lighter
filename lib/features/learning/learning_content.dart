import '../../l10n/app_localizations.dart';

enum LearningSection { beginner, benefits, women, faq }

class LearningSource {
  const LearningSource({required this.title, required this.url});

  final String title;
  final String url;
}

class LearningArticle {
  const LearningArticle({
    required this.id,
    required this.section,
    required this.title,
    required this.summary,
    required this.body,
    required this.safety,
    required this.assetPath,
    required this.sources,
  });

  final String id;
  final LearningSection section;
  final String title;
  final String summary;
  final String body;
  final String safety;
  final String assetPath;
  final List<LearningSource> sources;
}

class LearningHeroSlide {
  const LearningHeroSlide({
    required this.id,
    required this.title,
    required this.summary,
    required this.assetPath,
    required this.articleId,
  });

  final String id;
  final String title;
  final String summary;
  final String assetPath;
  final String articleId;
}

class LearningTopic {
  const LearningTopic({
    required this.id,
    required this.label,
    required this.articleId,
  });

  final String id;
  final String label;
  final String articleId;
}

class LearningContent {
  LearningContent._({
    required this.heroes,
    required this.topics,
    required this.articles,
  });

  final List<LearningHeroSlide> heroes;
  final List<LearningTopic> topics;
  final List<LearningArticle> articles;

  LearningArticle article(String id) =>
      articles.firstWhere((article) => article.id == id);

  List<LearningArticle> section(LearningSection value) =>
      articles.where((article) => article.section == value).toList();

  factory LearningContent.localized(AppLocalizations s) {
    final nia = LearningSource(
      title: s.learningSourceNia,
      url:
          'https://www.nia.nih.gov/news/research-intermittent-fasting-shows-health-benefits',
    );
    final review = LearningSource(
      title: s.learningSourceReview,
      url: 'https://pubmed.ncbi.nlm.nih.gov/40533200/',
    );
    final womenHormones = LearningSource(
      title: s.learningSourceWomenHormones,
      url: 'https://pubmed.ncbi.nlm.nih.gov/38866976/',
    );
    final treat = LearningSource(
      title: s.learningSourceTreat,
      url: 'https://pubmed.ncbi.nlm.nih.gov/32986097/',
    );
    final hopkins = LearningSource(
      title: s.learningSourceHopkins,
      url:
          'https://www.hopkinsmedicine.org/health/expert-qa/intermittent-fasting-what-is-it-and-how-does-it-work',
    );
    final ada = LearningSource(
      title: s.learningSourceAda,
      url:
          'https://diabetes.org/living-with-diabetes/hypoglycemia-low-blood-glucose/causes-prevention',
    );

    const safeImage = 'assets/images/learning/hero-safe-start.png';
    const beginnerImage = 'assets/images/learning/hero-beginner.png';
    const benefitsImage = 'assets/images/learning/hero-benefits.png';
    const womenImage = 'assets/images/learning/hero-women.png';
    const faqImage = 'assets/images/learning/hero-faq.png';

    final articles = <LearningArticle>[
      LearningArticle(
        id: 'what-is-fasting',
        section: LearningSection.beginner,
        title: s.learningArticleWhatTitle,
        summary: s.learningArticleWhatSummary,
        body: s.learningArticleWhatBody,
        safety: s.learningArticleWhatSafety,
        assetPath: safeImage,
        sources: [nia, hopkins],
      ),
      LearningArticle(
        id: 'start-12-12',
        section: LearningSection.beginner,
        title: s.learningArticleStartTitle,
        summary: s.learningArticleStartSummary,
        body: s.learningArticleStartBody,
        safety: s.learningArticleStartSafety,
        assetPath: beginnerImage,
        sources: [hopkins],
      ),
      LearningArticle(
        id: 'possible-benefits',
        section: LearningSection.benefits,
        title: s.learningArticleBenefitsTitle,
        summary: s.learningArticleBenefitsSummary,
        body: s.learningArticleBenefitsBody,
        safety: s.learningArticleBenefitsSafety,
        assetPath: benefitsImage,
        sources: [nia, review],
      ),
      LearningArticle(
        id: 'weight-comparison',
        section: LearningSection.benefits,
        title: s.learningArticleComparisonTitle,
        summary: s.learningArticleComparisonSummary,
        body: s.learningArticleComparisonBody,
        safety: s.learningArticleComparisonSafety,
        assetPath: benefitsImage,
        sources: [review, treat],
      ),
      LearningArticle(
        id: 'women-weight-management',
        section: LearningSection.women,
        title: s.learningArticleWomenTitle,
        summary: s.learningArticleWomenSummary,
        body: s.learningArticleWomenBody,
        safety: s.learningArticleWomenSafety,
        assetPath: womenImage,
        sources: [womenHormones, treat],
      ),
      LearningArticle(
        id: 'who-should-not-fast',
        section: LearningSection.women,
        title: s.learningArticleWhoTitle,
        summary: s.learningArticleWhoSummary,
        body: s.learningArticleWhoBody,
        safety: s.learningArticleWhoSafety,
        assetPath: safeImage,
        sources: [hopkins, ada],
      ),
      LearningArticle(
        id: 'water-and-coffee',
        section: LearningSection.faq,
        title: s.learningArticleCoffeeTitle,
        summary: s.learningArticleCoffeeSummary,
        body: s.learningArticleCoffeeBody,
        safety: s.learningArticleCoffeeSafety,
        assetPath: faqImage,
        sources: [hopkins],
      ),
      LearningArticle(
        id: 'fasted-exercise',
        section: LearningSection.faq,
        title: s.learningArticleExerciseTitle,
        summary: s.learningArticleExerciseSummary,
        body: s.learningArticleExerciseBody,
        safety: s.learningArticleExerciseSafety,
        assetPath: beginnerImage,
        sources: [hopkins],
      ),
    ];

    return LearningContent._(
      articles: articles,
      heroes: [
        LearningHeroSlide(
          id: 'safe',
          title: s.learningHeroSafetyTitle,
          summary: s.learningHeroSafetySummary,
          assetPath: safeImage,
          articleId: 'who-should-not-fast',
        ),
        LearningHeroSlide(
          id: 'beginner',
          title: s.learningHeroBeginnerTitle,
          summary: s.learningHeroBeginnerSummary,
          assetPath: beginnerImage,
          articleId: 'start-12-12',
        ),
        LearningHeroSlide(
          id: 'benefits',
          title: s.learningHeroBenefitsTitle,
          summary: s.learningHeroBenefitsSummary,
          assetPath: benefitsImage,
          articleId: 'possible-benefits',
        ),
        LearningHeroSlide(
          id: 'women',
          title: s.learningHeroWomenTitle,
          summary: s.learningHeroWomenSummary,
          assetPath: womenImage,
          articleId: 'women-weight-management',
        ),
        LearningHeroSlide(
          id: 'faq',
          title: s.learningHeroFaqTitle,
          summary: s.learningHeroFaqSummary,
          assetPath: faqImage,
          articleId: 'water-and-coffee',
        ),
      ],
      topics: [
        LearningTopic(
          id: 'safe',
          label: s.learningTopicSafety,
          articleId: 'who-should-not-fast',
        ),
        LearningTopic(
          id: 'beginner',
          label: s.learningTopicBeginner,
          articleId: 'what-is-fasting',
        ),
        LearningTopic(
          id: 'benefits',
          label: s.learningTopicBenefits,
          articleId: 'possible-benefits',
        ),
        LearningTopic(
          id: 'women',
          label: s.learningTopicWomen,
          articleId: 'women-weight-management',
        ),
        LearningTopic(
          id: 'faq',
          label: s.learningTopicFaq,
          articleId: 'water-and-coffee',
        ),
      ],
    );
  }
}
