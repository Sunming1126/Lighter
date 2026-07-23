enum AppEnvironment { dev, staging, production }

class AppConfig {
  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.useMockRemote,
  });

  final AppEnvironment environment;
  final Uri apiBaseUrl;
  final bool useMockRemote;

  static final dev = AppConfig(
    environment: AppEnvironment.dev,
    apiBaseUrl: Uri.parse('https://api-dev.lighter.invalid/v1'),
    useMockRemote: true,
  );

  static final staging = AppConfig(
    environment: AppEnvironment.staging,
    apiBaseUrl: Uri.parse(
      const String.fromEnvironment(
        'LIGHTER_STAGING_API_BASE_URL',
        defaultValue: 'https://api-staging.lighter.invalid/v1',
      ),
    ),
    useMockRemote: const bool.fromEnvironment(
      'LIGHTER_USE_MOCK_REMOTE',
      defaultValue: false,
    ),
  );

  static final production = AppConfig(
    environment: AppEnvironment.production,
    apiBaseUrl: Uri.parse(
      const String.fromEnvironment(
        'LIGHTER_PRODUCTION_API_BASE_URL',
        defaultValue: 'https://api.lighter.invalid/v1',
      ),
    ),
    useMockRemote: false,
  );

  static AppConfig get current => switch (const String.fromEnvironment(
    'LIGHTER_ENV',
    defaultValue: 'dev',
  )) {
    'staging' => staging,
    'production' || 'prod' => production,
    _ => dev,
  };
}
