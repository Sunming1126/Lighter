import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'core/contracts.dart';
import 'data/database/app_database.dart';
import 'data/repositories/app_repository.dart';
import 'data/services/notification_service.dart';

enum UnitSystem { imperial, metric }

enum LanguagePreference { system, zh, en }

final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError(),
);
final repositoryProvider = Provider<AppRepository>(
  (ref) => throw UnimplementedError(),
);
final authServiceProvider = Provider<AuthService>(
  (ref) => throw UnimplementedError(),
);
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => throw UnimplementedError(),
);
final appControllerProvider = ChangeNotifierProvider<AppController>(
  (ref) => throw UnimplementedError(),
);

final activeSessionProvider = StreamProvider<FastingSession?>((ref) {
  return ref.watch(repositoryProvider).watchActiveSession();
});

final sessionHistoryProvider = StreamProvider<List<FastingSession>>((ref) {
  return ref.watch(repositoryProvider).watchSessions();
});

final weightsProvider = StreamProvider<List<WeightEntry>>((ref) {
  return ref.watch(repositoryProvider).watchWeights();
});

final activePlanProvider = StreamProvider<FastingPlan?>((ref) {
  return ref.watch(repositoryProvider).watchPlan();
});

final waterEntriesProvider = StreamProvider.family<List<WaterEntry>, String>((
  ref,
  sessionId,
) {
  return ref.watch(repositoryProvider).watchWater(sessionId);
});

final dailyWaterProvider = StreamProvider.family<List<WaterEntry>, String>((
  ref,
  dateKey,
) {
  return ref
      .watch(repositoryProvider)
      .watchWaterForDay(DateTime.parse(dateKey));
});

final dailyHealthProvider = StreamProvider.family<DailyHealthLog?, String>((
  ref,
  dateKey,
) {
  return ref.watch(repositoryProvider).watchDailyHealth(dateKey);
});

String localDateKey(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-'
    '${value.month.toString().padLeft(2, '0')}-'
    '${value.day.toString().padLeft(2, '0')}';

class AppController extends ChangeNotifier {
  AppController({required this.repository, required this.authService});

  final AppRepository repository;
  final AuthService authService;

  bool initialized = false;
  bool onboardingComplete = false;
  int onboardingStep = 0;
  LanguagePreference language = LanguagePreference.system;
  UnitSystem unitSystem = UnitSystem.imperial;
  bool liquidMetric = false;
  AuthSession? authSession;

  Locale? get locale => switch (language) {
    LanguagePreference.system => null,
    LanguagePreference.zh => const Locale('zh'),
    LanguagePreference.en => const Locale('en'),
  };

  Future<void> initialize() async {
    final onboarding = await repository.loadOnboarding();
    onboardingComplete = onboarding?.completed ?? false;
    onboardingStep = onboarding?.currentStep ?? 0;
    language = _languageFrom(await repository.getPreference('language'));
    unitSystem = (await repository.getPreference('unitSystem')) == 'metric'
        ? UnitSystem.metric
        : UnitSystem.imperial;
    liquidMetric = (await repository.getPreference('liquidMetric')) == 'true';
    authSession = await authService.restore();
    await repository.ensureDefaultPlan();
    initialized = true;
    notifyListeners();
  }

  Future<void> completeOnboarding(Map<String, Object?> answers) async {
    onboardingComplete = true;
    onboardingStep = 10;
    await repository.saveOnboarding(
      currentStep: 10,
      completed: true,
      answers: answers,
    );
    notifyListeners();
  }

  Future<void> saveOnboardingProgress(
    int step,
    Map<String, Object?> answers,
  ) async {
    onboardingStep = step;
    await repository.saveOnboarding(
      currentStep: step,
      completed: false,
      answers: answers,
    );
    notifyListeners();
  }

  Future<void> setLanguage(LanguagePreference value) async {
    language = value;
    await repository.setPreference('language', value.name);
    notifyListeners();
  }

  Future<void> setUnits(UnitSystem value, {bool? metricLiquid}) async {
    unitSystem = value;
    if (metricLiquid != null) liquidMetric = metricLiquid;
    await repository.setPreference('unitSystem', value.name);
    await repository.setPreference('liquidMetric', liquidMetric.toString());
    notifyListeners();
  }

  Future<void> setAuthSession(AuthSession? value) async {
    authSession = value;
    notifyListeners();
  }

  Future<void> logout() async {
    await authService.logout();
    authSession = null;
    notifyListeners();
  }

  Future<File> exportJson() async {
    final data = await repository.exportSnapshot();
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/lighter-backup-${DateTime.now().millisecondsSinceEpoch}.json',
    );
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(data),
      flush: true,
    );
    return file;
  }

  Future<File> exportCsv() async {
    final data = await repository.exportSnapshot();
    final rows = <List<Object?>>[
      const [
        'recordType',
        'id',
        'startedAtUtcMs',
        'endedAtUtcMs',
        'targetMinutes',
        'endReason',
        'milliliters',
        'kilograms',
        'loggedAtUtcMs',
        'deletedAtUtcMs',
        'dateKey',
        'calories',
        'steps',
      ],
    ];
    for (final raw in (data['sessions'] as List<Object?>? ?? const [])) {
      final row = raw as Map<String, Object?>;
      rows.add([
        'fastingSession',
        row['id'],
        row['startedAtUtcMs'],
        row['endedAtUtcMs'],
        row['targetMinutes'],
        row['endReason'],
        null,
        null,
        null,
        row['deletedAtUtcMs'],
        null,
        null,
        null,
      ]);
    }
    for (final raw in (data['waterEntries'] as List<Object?>? ?? const [])) {
      final row = raw as Map<String, Object?>;
      rows.add([
        'waterEntry',
        row['id'],
        null,
        null,
        null,
        null,
        row['milliliters'],
        null,
        row['loggedAtUtcMs'],
        row['deletedAtUtcMs'],
        null,
        null,
        null,
      ]);
    }
    for (final raw in (data['weightEntries'] as List<Object?>? ?? const [])) {
      final row = raw as Map<String, Object?>;
      rows.add([
        'weightEntry',
        row['id'],
        null,
        null,
        null,
        null,
        null,
        row['kilograms'],
        row['loggedAtUtcMs'],
        row['deletedAtUtcMs'],
        null,
        null,
        null,
      ]);
    }
    for (final raw in (data['dailyHealthLogs'] as List<Object?>? ?? const [])) {
      final row = raw as Map<String, Object?>;
      rows.add([
        'dailyHealthLog',
        row['id'],
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        row['deletedAtUtcMs'],
        row['dateKey'],
        row['calories'],
        row['steps'],
      ]);
    }
    final csv = rows
        .map((row) => row.map(_csvCell).join(','))
        .join(Platform.lineTerminator);
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/lighter-records-${DateTime.now().millisecondsSinceEpoch}.csv',
    );
    await file.writeAsString('\uFEFF$csv', flush: true);
    return file;
  }

  Future<void> shareExport(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;
    final files = await Future.wait([exportJson(), exportCsv()]);
    await SharePlus.instance.share(
      ShareParams(
        files: files.map((file) => XFile(file.path)).toList(),
        subject: 'Lighter data export',
        sharePositionOrigin: origin,
      ),
    );
  }

  String _csvCell(Object? value) {
    if (value == null) return '';
    final text = value.toString();
    if (!text.contains(RegExp('[,"\\n\\r]'))) return text;
    return '"${text.replaceAll('"', '""')}"';
  }

  Future<void> clearData() async {
    await repository.clearLocalData();
    await authService.logout();
    authSession = null;
    onboardingComplete = false;
    onboardingStep = 0;
    language = LanguagePreference.system;
    unitSystem = UnitSystem.imperial;
    liquidMetric = false;
    await repository.ensureDefaultPlan();
    notifyListeners();
  }

  LanguagePreference _languageFrom(String? value) => switch (value) {
    'zh' => LanguagePreference.zh,
    'en' => LanguagePreference.en,
    _ => LanguagePreference.system,
  };
}
